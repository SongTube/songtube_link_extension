import 'package:flutter/material.dart';
import 'package:songtube_link_flutter/internal/styles.dart';

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
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: appColor
      ),
      child: Text('Download', style: textStyle(context, bold: true).copyWith(color: Colors.white)),
    );
  }

}