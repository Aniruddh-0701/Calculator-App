import 'dart:math';

double sinh(num x) => (exp(x) - exp(-x)) / 2;

double cosh(num x) => (exp(x) + exp(-x)) / 2;

double tanh(num x) => (exp(2 * x) - 1) / (exp(2 * x) + 1);

double arcsinh(num x) => log(x + sqrt(x * x + 1));

double arccosh(num x) => log(x + sqrt(x * x - 1));

double arctanh(num x) => log((1 + x) / (1 - x)) / 2;

double logarithm(num x, {num base = 10}) => log(x) / log(base);

double antilogarithm(num x, num base) => pow(base, x);

double roundOff(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

double toDouble(String x){
  if (x.contains('E')){
    var notation = x.split('E');
    var exp = notation.map(
            (element) => double.parse(element)).toList();
    if (exp.length==1) exp.add(1.0);
    return exp.first * (pow(10, exp.last));
  }else if(x.contains('e')){
    var notation = x.split('e');
    var exp = notation.map(
            (element) => double.parse(element)).toList();
    if (exp == null) exp = [1.0, 1.0];
    if (exp.length==1) exp.add(1.0);
    return exp.first * (pow(e, exp.last));
  }else if(x.endsWith('\u{1d70b}')){
    var notation = x.split('\u{1d70b}');
    var exp = double.parse(notation[0]);
    return exp * pi;
  }
  else return double.parse(x);
}

double nthRoot(double x, double n){
  var randomGenerator = Random(0);
  double xPrevious = randomGenerator.nextDouble() * 10;
  double epsilon = 0.00000001;
  double deltaX = x + 2;
  double xCurrent = 0.0;

  while (deltaX > epsilon){
    xCurrent = ((n - 1.0) * xPrevious + x/pow(xPrevious, n-1))/n;
    deltaX = (xCurrent-xPrevious).abs();
    xPrevious = xCurrent;
  }
  return xCurrent;
}

void main() {
  var x = [10, 20];
  // print('${logarithm(8, base: 2)}');
  print(toDouble('2\u{1d70b}'));
  // print('${nthRoot(4, 2)}');
}
