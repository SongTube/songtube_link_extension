// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:js/js.dart';
import 'package:http/http.dart' as http;

import 'package:songtube_link_flutter/internal/app_connection.dart';
import 'package:songtube_link_flutter/internal/models/device.dart';
import 'package:songtube_link_flutter/internal/shared_preferences.dart';
import 'package:songtube_link_flutter/internal/styles.dart';
import 'package:songtube_link_flutter/ui/video_details.dart';

@JS()
external void download();

class ConnectDevicePage extends StatefulWidget {
  const ConnectDevicePage({super.key});

  @override
  State<ConnectDevicePage> createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage> {

  String? currentUrl;

  // Connection Running Status
  bool connectToDeviceRunning = false;

  // Controller
  TextEditingController controller = TextEditingController(text: prefs.getString('lastSavedIp'));

  void getUrl() {
    var queryInfo = js.JsObject.jsify({'active': true, 'currentWindow': true});
    js.context['chrome']['tabs']?.callMethod('query', [
      queryInfo,
      (tabs) async {
        currentUrl = tabs[0]['url'];
        setState(() {});
      }
    ]);
  }

  void connectToDevice() async {
    setState(() {
      connectToDeviceRunning = true;
    });
    device = await AppConnection.searchForDevice();
    setState(() {
      connectToDeviceRunning = false;
    });
  }

  void manualConnect() async {
    if (connectToDeviceRunning) {
      return;
    }
    setState(() {
      connectToDeviceRunning = true;
    });
    final model = Device(name: 'Android Phone', uri: Uri.parse('http://${controller.text}:1458'));
    final result = await AppConnection.checkDevice(deviceOverride: model);
    if (result) {
      prefs.setString('lastSavedIp', controller.text);
      setState(() {
        device = model;
      });
    } else {
      setState(() {
        device = null;
      });
    }
    setState(() {
      connectToDeviceRunning = false;
    });
  }

  @override
  void initState() {
    getUrl();
    if (device != null) {
      AppConnection.checkDevice().then((value) {
        if (!value) {
          device = null;
          setState(() {});
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Body
        Expanded(child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _body(),
          ),
        )),
        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _deviceConnectionStatus(),
            const Spacer(),
            if (connectToDeviceRunning)
            const Padding(
              padding: EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
              child: SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(appColor), strokeWidth: 3)),
            ),
            if (device == null)
            // IP Box
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Device address...',
                    labelText: 'Manual connection',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: smallTextStyle(context),
                    suffixIcon: IconButton(
                      onPressed: () {
                        manualConnect();
                      },
                      icon: Icon(Icons.arrow_forward_ios, color: Theme.of(context).primaryColor, size: 18),
                    )
                  ),
                  style: subtitleTextStyle(context),
                  onSubmitted: (_) {
                    manualConnect();
                  },
                ),
              ),
            ),
            _connectButton()
          ],
        )
      ],
    );
  }

  Widget _body() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: device != null
        ? VideoDetails(link: kDebugMode ? 'https://www.youtube.com/watch?v=Zn-_1m4OMjU' : currentUrl)
        : Text('No device connected${connected ? '' : '\nDownload SongTube Link Server for auto-detect'}', textAlign: TextAlign.center, style: textStyle(context, opacity: 0.6, bold: false)),
    );
  }

  Widget _deviceConnectionStatus() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 18, top: 8, bottom: 8),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: device != null
              ? Text('Connected to: ', style: subtitleTextStyle(context).copyWith(color: appColor))
              : Text('Disconnected', style: subtitleTextStyle(context).copyWith(color: appColor))
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: device != null
              ? Text(device!.name, style: subtitleTextStyle(context, opacity: 0.6))
              : const SizedBox(),
          )
        ],
      ),
    );
  }

  Widget _connectButton() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: InkWell(
        onTap: () async {
          if (connected) {
            if (device != null) {
              device = null;
              setState(() {});
            } else {
              if (!connectToDeviceRunning) {
                connectToDevice();
              }
            }
          } else {
            download();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: device != null ? Colors.white : appColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1
              )
            ]
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: connected ? device != null
              ? Text('Disconnect', style: textStyle(context, bold: true).copyWith(color: appColor))
              : connectToDeviceRunning
                ? Text('Searching...', style: textStyle(context, bold: true).copyWith(color: Colors.white))
                : Text('Search for device', style: textStyle(context, bold: true).copyWith(color: Colors.white))
              : Text('Download', style: textStyle(context, bold: true).copyWith(color: Colors.white))
          ),
        ),
      ),
    );
  }
}