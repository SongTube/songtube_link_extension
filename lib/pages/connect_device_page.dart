import 'package:flutter/material.dart';
import 'package:songtube_link_flutter/internal/app_connection.dart';
import 'package:songtube_link_flutter/internal/shared_preferences.dart';
import 'package:songtube_link_flutter/internal/styles.dart';
import 'dart:js' as js;

import 'package:songtube_link_flutter/ui/video_details.dart';

class ConnectDevicePage extends StatefulWidget {
  const ConnectDevicePage({super.key});

  @override
  State<ConnectDevicePage> createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage> {

  String? currentUrl;

  // Connection Running Status
  bool connectToDeviceRunning = false;

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
        ? VideoDetails(link: 'https://www.youtube.com/watch?v=gzY8VH7eb8Y')
        : Text('No device connected', textAlign: TextAlign.center, style: textStyle(context, opacity: 0.6, bold: false)),
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
        onTap: () {
          if (device != null) {
            device = null;
            setState(() {});
          } else {
            if (!connectToDeviceRunning) {
              connectToDevice();
            }
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
            child: device != null
              ? Text('Disconnect', style: textStyle(context, bold: true).copyWith(color: appColor))
              : connectToDeviceRunning
                ? Text('Searching...', style: textStyle(context, bold: true).copyWith(color: Colors.white))
                : Text('Search for device', style: textStyle(context, bold: true).copyWith(color: Colors.white))),
        ),
      ),
    );
  }
}