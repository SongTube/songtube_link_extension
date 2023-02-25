import 'package:flutter/material.dart';
import 'package:songtube_link_flutter/internal/styles.dart';

class ExtensionAppBar extends StatelessWidget {
  const ExtensionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // App Logo
        Image.asset('assets/logo.png', height: 42, width: 42),
        const SizedBox(width: 12),
        // App Title
        Text('SongTube', style: textStyle(context, bold: true).copyWith(fontSize: 22)),
        const SizedBox(width: 4),
        // App Type
        Text('Link', style: textStyle(context, bold: true).copyWith(color: appColor, fontSize: 22)),
      ],
    );
  }
}