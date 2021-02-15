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

double roundOff(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

double toDouble(String x) {
  if (x.contains('E')) {
    var notation = x.split('E');
    if (notation.length == 1) notation.add('1.0');
    else if(notation.last=='') notation.last='1.0';
    var exp = notation.map((element) => double.parse(element)).toList();
    return exp.first * (pow(10, exp.last));
  } else if (x.contains('e')) {
    var notation = x.split('e');
    if (notation.length == 1) notation.add('1.0');
    else if(notation.last=='') notation.last='1.0';
    List exp = notation.map((element) => double.parse(element)).toList();
    if (exp == []) exp = [1.0, 1.0];
    if (exp.length == 1) exp.add(0.0);
    return exp.first * (pow(e, exp.last));
  } else if (x.endsWith('\u{1d70b}')) { // pi
    List notation;
    if(x=='\u{1d70b}') notation = ['1'];
    else notation = x.split('\u{1d70b}');
    var exp = double.parse(notation[0]);
    return exp * pi;
  } else if(x.contains('!')){
    String number = x.substring(0, x.length-1);
    num n = toDouble(number);
    if(n.toInt().toDouble() == n)
      n = factorial(n.toInt());
    else
      n = factorialFromGamma(n.toDouble());
    return n.toDouble();
  } else{
   try{
     return double.parse(x);
   }catch(e){
     return double.infinity;
   }
  }
}

bool isNumeric(String s) {
  if(toDouble(s)!=double.infinity){
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
  List subscript = x.split('');
  String text = '';
  for (var i in subscript) text += subscriptMap[i];
  return text;
}

String superscriptToText(String x) {
  List superscript = x.split('');
  String text = '';
  for (var i in superscript) text += superscriptMap[i];
  return text;
}

int factorial(int n) {
  List<int> factorialResult = [1];
  for (int i = 1; i <= n; i++) {
    factorialResult.add(i * factorialResult[i - 1]);
  }
  return factorialResult[n];
}

// Approximate function for factorial from gamma
// Work by Gergo Nemes, Hungary, refer..
// http://www.rskey.org/CMS/index.php/the-library/11

double factorialFromGamma(double x){
  double factorialVal = pow(e, -x) * sqrt(2*pi*x) * pow((x + 1/(12*x) +
      1/(1440 * pow(x,3)) + 239/(362880 * pow(x, 5))), x);
  double error = pow(x, -8)*0.802919;
  // print(error);
  return factorialVal-error;
}

void main() {
  print(factorialFromGamma(5.5).toDouble());
}
