import 'package:shared_preferences/shared_preferences.dart';
import 'package:songtube_link_flutter/internal/models/device.dart';

late SharedPreferences prefs;

const connectedKey = 'connected';
const deviceKey = 'device';

bool get connected => prefs.getBool(connectedKey) ?? false;
set connected(bool value) {
  prefs.setBool(connectedKey, value);
}

Device? get device => prefs.getString(deviceKey) != null
  ? Device.fromJson(prefs.getString(deviceKey)!) : null;
set device(Device? item) {
  if (item != null) {
    prefs.setString(deviceKey, item.toJson());
  } else {
    prefs.remove(deviceKey);
  }
}

