import 'dart:math';
import 'package:calculator_app/back_ends/Extras.dart';

double sinh(num x) => (exp(x) - exp(-x)) / 2;

double cosh(num x) => (exp(x) + exp(-x)) / 2;

double tanh(num x) => (exp(2 * x) - 1) / (exp(2 * x) + 1);

double arcsinh(num x) => log(x + sqrt(x * x + 1));

double arccosh(num x) => log(x + sqrt(x * x - 1));

double arctanh(num x) => log((1 + x) / (1 - x)) / 2;

double logarithm(num x, {num base = 10}) => log(x) / log(base);

num antilogarithm(num x, num base) => pow(base, x);

num power(num x, num y) => antilogarithm(y * logarithm(x), 10);

String roundOff(double value, int places) {
  num finalVal;
  // for num < 10^15
  if (value < double.parse("1e15")) {
    // if integer
    if (value.toInt().toDouble() == value) {
      finalVal = value.toInt();
      return finalVal.toString();
    }
    // if float
    else {
      num mod = pow(10.0, places);
      finalVal =
          double.parse((value * mod).round().toStringAsExponential(7)) / mod;
      if (finalVal.toInt().toDouble() == finalVal)
        return finalVal.toInt().toString();
      return finalVal.toString();
    }
  }
  // other general cases
  else
    return value.toStringAsExponential(places);
}

double toDouble(String x) {
  x = x.replaceAll("\u{2212}", '-');
  try {
    return double.parse(x);
  } catch (err) {
    // factorial
    if (x.contains('!')) {
      if (x == '!') return double.infinity;
      String number = x.substring(0, x.length - 1);
      num n = toDouble(number);
      if (n.toInt().toDouble() == n) if (n > 0)
        n = factorial(n.toInt());
      else
        n = pow(-1, n) * factorial(-n.toInt());
      else {
        if (n > 0)
          n = factorialFromGamma(n.toDouble());
        else
          n = -pi / (n * factorialFromGamma(-n.toDouble()) * sin(pi * n));
      }
      return n.toDouble();
    }
    // presence of E -  1E+1 = 1E1 1E-1 = 0.1
    else if (x.contains('E')) {
      var notation = x.split('E');
      if (notation == [])
        notation = ['1.0', '1.0'];
      else if (notation.length == 1)
        notation.add('1.0');
      else if (notation.last == '')
        notation.last = '1.0';
      else if (notation.last == '-' || notation.last == '+')
        notation.last += '1.0';
      var exp = notation.map((element) => toDouble(element)).toList();
      return exp.first * (pow(10, exp.last));
    }
    // presence of e
    else if (x.contains('e')) {
      var notation = x.split('e');
      if (notation == [])
        notation = ['1.0', '1.0'];
      else if (notation.length == 1)
        notation.add('1.0');
      else if (notation.last == '')
        notation.last = '1.0';
      else if (notation.last == '-' || notation.last == '+')
        notation.last += '1.0';
      List exp = notation.map((element) => double.parse(element)).toList();
      if (exp == []) exp = [1.0, 1.0];
      if (exp.length == 1) exp.add(0.0);
      return exp.first * (pow(e, exp.last));
    }
    //presence of pi
    else if (x.endsWith('\u{1d70b}')) {
      List notation;
      if (x == '\u{1d70b}')
        notation = ['1'];
      else
        notation = x.split('\u{1d70b}');
      var exp = double.parse(notation[0]);
      return exp * pi;
    } else {
      return double.infinity;
    }
  }
}

bool isNumeric(String s) {
  if (toDouble(s) != double.infinity) {
    return true;
  }
  return false;
}

double nthRoot(double x, double n) {
  var randomGenerator = Random(0);
  double xPrevious = randomGenerator.nextDouble() * 10;
  double epsilon = 0.00000001;
  double deltaX = x + 2;
  double xCurrent = 0.0;

  while (deltaX > epsilon) {
    xCurrent = ((n - 1.0) * xPrevious + x / pow(xPrevious, n - 1)) / n;
    deltaX = (xCurrent - xPrevious).abs();
    xPrevious = xCurrent;
  }
  return xCurrent;
}

String toSubscript(String x) {
  var val = x.split('');
  String subscript = '';
  for (var i in val) subscript += unicodeMap[i]!.last;
  return subscript;
}

String toSuperscript(String x) {
  var val = x.split('');
  String superscript = '';
  for (var i in val) superscript += unicodeMap[i]!.first;
  return superscript;
}

String subscriptToText(String x) {
  List<String> subscript = x.split('');
  String text = '';
  for (String i in subscript) text += subscriptMap[i]!;
  return text;
}

String superscriptToText(String x) {
  List<String> superscript = x.split('');
  String text = '';
  for (String i in superscript) text += superscriptMap[i]!;
  return text;
}

double factorial(int n) {
  List<double> factorialResult = [1.0];
  for (int i = 1; i <= n; i++) {
    factorialResult.add(i * factorialResult[i - 1]);
  }
  return factorialResult[n];
}

// Approximate function for factorial from gamma
// Work by Gergo Nemes, Hungary, refer..
// http://www.rskey.org/CMS/index.php/the-library/11

double factorialFromGamma(double a, {double x = 50}) {
  int n = 0;
  double coefficient = pow(x, a) * exp(-x);
  num expr = 1;
  double prev = a != 0 ? a : 1, curr = 0;
  while (prev != curr) {
    prev = curr;
    expr = pow(x, n);
    for (int i = 0; i <= n; ++i) {
      expr /= (a + i);
    }
    curr += expr;
    ++n;
  }
  return curr * coefficient;
}

void main() {
  // print(factorialFromGamma(5.5).toDouble());
  print(factorialFromGamma(3.1415902, x: 30.0));
}
