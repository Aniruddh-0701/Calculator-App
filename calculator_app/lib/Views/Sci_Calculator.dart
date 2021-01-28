import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:calculator_app/back_ends/Calculation.dart';
import 'package:calculator_app/back_ends/CalculatorFunctions.dart';
import 'package:flutter/widgets.dart';

List equation = ['0'];

class SCalci extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SCalci();
  }
}

class _SCalci extends State<SCalci> {
  TextEditingController expr = TextEditingController();
  TextEditingController base = TextEditingController();
  bool inv = false;
  bool hyp = false;
  var angle = ['rad', 'deg'];
  var _defAngle = 'rad';
  String b = '10';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            // Expression box
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

            // Keys
            Row(
              children: <Widget>[

                // Functions and Constants
                Expanded(
                    child: Column(
                      children: [
                        // deg - rad, inv,
                        Row(
                          children: [
                            // hyp
                            Expanded(
                                child: Container(
                                  height: 35,
                                  margin: EdgeInsets.only(top: 5.0, right: 2.5),
                                  child: Text(
                                    'Hyp',
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
                                    value: hyp,
                                    onChanged: (bool v) => setState(() => hyp = v),
                                  ),
                                )),

                            // deg-rad,
                            Container(
                                width: 55,
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
                                  onChanged: (var a) => setState(() {
                                    this._defAngle = a.toString();
                                  }),
                                  value: _defAngle,
                                )),
                            // log base
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
                                    child: TextFormField(
                                      controller: base,
                                      validator: ((val) => val!.isEmpty && !isNumeric(val)
                                          ? 'Invalid base'
                                          : null),
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (String base){
                                        setState(()=> this.b = base);
                                      },
                                      decoration: InputDecoration(
                                        // labelText: 'base',

                                        hintText: '10',
                                      ),
                                    ))),
                          ],
                        ),

                        // log, inv, (
                        Row(
                          children: [

                            // inv
                            Expanded(
                              child: Container(
                                  height: 35,
                                  margin: EdgeInsets.all(2.5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                                (states) => inv?
                                                Colors.deepOrange :
                                                Colors.white60
                                        )),
                                    onPressed: () => setState((){
                                      if (inv) inv = false;
                                      else inv = true;
                                    })
                                    ,
                                    child: Text(
                                      'Inv',
                                      style: TextStyle(color: Colors.black45),
                                      textScaleFactor: 1.5,
                                    ),
                                  )),
                            ),

                            // log_base
                            Expanded(
                                child: logButton(context, 'log', b)),

                            // (
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
                                      equation.add('(');
                                      expr.text = equation.join(' ');
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

                        // pow
                        Row(
                          children: [

                            // x^y
                            Expanded(
                              child: Container(
                                  height: 35,
                                  margin: EdgeInsets.all(2.5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                                (states) => Colors.white)),
                                    onPressed: (){
                                      this.inv? addPowers('\u{221a}')
                                          : addPowers('^');
                                    },
                                    child: Text(
                                      this.inv? '\u{221a}':'^',
                                      style: TextStyle(color: Colors.black45),
                                      textScaleFactor: 1.5,
                                    ),
                                  )
                              ),
                            ),

                            // ln
                            Expanded(
                                child: logButton(context, 'log', 'e'),
                            ),


                            // )
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
                                      equation.add(')');
                                      expr.text = equation.join(' ');
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

                        // const
                        Row(
                          children: [
                            // factorial
                            Expanded(
                                child: numButton(context, '!')
                            ),

                            // Euler const
                            Expanded(
                              child: numButton(context, 'e')
                            ),

                            // pi
                            Expanded(
                                child: numButton(context, '\u{1d70b}')),
                          ],
                        ),
                      ],
                    )),

                // Num Pad
                Expanded(
                    child: Column(
                      children: [
                        // C, AC
                        Row(
                          children: <Widget>[
                            // AC
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
                                        equation = ['0'];
                                        expr.text = equation.join(' ');
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
                                        equation = ['0'];
                                        expr.text = equation.join(' ');
                                      }),
                                      child: Text(
                                        'C',
                                        style: TextStyle(color: Colors.black45),
                                        textScaleFactor: 1.5,
                                      ),
                                    ))),

                            // BKSP
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
                                          if (equation.last.length == 1)
                                            equation.removeLast();
                                          else
                                            equation.last = equation.last
                                                .substring(0, equation.last.length - 1);
                                          if (equation.length == 0) equation = ['0'];
                                        } catch (e) {}
                                        expr.text = equation.join(' ');
                                      }),
                                      child: Text(
                                        '\u{232b}',
                                        style: TextStyle(color: Colors.black45),
                                        textScaleFactor: 1.5,
                                      ),
                                    ))),

                            // div
                            Expanded(
                              child: opButton(context, '\u{00F7}'),
                            ),
                          ],
                        ),
                        // 7-9
                        Row(
                          children: <Widget>[
                            // 7
                            Expanded(
                              child: numButton(context, '7'),
                            ),
                            // 8
                            Expanded(
                              child: numButton(context, '8'),
                            ),
                            // 9
                            Expanded(
                              child: numButton(context, '9'),
                            ),
                            // mul
                            Expanded(
                              child: opButton(context, '\u{00D7}'),
                            ),
                          ],
                        ),
                        // 4-6
                        Row(
                          children: <Widget>[
                            // 4
                            Expanded(
                              child: numButton(context, '4'),
                            ),
                            // 5
                            Expanded(
                              child: numButton(context, '5'),
                            ),
                            // 6
                            Expanded(
                              child: numButton(context, '6'),
                            ),
                            // sub
                            Expanded(
                              child: opButton(context, '\u{2212}'),
                            ),
                          ],
                        ),
                        // 1-3
                        Row(
                          children: <Widget>[
                            // 1
                            Expanded(
                              child: numButton(context, '1'),
                            ),
                            // 2
                            Expanded(
                              child: numButton(context, '2'),
                            ),
                            // 3
                            Expanded(
                              child: numButton(context, '3'),
                            ),
                            // add
                            Expanded(
                              child: opButton(context, '\u{002b}'),
                            ),
                          ],
                        ),
                        // 0.E
                        Row(
                          children: <Widget>[
                            // 0
                            Expanded(
                              child: numButton(context, '0'),
                            ),
                            // decimal
                            Expanded(
                              child: numButton(context, '.'),
                            ),
                            // E
                            Expanded(
                              child: numButton(context, 'E', isDisabled: 0),
                            ),
                            // =
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
                                        var cal = Calculate(equation,
                                            rad: _defAngle == 'rad' ? 1 : 0);
                                        equation = ['0'];
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

  Widget numButton(BuildContext context, String num, {int isDisabled = 0}) {
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
          onPressed: isDisabled==1 ? null: () => setState(() {
            if (num != '.' && equation.length == 1 && equation[0] == '0')
              equation[0] = num;
            else if (isNumeric(equation.last))
              equation.last += num;
            else
              equation.add(num);
            expr.text = equation.join(' ');
          }),
        ));
    return button;
  }

  Widget opButton(BuildContext context, String op) {
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
          equation.add(op);
          expr.text = equation.join(' ');
        }),
      ),
    );
    return button;
  }

  Widget trigButton(BuildContext context, String fn) {
    fn = hyp? fn+'h':fn;
    fn = inv? fn+"\u207B\u00b9":fn;
    final button = Container(
        height: 35,
        margin: EdgeInsets.all(2.5),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.white)),
          child: Text(fn,
            textScaleFactor: 1.5,
            style: TextStyle(
                color: Colors.black45), // Theme.of(context).primaryColorDark,),
          ),
          onPressed: () => setState(() => addTrig(fn)),
        ));
    return button;
  }

  addTrig(fn) {
    if (equation.length != 1 || (equation.length == 1 && equation.first != '0')) {
      if (isNumeric(equation.last)) equation.add('\u{00d7}');
    } else {
      equation.removeLast();
    }
    equation.add(fn);
    equation.add('(');
    expr.text = equation.join(' ');
  }

  Widget logButton(BuildContext context, String fn, base) {
    fn = inv? 'anti'+fn+toSubscript(base): fn+toSubscript(base);
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
          onPressed: () => setState(() => addLog(fn)),
        ));
    return button;
  }

  addLog(String fn) {
    if (equation.length != 1 || (equation.length == 1 && equation.first != '0')) {
      if (isNumeric(equation.last)) equation.add('\u{00d7}');
    } else {
      equation.removeLast();
    }
    equation.add(fn);
    equation.add('(');
    expr.text = equation.join(' ');
    return 0;
  }

  addPowers(op){
    if (op=='^'){
      setState(() {
        equation.add(op);
      });
    }else{
      String num='2';
      if (equation.length == 1 && equation[0] == '0')
        equation[0] = num;
      else if (!isNumeric(equation.last))
        equation.add(num);
      equation.last = toSuperscript(equation.last) + '\u{221a}';
      equation.add('(');
    }
    expr.text = equation.join(' ');
  }
}

// Symbols
// + : \u{002b}
// - : \u{2212}
// * : \u{00d7}
// / : \u{00f7}
// bksp: \u{232b}
// theta: \u{03b8}
// pi: \u{1d70b}
// euler's const: \u{212F}
// radical: \u{221a}
