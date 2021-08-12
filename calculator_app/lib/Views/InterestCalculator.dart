import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:calculator_app/back_ends/CalculatorFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SiForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SiForm();
  }
}

class _SiForm extends State<SiForm> {
  var _currency = [
    'INR \u{20b9}',
    'USD \u{0024}',
    'GBP \u{00a3}',
    'EUR \u{20ac}',
    'YEN \u{00a5}'
  ];

  var _toi = ['CI', 'SI'];
  var _defInt = 'CI';
  var _defCurr = '';

  var _formKey = GlobalKey<FormState>();
  final _minMargin = 10.0;

  @override
  void initState() {
    super.initState();
    _defCurr = _currency[0];
    // _defInt = _toi[0];
  }

  TextEditingController _principal = TextEditingController();
  TextEditingController _rate = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController _parts = TextEditingController();
  TextEditingController _amt = TextEditingController();
  TextEditingController _int = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    TextStyle textStyle = Theme.of(context).textTheme.headline6!;

    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minMargin),
          child: ListView(
            children: <Widget>[
              siImage(),

              Padding(
                padding: EdgeInsets.all(_minMargin),
                child: Row(
                  children: [
                    Container(
                        width: 0.3 * MediaQuery.of(context).size.width,
                        child: DropdownButton<String>(
                          // style: textStyle,
                          items: _currency.map((String curr) {
                            return DropdownMenuItem<String>(
                              value: curr,
                              child: Text(curr),
                            );
                          }).toList(),
                          value: _defCurr,
                          onChanged: (var oCurr) {
                            onSelect(oCurr.toString());
                          },
                        )),
                    Container(
                      width: _minMargin,
                    ),
                    Container(
                        width: 0.3 * MediaQuery.of(context).size.width,
                        child: DropdownButton<String>(
                      // style: textStyle,
                      items: _toi.map((String inT) {
                        return DropdownMenuItem<String>(
                          value: inT,
                          child: Text(inT),
                        );
                      }).toList(),
                      value: _defInt,
                      onChanged: (var oInt) => onSelectInt(oInt.toString()),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(_minMargin),
                child: TextFormField(
                  controller: _principal,
                  keyboardType: TextInputType.number,
                  validator: ((val) => val!.isEmpty || !isNumeric(val)
                      ? 'Please Enter a valid Principal'
                      : null),
                  decoration: InputDecoration(
                    labelText: "Principal",
                    labelStyle: textStyle,
                    errorStyle: TextStyle(fontSize: 15.0),
                    hintText: "Enter Principal Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(_minMargin),
                  child: TextFormField(
                    // style: textStyle,
                    keyboardType: TextInputType.number,
                    controller: _rate,
                    validator: ((val) => val!.isEmpty || !isNumeric(val)
                        ? 'Please Enter a valid ROI'
                        : null),
                    decoration: InputDecoration(
                      labelText: "Rate of Interest",
                      labelStyle: textStyle,
                      errorStyle: TextStyle(fontSize: 15.0),
                      hintText: "Enter Rate of Interest (p.a.)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.all(_minMargin),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextFormField(
                        // style: textStyle,
                        keyboardType: TextInputType.number,
                        controller: _time,
                        validator: ((val) => val!.isEmpty || !isNumeric(val)
                            ? 'Invalid time'
                            : null),
                        decoration: InputDecoration(
                          labelText: "Time",
                          hintText: "Time (years)",
                          labelStyle: textStyle,
                          errorStyle: TextStyle(fontSize: 15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      )),
                      Container(
                        width: _minMargin,
                      ),
                      Expanded(
                          child: TextFormField(
                            // style: textStyle,
                            keyboardType: TextInputType.number,
                            controller: _parts,
                            decoration: InputDecoration(
                              labelText: "Parts/yr",
                              hintText: "Parts",
                              labelStyle: textStyle,
                              errorStyle: TextStyle(fontSize: 15.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          )),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: _minMargin, bottom: _minMargin),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColor)),
                            child: Text(
                        "Calculate",
                        textScaleFactor: 1.5,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark),
                      ),
                      onPressed: () => setState(() {
                        if (_formKey.currentState!.validate()) {
                          print('Calculating');
                          var op = calculateInterest();
                          print(op);
                          _int.text = op.first.toString();
                          _amt.text = op.last.toString();
                        }
                      }),
                    )),
                    Container(
                      width: _minMargin * 3,
                    ),
                    Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColorDark)),
                          child: Text(
                            "Reset",
                            textScaleFactor: 1.5,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () => setState(() => _reset()),
                    )),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(_minMargin),
                  child: Row(
                    children: [
                      Container(
                          width: 0.4 * MediaQuery.of(context).size.width,
                          child: TextFormField(
                            readOnly: true,
                            controller: _int,
                            decoration: InputDecoration(
                              labelText: "Interest",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          )
                      ),

                      Expanded(child: Container(
                        width: 0.25 * MediaQuery.of(context).size.width,
                      )),

                      Container(
                          width: 0.4 * MediaQuery.of(context).size.width,
                          child: TextFormField(
                            readOnly: true,
                            controller: _amt,
                            decoration: InputDecoration(
                              labelText: "Amount",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          )
                      )
                    ],
                  ),
              ),
            ],
          ),
        ));
  }

  Widget siImage() {
    AssetImage assetImage = AssetImage('images/SI_image.jpg');
    Image image = Image(
      image: assetImage,
      width: 160,
      height: 120.0,
    );
    return Container(
          margin: EdgeInsets.all(_minMargin),
          child: Center(
            child: image,
        ));
  }

  void onSelect(String newSel) {
    setState(() {
      this._defCurr = newSel;
    });
  }

  void onSelectInt(String newSel) {
    setState(() {
      this._defInt = newSel;
    });
  }

  List<num> calculateInterest() {
    double P = double.parse(_principal.text);
    double R = double.parse(_rate.text);
    double T = double.parse(_time.text);
    double n = double.parse( _parts.text!=''? _parts.text:'1');
    if (this._defInt == 'SI') {
      double sI = P * R * n* T / 100;
      double total = sI + P;
      return [roundOff(sI, 7)!, roundOff(total, 7)!];
    } else {
      double total = P * pow(1 + (R / 100), n * T);
      double cI = total - P;
      return [roundOff(cI, 7)!, roundOff(total, 7)!];
    }
  }

  _reset() {
    _principal.text = '';
    _rate.text = '';
    _time.text = '';
    _parts.text = '';
    _amt.text = '';
    _int.text = '';
    _defCurr = _currency[0];
    _defInt = _toi[0];
  }
}

/*
* Rs \u20B9
* $ - \u0024
* Euro \u20AC
* pounds - \u00a3
* yen - \u00a5
* */
