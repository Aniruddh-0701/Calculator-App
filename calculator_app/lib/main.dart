import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './app_screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calculator',
        home: MyHomePage(),
        theme: ThemeData(
          primaryColor: Colors.blueGrey,
          colorScheme: theme.colorScheme.copyWith(secondary: Colors.white),
          primaryColorDark: Colors.grey[400],
          backgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SecondScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffffcc00),
      child: StartLogo(),
    );
  }
}

class StartLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/icon.png');
    Image image = Image(
      image: assetImage,
      width: 440.5,
      height: 228.0,
    );
    return Container(
        child: Center(
      child: image,
    ));
  }
}
