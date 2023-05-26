import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:songtube_link_flutter/internal/app_connection.dart';
import 'package:songtube_link_flutter/internal/shared_preferences.dart';
import 'package:songtube_link_flutter/internal/styles.dart';
import 'package:songtube_link_flutter/pages/connect_desktop_page.dart';
import 'package:songtube_link_flutter/pages/connect_device_page.dart';
import 'package:songtube_link_flutter/ui/app_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Init Shared Preferences
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SongTube Link Flutter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: appColor,
      ),
      home: const Main()
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  void initState() {
    initConnection();
    super.initState();
  }

  void initConnection() async {
    connected = await AppConnection.connect();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: const [
            ExtensionAppBar(),
            Expanded(child: ConnectDevicePage())
          ],
        )
      ),
    );
  }
}