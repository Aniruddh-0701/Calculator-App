import 'dart:math';

double sinh(num x) => (exp(x) - exp(-x)) / 2;

double cosh(num x) => (exp(x) + exp(-x)) / 2;

double tanh(num x) => (exp(2 * x) - 1) / (exp(2 * x) + 1);

double arcsinh(num x) => log(x + sqrt(x * x + 1));

double arccosh(num x) => log(x + sqrt(x * x - 1));

double arctanh(num x) => log((1 + x) / (1 - x)) / 2;

double logarithm(num x, {num base = 10}) => log(x) / log(base);

void main() {
  var x = [10, 20];
  // print('${logarithm(8, base: 2)}');
  print('${x.removeAt(0)}');
}
