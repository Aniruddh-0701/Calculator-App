import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:calculator_app/Views/Sci_Calculator.dart';
import 'package:calculator_app/Views/SimpleCalci.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}


class SecondScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: ScientificCalculator(),
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.blueAccent,
        // primaryColorDark: Colors.green,
        primaryColorBrightness: Brightness.dark,
        // brightness: Brightness.dark,
        backgroundColor: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class ScientificCalculator extends StatefulWidget{
  final drawerItems = [
    new DrawerItem("Simple Calculator", Icons.calculate),
    new DrawerItem("Scientific Calculator", Icons.calculate_outlined),
    // new DrawerItem("Fragment 3", FeatherIcons.calendar)
  ];

  @override
  State<StatefulWidget> createState() {
    return _ScientificCalculator();
  }
}

class _ScientificCalculator extends State<ScientificCalculator>{

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return Calci();
      case 1:
        return SCalci();
      // case 2:
        // return new ThirdFragment();
      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Text('Apps'),
            ),
            Column(children: drawerOptions)
          ],
        ),
      ),
      body: Padding(
          padding: EdgeInsets.zero,
          child: Center(
              child: _getDrawerItemWidget(_selectedDrawerIndex)
          )),
    );
  }
}
