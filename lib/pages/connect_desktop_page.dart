@JS()
library t;

import 'package:js/js.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:songtube_link_flutter/internal/styles.dart';

@JS()
external void download();

class ConnectDesktopPage extends StatefulWidget {
  const ConnectDesktopPage({super.key});

  @override
  State<ConnectDesktopPage> createState() => _ConnectDesktopPageState();
}

class _ConnectDesktopPageState extends State<ConnectDesktopPage> {

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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _downloadButton()
          ],
        )
      ],
    );
  }

  Widget _body() {
    return Container(
      child: Text('Download and run the link server\nto run this extension', textAlign: TextAlign.center, style: textStyle(context, opacity: 0.6, bold: false)),
    );
  }

  Widget _downloadButton() {
    return InkWell(
      onTap: () async {
        // Get release
        final release = await http.get(Uri.parse('https://api.github.com/repos/SongTube/songtube_link_server/releases/latest'));
        final jsonMap = jsonDecode(release.body);
        final assets = jsonMap['assets'] as List<dynamic>;
        final windows = assets.firstWhere((element) => element['name'] == 'installer_windows.exe');
        // final linux = assets.firstWhere((element) => element['name'] == 'linux_snap_bundle.zip');
        final link = windows['browser_download_url'];
        download();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: appColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1
            )
          ]
        ),
        child: Text('Download', style: textStyle(context, bold: true).copyWith(color: Colors.white)),
      ),
    );
  }

}