import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:calculator_app/back_ends/Calculation.dart';
import 'package:calculator_app/back_ends/CalculatorFunctions.dart';
import 'package:flutter/widgets.dart';

List eqn = ['0'];
var cal = Calculate();

class Calci extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Calci();
  }
}

class _Calci extends State<Calci> {
  TextEditingController expr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
            children: <Widget>[
              // Expression box
              // Expanded(child: )
              Container(
                padding: EdgeInsets.only(top:30.0,),
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
                      fillColor: Theme.of(context).accentColor,
                      focusedBorder: InputBorder.none,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).accentColor, width: 0.0)
                      ),
                    )
                ),
              ),

              // Num Pad

              // C, AC
              Row(
                children: <Widget>[
                  // AC
                  Expanded(
                      child: Container(
                          height: 0.1 * MediaQuery.of(context).size.height,
                          margin: EdgeInsets.all(2.5),
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.resolveWith(
                                        (states) => Theme.of(context).accentColor)),
                            onPressed: () => setState(() {
                              eqn = ['0'];
                              expr.text = eqn.join(' ');
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
                                backgroundColor:
                                MaterialStateProperty.resolveWith(
                                        (states) => Theme.of(context).accentColor)),
                            onPressed: () => setState(() {
                              eqn = ['0'];
                              expr.text = eqn.join(' ');
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
                                backgroundColor:
                                MaterialStateProperty.resolveWith(
                                        (states) => Theme.of(context).accentColor)),
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
                              style: TextStyle(
                                  color: Colors.black,
                                fontSize: 0.02 * MediaQuery.of(context).size.height,
                              ),
                              textScaleFactor: 1.5,
                            ),
                          ))),

                  // div
                  opButton(context, '\u{00F7}',
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
                    child: numButton(context, 'E', isDisabled: 0),
                  ),
                  // =
                  Container(
                          height: 0.1 * MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .primaryColor,
                          ),
                          margin: EdgeInsets.all(2.5),
                          child: TextButton(
                            // style: ButtonStyle(
                            //     backgroundColor:
                            //     MaterialStateProperty.resolveWith(
                            //             (states) => Theme.of(context)
                            //             .primaryColor)),
                            onPressed: () => setState(() {
                              expr.text = cal.calculate(eqn).toString();
                              eqn = ['0'];
                            }),
                            child: Text(
                              '=',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                fontSize: 0.03 * MediaQuery.of(context).size.height,
                              ),
                              textScaleFactor: 1.5,
                            ),
                          )),
                ],
              ),

            ]
        )
    );
  }

  Widget numButton(context, String num, {int isDisabled = 0}) {
    final button = Container(
        height: 0.1 * MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(2.5),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.resolveWith((states) => Theme.of(context).accentColor)),
          child: Text(num,
            textScaleFactor: 1.5,
            style: TextStyle(
                color: Colors.black45,
              fontSize: 0.02 * MediaQuery.of(context).size.height,
            ), // Theme.of(context).primaryColorDark,),
          ),
          onPressed: isDisabled==1 ? null: () => setState(() {
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
          eqn.add(op);
          expr.text = eqn.join(' ');
        }),
      ),
    );
    return button;
  }
}
