import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:calculator_app/back_ends/Calculation.dart';
import 'package:calculator_app/back_ends/CalculatorFunctions.dart';
import 'package:flutter/widgets.dart';

List equation = ['0'];
var cal = Calculate();

class Calci extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Calci();
  }
}

class _Calci extends State<Calci> {
  final ThemeData theme = ThemeData();
  TextEditingController expr = TextEditingController();
  bool inv = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          // Expression box
          // Expanded(child: )
          Container(
            padding: EdgeInsets.only(
              top: 30.0,
            ),
            height: 0.2 * MediaQuery.of(context).size.height,
            child: TextField(
                controller: expr,
                readOnly: true,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.right,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center,
                maxLines: 5,
                style: TextStyle(
                  fontSize: 0.025 * MediaQuery.of(context).size.height,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter an expression',
                  fillColor: Theme.of(context).colorScheme.secondary,
                  focusedBorder: InputBorder.none,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 0.0)),
                )),
          ),

          // Num Pad

          // C, AC
          Row(
            children: <Widget>[
              // Shift (toggle inverse)
              Expanded(
                child: Container(
                    height: 0.1 * MediaQuery.of(context).size.height,
                    margin: EdgeInsets.all(2.5),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) =>
                                  inv ? Colors.deepOrange : Colors.white60)),
                      onPressed: () => setState(() {
                        if (inv)
                          inv = false;
                        else
                          inv = true;
                      }),
                      child: Text(
                        'Shift',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 0.02 * MediaQuery.of(context).size.height,
                        ),
                        textScaleFactor: 1.5,
                      ),
                    )),
              ),
              // AC
              Expanded(
                  child: Container(
                      height: 0.1 * MediaQuery.of(context).size.height,
                      margin: EdgeInsets.all(2.5),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    Theme.of(context).colorScheme.secondary)),
                        onPressed: () => setState(() {
                          equation = ['0'];
                          expr.text = equation.join(' ');
                        }),
                        child: Text(
                          'AC',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 0.02 * MediaQuery.of(context).size.height,
                          ),
                          textScaleFactor: 1.5,
                        ),
                      ))),

              // CE
              Expanded(
                  child: Container(
                      height: 0.1 * MediaQuery.of(context).size.height,
                      margin: EdgeInsets.all(2.5),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    Theme.of(context).colorScheme.secondary)),
                        onPressed: () => setState(() {
                          equation = ['0'];
                          expr.text = equation.join(' ');
                        }),
                        child: Text(
                          'C',
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 0.02 * MediaQuery.of(context).size.height,
                          ),
                          textScaleFactor: 1.5,
                        ),
                      ))),

              // BKSP
              Expanded(
                  child: Container(
                      height: 0.1 * MediaQuery.of(context).size.height,
                      margin: EdgeInsets.all(2.5),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    Theme.of(context).colorScheme.secondary)),
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
                            fontSize: 0.02 * MediaQuery.of(context).size.height,
                          ),
                          textScaleFactor: 1.5,
                        ),
                      ))),
            ],
          ),

          Row(
            children: [
              // x^y
              Expanded(
                child: Container(
                    height: 0.1 * MediaQuery.of(context).size.height,
                    margin: EdgeInsets.all(2.5),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.white)),
                      onPressed: () {
                        this.inv ? addPowers('\u{221a}') : addPowers('^');
                        setState(() => this.inv = false);
                      },
                      child: Text(
                        this.inv ? '\u{221a}' : '^',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 0.02 * MediaQuery.of(context).size.height,
                        ),
                        textScaleFactor: 1.5,
                      ),
                    )),
              ),

              // factorial
              Expanded(
                child: Container(
                    height: 0.1 * MediaQuery.of(context).size.height,
                    margin: EdgeInsets.all(2.5),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.white)),
                      onPressed: () {
                        if (equation.last == ')')
                          equation.add('!');
                        else if ((cal.arithmeticPrecedence
                                .containsKey(equation.last)) ||
                            (equation.last
                                    .toString()[equation.last.length - 1] ==
                                '('))
                          showWarning('Factorial',
                              "Factorial can be applied to numbers only");
                        else
                          equation.last += '!';
                        expr.text = equation.join(' ');
                      },
                      child: Text(
                        '!',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 0.02 * MediaQuery.of(context).size.height,
                        ),
                        textScaleFactor: 1.5,
                      ),
                    )),
              ),

              // pi
              Expanded(child: numButton(context, '\u{1d70b}')),

              // div
              opButton(
                context,
                '\u{00F7}',
              ),
            ],
          ),

          // 7-9
          Row(
            children: [
              Expanded(child: numButton(context, '7')),
              Expanded(child: numButton(context, '8')),
              Expanded(child: numButton(context, '9')),
              opButton(context, '\u{00d7}'),
            ],
          ),

          // 4-6
          Row(
            children: [
              Expanded(child: numButton(context, '4')),
              Expanded(child: numButton(context, '5')),
              Expanded(child: numButton(context, '6')),
              opButton(context, '\u{2212}'),
            ],
          ),

          // 1-3
          Row(
            children: [
              Expanded(child: numButton(context, '1')),
              Expanded(child: numButton(context, '2')),
              Expanded(child: numButton(context, '3')),
              opButton(context, '\u{002b}'),
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
                child: inv ? opButton(context, 'Ans') : numButton(context, 'E'),
              ),
              // =
              Container(
                  height: 0.1 * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  margin: EdgeInsets.all(2.5),
                  child: TextButton(
                    onPressed: () => setState(() {
                      try {
                        expr.text = cal.calculate(equation);
                        equation = ['0'];
                      } catch (e, stackTrace) {
                        showWarning(
                            "Error", e.toString().replaceFirst("\n", ""));
                        print("$e\n $stackTrace");
                      }
                    }),
                    child: Text(
                      '=',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 0.03 * MediaQuery.of(context).size.height,
                      ),
                      textScaleFactor: 1.5,
                    ),
                  )),
            ],
          ),
        ]));
  }

  Widget numButton(context, String num, {int isDisabled = 0}) {
    final button = Container(
        height: 0.1 * MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(2.5),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Theme.of(context).colorScheme.secondary)),
          child: Text(
            num,
            textScaleFactor: 1.5,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 0.02 * MediaQuery.of(context).size.height,
            ), // Theme.of(context).primaryColorDark,),
          ),
          onPressed: isDisabled == 1
              ? null
              : () => setState(() {
                    if (num != '.' &&
                        equation.length == 1 &&
                        equation[0] == '0')
                      equation[0] = num;
                    else if (isNumeric(equation.last) ||
                        (equation.last == '\u{2212}' &&
                            ((equation.length > 1 &&
                                    !isNumeric(equation[equation.length - 2]) ||
                                (equation.length == 1)))))
                      equation.last += num;
                    else
                      equation.add(num);
                    expr.text = equation.join(' ');
                  }),
        ));
    return button;
  }

  Widget opButton(context, String op) {
    final button = Container(
      height: 0.1 * MediaQuery.of(context).size.height,
      margin: EdgeInsets.all(2.5),
      child: TextButton(
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
            fontSize: 0.02 * MediaQuery.of(context).size.height,
          ),
        ),
        onPressed: () => setState(() {
          if (op == '\u{2212}' && equation.last == '0') equation.removeLast();
          if (op == 'Ans' && equation.last == '0')
            equation.removeLast();
          else if (op == 'Ans' && isNumeric(equation.last))
            equation.add('\u00d7');
          if (op != "Ans" &&
              op != '\u{2212}' &&
              cal.arithmeticPrecedence.keys.contains(equation.last))
            equation.removeLast();
          if ((op == "\u{2212}" || op == "\u{002b}") &&
              (equation.length > 0 && equation.last.endsWith("E")))
            equation.last += op;
          else
            equation.add(op);
          expr.text = equation.join(' ');
        }),
      ),
    );
    return button;
  }

  addPowers(op) {
    if (op == '^') {
      setState(() {
        equation.add(op);
      });
    } else {
      String num = '2';
      if (equation.length == 1 && equation[0] == '0')
        equation[0] = num;
      else if (!isNumeric(equation.last)) equation.add(num);
      equation.last = toSuperscript(equation.last) + '\u{221a}';
    }
    expr.text = equation.join(' ');
  }

  Future<void> showWarning(String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
