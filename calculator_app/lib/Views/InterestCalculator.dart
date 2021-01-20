import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:calculator_app/back_ends/Calculation.dart';
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
  var _op = ['', ''];

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(_minMargin),
          child: ListView(
            children: <Widget>[
              siImage(),
              Padding(
                padding: EdgeInsets.all(_minMargin),
                child: TextFormField(
                  controller: _principal,
                  keyboardType: TextInputType.number,
                  validator: ((val) => val.isEmpty || !isNumeric(val)
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
                    validator: ((val) => val.isEmpty || !isNumeric(val)
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
                        validator: ((val) => val.isEmpty || !isNumeric(val)
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
                          child: DropdownButton<String>(
                        // style: textStyle,
                        items: _currency.map((String curr) {
                          return DropdownMenuItem<String>(
                            value: curr,
                            child: Text(curr),
                          );
                        }).toList(),
                        value: _defCurr,
                        onChanged: (String oCurr) => onSelect(oCurr),
                      )),
                      Container(
                        width: _minMargin,
                      ),
                      (DropdownButton<String>(
                        // style: textStyle,
                        items: _toi.map((String inT) {
                          return DropdownMenuItem<String>(
                            value: inT,
                            child: Text(inT),
                          );
                        }).toList(),
                        value: _defInt,
                        onChanged: (String oInt) => onSelectInt(oInt),
                      )),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(top: _minMargin, bottom: _minMargin),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColorDark,
                      child: Text(
                        "Calculate",
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () => setState(() {
                        if (_formKey.currentState.validate()) {
                          var interest = calculateInterest();
                          this._op = [
                            'Interest = '
                                '${_defCurr[_defCurr.length - 1]} ${interest[0]}',
                            'Amount = ${_defCurr[_defCurr.length - 1]} ${interest[1]}'
                          ];
                        }
                      }),
                    )),
                    Container(
                      width: _minMargin * 3,
                    ),
                    Expanded(
                        child: RaisedButton(
                          textColor: Theme.of(context).primaryColor,
                          color: Theme.of(context).primaryColorDark,
                          child: Text(
                            "Reset",
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () => setState(() => _reset()),
                    )),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(_minMargin * 2),
                  child: Center(
                    child: Text(
                      _op.join('\n'),
                      style: textStyle,
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget siImage() {
    AssetImage assetImage = AssetImage('images/SI_image.png');
    Image image = Image(
      image: assetImage,
      width: 440.5,
      height: 228.0,
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

  List calculateInterest() {
    double P = double.parse(_principal.text);
    double R = double.parse(_rate.text);
    double T = double.parse(_time.text);
    if (this._defInt == 'SI') {
      double sI = P * R * T / 100;
      double total = sI + P;
      return [sI, total];
    } else {
      double cI = P * pow(R / 100, T);
      double total = cI + P;
      return [cI, total];
    }
  }

  _reset() {
    _principal.text = '';
    _rate.text = '';
    _time.text = '';
    _op = [''];
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
