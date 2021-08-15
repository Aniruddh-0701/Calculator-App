import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppSettings();
  }
}

class _AppSettings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          constructImage(),
          Text(
            'This section is under construction.'
            '\nPlease wait for us to work\n',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget constructImage() {
    AssetImage assetImage = AssetImage('images/under_construction.jpg');
    Image image = Image(
      image: assetImage,
      width: 700,
      height: 400,
    );
    return Container(
        margin: EdgeInsets.all(10.0),
        child: Center(
          child: image,
        ));
  }
}
