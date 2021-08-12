import 'package:calculator_app/Views/InterestCalculator.dart';
import 'package:calculator_app/Views/Settings.dart';
import 'package:calculator_app/Views/UnitConverter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:calculator_app/Views/Sci_Calculator.dart';
import 'package:calculator_app/Views/SimpleCalci.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class SecondScreen extends StatelessWidget {
  // This widget is the root of your application.
  final ThemeData theme = ThemeData();
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
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.white),
        primaryColorDark: Colors.grey[400],
        // primaryColorBrightness: Brightness.dark,
        // brightness: Brightness.dark,
        backgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class ScientificCalculator extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Simple Calculator", Icons.calculate),
    new DrawerItem("Scientific Calculator", Icons.calculate_outlined),
    new DrawerItem("Interest Calculator", Icons.monetization_on_outlined),
    new DrawerItem("Unit Converter", Icons.compare_arrows_rounded),
    new DrawerItem("Settings", Icons.settings)
  ];

  @override
  State<StatefulWidget> createState() {
    return _ScientificCalculator();
  }
}

class _ScientificCalculator extends State<ScientificCalculator> {
  int _selectedDrawerIndex = 0;
  String scaffoldTitle = 'Calculator';
  final drawerItems = [
    'Calculator',
    'Scientific Calculator',
    'Interest Calculator',
    'Unit Converter',
    'Settings',
  ];

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return Calci();
      case 1:
        return SCalci();
      case 2:
        return SiForm();
      case 3:
        return UnitConverter();
      case 4:
        return Settings();
      default:
        return Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
      scaffoldTitle = drawerItems[index];
    });
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          this.scaffoldTitle,
          style: TextStyle(
            fontSize:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 0.05 * MediaQuery.of(context).size.height
                    : 0.0255 * MediaQuery.of(context).size.height,
          ),
        ),
        toolbarHeight:
            MediaQuery.of(context).orientation == Orientation.landscape
                ? 0.14 * MediaQuery.of(context).size.height
                : 0.075 * MediaQuery.of(context).size.height,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Apps'),
            ),
            Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
