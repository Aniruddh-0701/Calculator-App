import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:calculator_app/back_ends/Calculation.dart';
import 'package:calculator_app/back_ends/CalculatorFunctions.dart';
import 'package:flutter/widgets.dart';

List equation = ['0'];

var cal = Calculate();

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
                style: TextStyle(fontSize: 0.04 * MediaQuery.of(context).size.height),
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
                                  height: 0.1 * MediaQuery.of(context).size.height,
                                  margin: EdgeInsets.only(top: 5.0, right: 2.5),
                                  child: Text(
                                    'Hyp',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 0.035 * MediaQuery.of(context).size.height,
                                    ),
                                    textScaleFactor: 1.5,
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                            Expanded(
                                child: Container(
                                  height: 0.1 * MediaQuery.of(context).size.height,
                                  margin:
                                  EdgeInsets.only(top: 2.5, left: 2.5, bottom: 5.0),
                                  child: Switch(
                                    value: hyp,
                                    onChanged: (bool v) => setState(() => hyp = v),
                                  ),
                                )),

                            // deg-rad,
                            Container(
                                width: 0.0765 * MediaQuery.of(context).size.width,
                                height: 0.1 * MediaQuery.of(context).size.height,
                                margin: EdgeInsets.all(2.5),
                                child: DropdownButton(
                                  items: angle
                                      .map((String a) => DropdownMenuItem(
                                    child: Text(
                                      a,
                                      style: TextStyle(
                                          color: Colors.black45,
                                        fontSize: 0.045 * MediaQuery.of(context).size.height,
                                      ),
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
                                    fontSize: 0.035 * MediaQuery.of(context).size.height,
                                  ),
                                  textScaleFactor: 1.5,
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                                child:
                                Container(
                                    width: 0.05 * MediaQuery.of(context).size.width,
                                    height: 0.1 * MediaQuery.of(context).size.height,
                                    margin: EdgeInsets.all(2.5),
                                    child: TextFormField(
                                      controller: base,
                                      validator: ((val) => val!.isEmpty && !isNumeric(val)
                                          ? 'Invalid base'
                                          : null),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 0.035 * MediaQuery.of(context).size.height,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (String base){
                                        setState(()=> this.b = base);
                                      },
                                      decoration: InputDecoration(
                                        // labelText: 'base',
                                        hintStyle: TextStyle(
                                          fontSize: 0.04 * MediaQuery.of(context).size.height,
                                        ),
                                        hintText: '10',
                                      ),
                                    ))),
                          ],
                        ),

                        // log, inv, (
                        Row(
                          children: [

                            // Shift (toggle inverse)
                            Expanded(
                              child: Container(
                                  height: 0.1 * MediaQuery.of(context).size.height,
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
                                      'Shift',
                                      style: TextStyle(
                                          color: Colors.black45,
                                        fontSize: 0.035 * MediaQuery.of(context).size.height,
                                      ),
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
                                  height: 0.1 * MediaQuery.of(context).size.height,
                                  margin: EdgeInsets.all(2.5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                                (states) => Colors.white)),
                                    onPressed: () {
                                      if(equation.length==1){
                                        if (equation.first=='0')
                                          equation.removeLast();
                                        else
                                          equation.add('\u00d7');
                                      }
                                      equation.add('(');
                                      expr.text = equation.join(' ');
                                    },
                                    child: Text(
                                      '(',
                                      style: TextStyle(
                                          color: Colors.black45,
                                        fontSize: 0.035 * MediaQuery.of(context).size.height,
                                      ),
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
                                  height: 0.1 * MediaQuery.of(context).size.height,
                                  margin: EdgeInsets.all(2.5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                                (states) => Colors.white)),
                                    onPressed: (){
                                      this.inv? addPowers('\u{221a}')
                                          : addPowers('^');
                                      setState(()=> this.inv = false);
                                    },
                                    child: Text(
                                      this.inv? '\u{221a}':'^',
                                      style: TextStyle(
                                          color: Colors.black45,
                                        fontSize: 0.035 * MediaQuery.of(context).size.height,
                                      ),
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
                                  height: 0.1 * MediaQuery.of(context).size.height,
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
                                      style: TextStyle(
                                          color: Colors.black45,
                                        fontSize: 0.035 * MediaQuery.of(context).size.height,
                                      ),
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
                                    height: 0.1 * MediaQuery.of(context).size.height,
                                    margin: EdgeInsets.all(2.5),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                                  (states) => Colors.white)),
                                      onPressed: () => setState(() {
                                        equation = ['0'];
                                        expr.text = equation.join(' ');
                                        inv = false;
                                      }),
                                      child: Text(
                                        'AC',
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                          fontSize: 0.035 * MediaQuery.of(context).size.height,
                                        ),
                                        textScaleFactor: 1.5,
                                      ),
                                    ))),

                            // CE
                            Expanded(
                                child: Container(
                                    height: 0.1 * MediaQuery.of(context).size.height,
                                    margin: EdgeInsets.all(2.5),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                                  (states) => Colors.white)),
                                      onPressed: () => setState(() {
                                        equation = ['0'];
                                        expr.text = equation.join(' ');
                                        inv = false;
                                      }),
                                      child: Text(
                                        'C',
                                        style: TextStyle(
                                            color: Colors.deepOrange,
                                          fontSize: 0.035 * MediaQuery.of(context).size.height,
                                        ),
                                        textScaleFactor: 1.5,
                                      ),
                                    ))),

                            // BKSP
                            Expanded(
                                child: Container(
                                    height: 0.1 * MediaQuery.of(context).size.height,
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
                                        style: TextStyle(
                                            color: Colors.black,
                                          fontSize: 0.035 * MediaQuery.of(context).size.height,
                                        ),
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
                              child: inv? opButton(context, 'Ans'):
                              numButton(context, 'E'),
                            ),

                            // =
                            Expanded(
                                child: Container(
                                    height: 0.1 * MediaQuery.of(context).size.height,
                                    margin: EdgeInsets.all(2.5),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                                  (states) => Theme.of(context)
                                                  .primaryColor)),
                                      onPressed: () => setState(() {
                                        expr.text = cal.calculate(
                                            equation,
                                            rad: _defAngle == 'rad' ? 1 : 0
                                        ).toString();
                                        equation = ['0'];
                                      }),
                                      child: Text(
                                        '=',
                                        style: TextStyle(
                                            color: Colors.white,
                                          fontSize: 0.035 * MediaQuery.of(context).size.height,
                                        ),
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
        height: 0.1 * MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(2.5),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.white)),
          child: Text(
            num,
            textScaleFactor: 1.5,
            style: TextStyle(
                color: Colors.black45,
              fontSize: 0.035 * MediaQuery.of(context).size.height,
            ), // Theme.of(context).primaryColorDark,),
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
      height: 0.1 * MediaQuery.of(context).size.height,
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
            fontSize: 0.035 * MediaQuery.of(context).size.height,
          ),
        ),
        onPressed: () => setState(() {
          if (op=='Ans' && equation.last== '0')  equation.removeLast();
          else if(op=='Ans' && isNumeric(equation.last))
            equation.add('\u00d7');
          equation.add(op);
          expr.text = equation.join(' ');
          this.inv = false;
        }),
      ),
    );
    return button;
  }

  Widget trigButton(BuildContext context, String fn) {
    fn = hyp? fn+'h':fn;
    fn = inv? fn+"\u207B\u00b9":fn;
    final button = Container(
        height: 0.1 * MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(2.5),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.white)),
          child: Text(fn,
            textScaleFactor: 1.5,
            style: TextStyle(
                color: Colors.black45,
              fontSize: 0.035 * MediaQuery.of(context).size.height,
            ), // Theme.of(context).primaryColorDark,),
          ),
          onPressed: () => setState(() => addTrig(fn)),
          onLongPress: ()=> _showHelp(context, fn),
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
    this.inv = false;
  }

  Widget logButton(BuildContext context, String fn, base) {
    fn = inv? 'anti'+fn+toSubscript(base): fn+toSubscript(base);
    final button = Container(
        height: 0.1 * MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(2.5),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.white)),
          child: Text(
            fn,
            textScaleFactor: 1.5,
            style: TextStyle(
                color: Colors.black45,
              fontSize: 0.035 * MediaQuery.of(context).size.height,
            ), // Theme.of(context).primaryColorDark,),
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
    this.inv = false;
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


Future<void> _showHelp(BuildContext context, String label) async {
    var alertDialog = AlertDialog(
      title: Text("Long Pressed $label"),
      content: Text("Help for $label"),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => alertDialog
    );
  }
