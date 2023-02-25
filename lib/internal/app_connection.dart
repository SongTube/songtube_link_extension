import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:songtube_link_flutter/internal/models/device.dart';
import 'package:songtube_link_flutter/internal/shared_preferences.dart';

const _desktopHost = 'http://localhost:1458';

class AppConnection {

  // Connect this extension to the desktop app
  static Future<bool> connect() async {
    try {
      final response = await http.get(Uri.parse('$_desktopHost/ping'));
      return response.body == 'pong';
    } catch (_) {
      return false;
    }
  }

  /// Connect this extension to the SongTube App using the Desktop App
  /// Example Json response would be as follow:
  /// {
  ///   "name": "xiaomi",
  ///   "uri": "<ip>:1458"
  /// }
  static Future<Device?> searchForDevice() async {
    try {
      final response = await http.get(Uri.parse('$_desktopHost/detect'));
      if (response.body == 'notfound') {
        return null;
      } else {
        final jsonMap = jsonDecode(response.body);
        final name = jsonMap['name'];
        final uri = Uri.parse('http://${jsonMap['host']}:1458');
        return Device(name: name, uri: uri);
      }
    } catch (_) {
      connected = false;
      return null;
    }
  }

  // Check if the connection to device is alive
  static Future<bool> checkDevice() async {
    try {
      final response = await http.get(Uri.parse('${device!.uri.toString()}/ping'));
      return response.body == 'pong';
    } catch (_) {
      return false;
    }
  }

  /// Send a link to the device for view/download, return value of true
  /// means the post request was successful, otherwise device is disconnected
  static Future<bool> sendLink(String url, {required bool isDownload}) async {
    final status = await checkDevice();
    if (!status) {
      return false;
    }
    final body = jsonEncode({
      'type': isDownload ? 'download' : 'view',
      'url': url
    });
    final response = await http.post(Uri.parse('${device!.uri.toString()}/sendLink'),
      body: body);
    if (response.body == 'success') {
      return true;
    } else {
      return false;
    }
  }

}