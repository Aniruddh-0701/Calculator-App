import 'package:calculator_app/back_ends/CalculatorFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calculator_app/back_ends/UnitConversion.dart';

class UnitConverter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UnitConverter();
  }
}

class _UnitConverter extends State<UnitConverter> {
  int currConverter = 0;
  List<String> converters = ['Length', 'Mass', 'Temperature', 'Volume'];
  Map<String, Function> converterFunctions = {
    'Length': lengthConverter,
    'Mass': massConverter,
    'Temperature': temperatureConverter,
    'Volume': volumeConverter,
  };
  Map unitMapping = {
    'Length': length.keys.toList(),
    'Mass': mass.keys.toList(),
    'Temperature': temperatureUnits,
    'Volume': volume.keys.toList(),
  };

  var _fromUnit = '', _toUnit = '';
  int _convertInd = 0;
  bool _isSelected1 = true;
  bool _isSelected2 = false;
  Color noSelection = Colors.black;
  Color textSelection = Colors.deepOrange;
  List<String> eqn = ['0'];
  TextEditingController converter = TextEditingController();
  TextEditingController conversionVal = TextEditingController();
  TextEditingController convertedVal = TextEditingController();
  var expr;
  var result;

  @override
  void initState() {
    super.initState();
    _convertInd = converters.length;
    _fromUnit = unitMapping[converters[currConverter]].first;
    _toUnit = unitMapping[converters[currConverter]][1];
    expr = conversionVal;
    result = convertedVal;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    converter.text = converters[currConverter];
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            height: 1 / 8 * MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 0.222 * MediaQuery.of(context).size.width,
                    foregroundDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_left,
                        // color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => setState(() {
                        currConverter = (currConverter - 1) % _convertInd;
                        _fromUnit = unitMapping[converters[currConverter]].first;
                        _toUnit = unitMapping[converters[currConverter]][1];
                      }),
                    )),
                Container(
                  height: 1 / 12 * MediaQuery.of(context).size.height,
                  width: 1 / 2 * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                  child: TextField(
                      controller: converter,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ))),
                ),

                Container(
                    width: 0.22 * MediaQuery.of(context).size.width,
                    foregroundDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(),
                    ),
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_right,
                        ),
                        onPressed: () => setState(() {
                          currConverter = (currConverter + 1) % _convertInd;
                          _fromUnit =
                              unitMapping[converters[currConverter]].first;
                          _toUnit = unitMapping[converters[currConverter]][1];
                        })))
              ],
            ),
          ),

          Container(
            alignment: Alignment.center,
            height: 1 / 8 * MediaQuery.of(context).size.height,
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 0.22 * MediaQuery.of(context).size.height,
                    child: TextField(
                        onTap: ()=>setState((){
                          _isSelected2 = false;
                          _isSelected1 = true;
                          expr = conversionVal;
                          result = convertedVal;
                          eqn = expr.text.split(' ');
                        }),
                        style: TextStyle(
                            color: _isSelected1? textSelection:noSelection),
                        controller: conversionVal,
                        // keyboardType: TextInputType.number,
                        textDirection: TextDirection.ltr,
                        readOnly: true,
                        textAlign: TextAlign.right,
                        cursorColor: Theme.of(context).primaryColor,
                        onSubmitted: (String val) => setState(() {
                          convertedVal
                              .text = converterFunctions[converter.text]!(
                              toDouble(val), this._fromUnit, this._toUnit)
                              .toString();
                        }),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ))),
                Container(
                    height: 0.05 * MediaQuery.of(context).size.height,
                    margin: EdgeInsets.all(2.5),
                    child: DropdownButton<String>(
                      items: unitMapping[converters[currConverter]]
                          .map<DropdownMenuItem<String>>(
                              (String a) => DropdownMenuItem<String>(
                                  child: Text(
                              a,
                              style: TextStyle(color: Colors.black45),
                            ),
                            value: a,
                          ))
                          .toList(),
                      onChanged: (var a) =>
                          setState(() => this._fromUnit = a.toString()),
                      value: this._fromUnit,
                    )),
              ],
            ),
          ),
          Container(
              height: 1 / 8 * MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  Container(
                    height: 0.22 * MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      onTap: ()=>setState((){
                        _isSelected2=true;
                        _isSelected1=false;
                        expr = convertedVal;
                        result = conversionVal;
                        eqn = expr.text.split(' ');
                      }),
                      style: TextStyle(
                        color: _isSelected2? textSelection:noSelection
                      ),
                      controller: convertedVal,
                      // keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      readOnly: true,
                      textAlign: TextAlign.right,
                      onChanged: (String val) => setState(() {
                            conversionVal
                                .text = converterFunctions[converter.text]!(
                                    toDouble(val), this._toUnit, this._fromUnit)
                                .toString();
                          }),
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ))),
                  Container(
                        height: 0.05 * MediaQuery.of(context).size.height,
                        margin: EdgeInsets.all(2.5),
                        child: DropdownButton<String>(
                          items: unitMapping[converters[currConverter]]
                              .map<DropdownMenuItem<String>>(
                                  (String a) => DropdownMenuItem<String>(
                                    child: Text(a,
                                        style: TextStyle(color: Colors.black45),
                                    ),
                                    value: a,
                            ))
                            .toList(),
                        onChanged: (var a) => setState(() {
                          this._toUnit = a.toString();
                        }),
                        value: this._toUnit,
                      )),
                ],
              ),
          ),

          Row(
            children: [
              Expanded(child: numButton(context, '7')),
              Expanded(child: numButton(context, '8')),
              Expanded(child: numButton(context, '9')),
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
                          style: TextStyle(color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.bold),
                          textScaleFactor: 1.5,
                        ),
                      ))),
            ],
          ),

          Row(
            children: [
              Expanded(child: numButton(context, '4')),
              Expanded(child: numButton(context, '5')),
              Expanded(child: numButton(context, '6')),

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
                          style: TextStyle(color: Colors.black,),
                          textScaleFactor: 1.5,
                        ),
                      ))),
            ],
          ),

          Row(
            children: [
              Expanded(child: numButton(context, '1')),
              Expanded(child: numButton(context, '2')),
              Expanded(child: numButton(context, '3')),
              // pi
              Expanded(child: numButton(context, '\u{1d70b}')),
            ],
          ),

          Row(
            children: [
              Expanded(child: numButton(context, '0')),
              Expanded(child: numButton(context, '.')),
              Expanded(child: numButton(context, 'E')),

              // submit
              Expanded(
                  child: Container(
                      height: 35,
                      margin: EdgeInsets.all(2.5),
                      child: TextButton(
                        child: Icon(Icons.check, color: Colors.white,),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith(
                                (states) => Theme.of(context)
                                  .primaryColor)),
                        onPressed: () => setState(() {
                          if(_isSelected1)
                            result.text = converterFunctions[converter.text]!(
                                toDouble(expr.text), this._fromUnit,
                                this._toUnit).toString();
                          else
                            result.text = converterFunctions[converter.text]!(
                                toDouble(expr.text), this._toUnit,
                                this._fromUnit).toString();
                        }),
                      ))),
            ],
          )

        ],
      ),
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
            if (num != '.' && expr.text.length == 1 && expr.text == '0')
              expr.text = num;
            else //if (isNumeric(eqn.last))
              expr.text += num;
          }),
        ));
    return button;
  }
}
