import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';
// import 'package:string_validator/string_validator.dart';
import 'package:flutter/material.dart';
import 'package:calculator_app/back_ends/Calculation.dart';
import 'package:flutter/widgets.dart';

List eqn = ['0'];

class SecondScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Calculator"),
        ),
        body: Padding(padding: EdgeInsets.zero, child: Center(child: Calci())),
      ),
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

class Calci extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Calci();
  }
}

class _Calci extends State<Calci> {
  TextEditingController expr = TextEditingController();
  TextEditingController base = TextEditingController();
  bool inv = false;
  var angle = ['rad', 'deg'];
  var _defAngle = 'rad';
  var b = '2';

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            // Expression
            TextField(
                controller: expr,
                readOnly: true,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'Enter an expression',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                )),

            Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: [
                    // deg - rad
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          height: 35,
                          margin: EdgeInsets.only(top: 5.0, right: 2.5),
                          child: Text(
                            'Inv',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.right,
                          ),
                        )),
                        Expanded(
                            child: Container(
                          height: 30,
                          margin:
                              EdgeInsets.only(top: 2.5, left: 2.5, bottom: 5.0),
                          child: Switch(
                            value: inv,
                            onChanged: (bool v) => setState(() => inv = v),
                          ),
                        )),
                        Expanded(
                            child: Text(
                          '\u{1d703} =',
                          style: TextStyle(color: Colors.black45),
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                            child: Container(
                                height: 35,
                                margin: EdgeInsets.all(2.5),
                                child: DropdownButton(
                                  items: angle
                                      .map((String a) => DropdownMenuItem(
                                            child: Text(
                                              a,
                                              style: TextStyle(
                                                  color: Colors.black45),
                                            ),
                                            value: a,
                                          ))
                                      .toList(),
                                  onChanged: (String a) => setState(() {
                                    this._defAngle = a;
                                  }),
                                  value: _defAngle,
                                ))),
                        Expanded(
                            child: Text(
                          'n =',
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                            child: Container(
                                height: 35,
                                margin: EdgeInsets.all(2.5),
                                child: TextField(
                                  controller: base,
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (String base) {
                                    this.b = base;
                                  },
                                  decoration: InputDecoration(
                                    // labelText: 'base',

                                    hintText: '2',
                                  ),
                                ))),
                      ],
                    ),

                    // trig
                    Row(
                      children: [
                        // sin
                        Expanded(
                          child: trigButton(context, 'sin'),
                        ),

                        // cos
                        Expanded(
                          child: trigButton(context, 'cos'),
                        ),

                        // tan
                        Expanded(
                          child: trigButton(context, 'tan'),
                        ),
                      ],
                    ),

                    // log
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {},
                                child: Text(
                                  'ln',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {},
                                child: Text(
                                  'log\u{2099}',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {
                                  eqn.add('(');
                                  expr.text = eqn.join(' ');
                                },
                                child: Text(
                                  '(',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                      ],
                    ),

                    //pow
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {},
                                child: Text(
                                  'x\u{02b8}',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {},
                                child: Text(
                                  '\u{221a}',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {
                                  eqn.add(')');
                                  expr.text = eqn.join(' ');
                                },
                                child: Text(
                                  ')',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                      ],
                    ),

                    //const
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {},
                                child: Text(
                                  'e\u{02e3}',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {},
                                child: Text(
                                  '\u{212F}',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                        Expanded(
                          child: Container(
                              height: 35,
                              margin: EdgeInsets.all(2.5),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) => Colors.white)),
                                onPressed: () {},
                                child: Text(
                                  '\u{1d70b}',
                                  style: TextStyle(color: Colors.black45),
                                  textScaleFactor: 1.5,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        //AC
                        Expanded(
                            child: Container(
                                height: 35,
                                margin: EdgeInsets.all(2.5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.white)),
                                  onPressed: () => setState(() {
                                    eqn = ['0'];
                                    expr.text = eqn.join(' ');
                                  }),
                                  child: Text(
                                    'AC',
                                    style: TextStyle(color: Colors.black45),
                                    textScaleFactor: 1.5,
                                  ),
                                ))),

                        // CE
                        Expanded(
                            child: Container(
                                height: 35,
                                margin: EdgeInsets.all(2.5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.white)),
                                  onPressed: () => setState(() {
                                    eqn = ['0'];
                                    expr.text = eqn.join(' ');
                                  }),
                                  child: Text(
                                    'C',
                                    style: TextStyle(color: Colors.black45),
                                    textScaleFactor: 1.5,
                                  ),
                                ))),

                        //BKSP
                        Expanded(
                            child: Container(
                                height: 30,
                                margin: EdgeInsets.all(2.5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Colors.white)),
                                  onPressed: () => setState(() {
                                    try {
                                      if (eqn.last.length == 1)
                                        eqn.removeLast();
                                      else
                                        eqn.last = eqn.last
                                            .substring(0, eqn.last.length - 1);
                                      if (eqn.length == 0) eqn = ['0'];
                                    } catch (e) {}
                                    expr.text = eqn.join(' ');
                                  }),
                                  child: Text(
                                    '\u{232b}',
                                    style: TextStyle(color: Colors.black45),
                                    textScaleFactor: 1.5,
                                  ),
                                ))),

                        //div
                        Expanded(
                          child: opButton(context, '\u{00F7}'),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: numButton(context, '7'),
                        ),
                        Expanded(
                          child: numButton(context, '8'),
                        ),
                        Expanded(
                          child: numButton(context, '9'),
                        ),
                        Expanded(
                          child: opButton(context, '\u{00D7}'),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: numButton(context, '4'),
                        ),
                        Expanded(
                          child: numButton(context, '5'),
                        ),
                        Expanded(
                          child: numButton(context, '6'),
                        ),
                        Expanded(
                          child: opButton(context, '\u{2212}'),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: numButton(context, '1'),
                        ),
                        Expanded(
                          child: numButton(context, '2'),
                        ),
                        Expanded(
                          child: numButton(context, '3'),
                        ),
                        Expanded(
                          child: opButton(context, '\u{002b}'),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: numButton(context, '0'),
                        ),
                        Expanded(
                          child: numButton(context, '.'),
                        ),
                        Expanded(
                          child: numButton(context, 'E'),
                        ),
                        Expanded(
                            child: Container(
                                height: 35,
                                margin: EdgeInsets.all(2.5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) => Theme.of(context)
                                                  .primaryColor)),
                                  onPressed: () => setState(() {
                                    var cal = Calculate(eqn,
                                        rad: _defAngle == 'rad' ? 1 : 0);
                                    eqn = ['0'];
                                    expr.text = cal.calculate().toString();
                                  }),
                                  child: Text(
                                    '=',
                                    style: TextStyle(color: Colors.white),
                                    textScaleFactor: 1.5,
                                  ),
                                ))),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ],
        ));
  }

  Widget numButton(context, String num) {
    final button = Container(
        height: 35,
        margin: EdgeInsets.all(2.5),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white)),
          child: Text(
            num,
            textScaleFactor: 1.5,
            style: TextStyle(
                color: Colors.black45), // Theme.of(context).primaryColorDark,),
          ),
          onPressed: () => setState(() {
            if (num != '.' && eqn.length == 1 && eqn[0] == '0')
              eqn[0] = num;
            else if (isNumeric(eqn.last))
              eqn.last += num;
            else
              eqn.add(num);
            expr.text = eqn.join(' ');
          }),
        ));
    return button;
  }

  Widget opButton(context, String op) {
    final button = Container(
      height: 35,
      margin: EdgeInsets.all(2.5),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    )),
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => Colors.white60)),
        child: Text(
          op,
          textScaleFactor: 1.5,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () => setState(() {
          eqn.add(op);
          expr.text = eqn.join(' ');
        }),
      ),
    );
    return button;
  }

  Widget trigButton(context, String fn) {
    final button = Container(
        height: 35,
        margin: EdgeInsets.all(2.5),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.white)),
          child: Text(
            fn,
            textScaleFactor: 1.5,
            style: TextStyle(
                color: Colors.black45), // Theme.of(context).primaryColorDark,),
          ),
          onPressed: () => setState(() => addTrig(fn)),
        ));
    return button;
  }

  addTrig(fn) {
    if (eqn.length != 1 || (eqn.length == 1 && eqn.first != '0')) {
      if (isNumeric(eqn.last)) eqn.add('\u{00d7}');
    } else {
      eqn.removeLast();
    }
    if (inv == false) {
      eqn.add(fn);
    } else {
      eqn.add('arc' + fn);
    }
    eqn.add('(');
    expr.text = eqn.join(' ');
  }
}

// Symbols
// + : \u{002b}
// - : \u{2212}
// * : \u{00d7}
// / : \u{00f7}
// bksp: \u{232b}
