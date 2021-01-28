// import 'dart:io'; // For testing
import 'dart:math'; // For built-in mathematical functions
// Other mathematical and logical functions
import 'package:calculator_app/back_ends/CalculatorFunctions.dart';

Map superscript = {
  '0': '\u2070',
  '1': '\u00B9',
  '2': '\u00B2',
  '3': '\u00B3',
  '4': '\u2074',
  '5': '\u2075',
  '6': '\u2076',
  '7': '\u2077',
  '8': '\u2078',
  '9': '\u2079',
  'e': '\u1d49',
};

class Calculate {
  List eqn = [];
  List result = [];
  List operators = [];
  var isRad = 1;

  Map trig = {
    'sin': sin,
    'cos': cos,
    'tan': tan,
  };

  Map invTrig = {
    'sin\u207B\u00b9': asin,
    'cos\u207B\u00b9': acos,
    'tan\u207B\u00b9': atan,
  };

  Map hyp = {
    'sinh\u207B\u00b9': arcsinh,
    'cosh\u207B\u00b9': arccosh,
    'tanh\u207B\u00b9': arctanh,
    'sinh': sinh,
    'cosh': cosh,
    'tanh': tanh,
  };

  var mathRegEx = 'sin\u207B\u00b9sinh\u207B\u00b9'
      'cos\u207B\u00b9cosh\u207B\u00b9'
      'tan\u207B\u00b9tanh\u207B\u00b9';

  // List l = ['^', '/', '*', '%', '+', '-'];
  List l = ['^', '\u{00f7}', '\u{00d7}', '%', '\u{002b}', '\u{2212}'];
  // RegExp digits = new RegExp(r"(\d+)");

  Calculate(List eqn, {int rad = 1}) {
    this.eqn = ['(', ...eqn, ')'];
    this.isRad = rad;
    // print(this.eqn);
  }

  calculate() {
    int start = 0, end = 0;
    if (eqn.where((e) => e == ')').length != eqn.where((e) => e == '(').length)
      return 'Syntax Error';
    while (this.eqn.contains(')')) {
      end = this.eqn.indexOf(')');
      for (int j = end; j > -1; j--) {
        if (this.eqn[j] == '(') {
          start = j;
          break;
        }
      }
      // print(this.eqn.sublist(start, end + 1));
      this.genExpression(start + 1, end);
      this.eqn = [
        ...eqn.sublist(0, start),
        this.genResult().toString(),
        ...eqn.sublist(end + 1, eqn.length)
      ];
      // print(this.eqn);
    }
    var value = toDouble(this.eqn.first);
    if (value.toInt().toDouble() == value)
      return value.toInt();
    else
      return roundOff(value, 7);
  }

  genExpression(int start, int end) {
    // print('gen_exp');
    this.result = [];

    //iterate through the expression in the innermost parenthesis
    for (String i in eqn.sublist(start, end)) {
      if (i is double) this.result.add(i);
      // if not a double
      // check if it is a number
      var d = toDouble(i);
      if (d != double.infinity)
        result.add(d);
      else if (i.contains('\u{221a}'))
        this.result.add(i);
      else if (this.mathRegEx.contains(i)) // trigonometric function
        this.result.add(i);
      else if (i.contains('log'))
        this.result.add(i);
      else {
        while (this.operators.length > 0 &&
            this.l.indexOf(i) > this.l.indexOf(this.operators.last))
          this.result.add(this.operators.removeLast());
        this.operators.add(i);
      }
      // print('${this.result}, ${this.operators}');
    }
    this.result.addAll(this.operators.reversed);
    this.operators = [];
    // return (this.result);
    // print(this.result);
  }

  genResult() {
    // print('genResult');
    // print(this.result);
    var j = 0;
    while (this.result.length > 1) {
      var k = this.result[j];
      // print(k);
      if (k is double) {
        j += 1;
      } else if (this.trig.containsKey(k)) {
        if (this.isRad == 0) this.result[j + 1] *= pi / 180;
        this.result[j] = this.trig[k](this.result[j + 1]);
        this.result.removeAt(j + 1);
      } else if (this.invTrig.containsKey(k)) {
        this.result[j] = this.invTrig[k](this.result[j + 1]);
        this.result.removeAt(j + 1);
        if (this.isRad == 0) this.result[j] *= 180 / pi;
      } else if (k.contains('anti')) {
        this.result[j] = antilogarithm(this.result.removeAt(j + 1),
            toDouble(subscriptToText(k.substring(7))));
      } else if (k.contains('log')) {
        this.result[j] = logarithm(this.result.removeAt(j + 1),
            base: toDouble(subscriptToText(k.substring(3))));
      } else if (this.hyp.containsKey(k)) {
        this.result[j] = this.hyp[k](this.result[j + 1]);
        this.result.removeAt(j + 1);
      }else if(k.contains('\u{221a}')){
        String exponent = k.substring(0, k.length -1);
        this.result[j] = pow(this.result[j+1],
            1/toDouble(superscriptToText(exponent)));
        this.result.removeAt(j + 1);
      } else if (this.l.contains(k)) {
        if (k == '\u{002b}')
          this.result[j - 2] += this.result[j - 1];
        else if (k == '\u{2212}')
          this.result[j - 2] -= this.result[j - 1];
        else if (k == '\u{00d7}')
          this.result[j - 2] *= this.result[j - 1];
        else if (k == '\u{00f7}')
          this.result[j - 2] /= this.result[j - 1];
        else if (this.result[j] == '^') {
          this.result[j - 2] = pow(this.result[j - 2], this.result[j - 1]);
        }
        this.result.removeAt(j - 1);
        this.result.removeAt(j - 1);
        j -= 1;
      }
      if (j >= this.result.length) j = 0;
      // print('${this.result[j]}');
    }
    return (this.result.first);
  }
}

// int boolToInt(bool v) => v? 1:0 ;

// Main fn to test the code.
void main() {
  List eqn = [];
  print('Enter a equation\n');
  // eqn = stdin.readLineSync()!.split(' ').toList();
  eqn = "11 \u{00f7} 2 \u{00d7} 2 \u{00f7} 11".split(' ').toList();
  print(eqn);
  var cal = Calculate(eqn);
  print(cal.calculate());
  // print(eqn);
  // var x = '10.';
  // print(isNumeric(x));
}
