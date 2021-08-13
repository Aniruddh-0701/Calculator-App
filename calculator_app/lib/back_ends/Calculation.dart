import 'dart:io'; // For testing
import 'dart:math'; // For built-in mathematical functions
// stack for operator
import 'package:calculator_app/back_ends/stack.dart';
// Other mathematical and logical functions
import 'package:calculator_app/back_ends/CalculatorFunctions.dart';

class Calculate {
  List expression = []; // The input expression
  List result = []; // Result evaluation list
  Stack<String> operatorStack = Stack(); // operator stack
  double finalVal = 0.0;
  var isRad = 1;

  // trigonometry functions
  Map trigFunctions = {
    'sin': sin,
    'cos': cos,
    'tan': tan,
  };

  // inverse trigonometry
  Map invTrigFunctions = {
    'sin\u207B\u00b9': asin,
    'cos\u207B\u00b9': acos,
    'tan\u207B\u00b9': atan,
  };

  // hyperbolic functions
  Map hypFunctions = {
    'sinh\u207B\u00b9': arcsinh,
    'cosh\u207B\u00b9': arccosh,
    'tanh\u207B\u00b9': arctanh,
    'sinh': sinh,
    'cosh': cosh,
    'tanh': tanh,
  };

  // Regex to identify functions
  var mathRegEx = 'sin\u207B\u00b9sinh\u207B\u00b9'
      'cos\u207B\u00b9cosh\u207B\u00b9'
      'tan\u207B\u00b9tanh\u207B\u00b9';

  // List l = ['^', '/', '*', '%', '+', '-'];

  // operator Identification
  Map<String, int> arithmeticPrecedence = {
    '^': 3,
    '\u{00f7}': 2,
    '\u{00d7}': 2,
    '%': 2,
    '\u{002b}': 1,
    '\u{2212}': 1
  };

  // Evaluate expression passed in with respect to brackets
  calculate(List eqn, {int rad = 1}) {
    this.expression = ['(', ...eqn, ')'];
    this.isRad = rad;
    int start = 0, end = 0;

    // Unequal brackets -> Error
    if (eqn.where((e) => e == ')').length != eqn.where((e) => e == '(').length)
      return 'Syntax Error';

    // Split expression with brackets
    while (this.expression.contains(')')) {
      end = this.expression.indexOf(')');

      for (int j = end; j > -1; --j) {
        if (this.expression[j] == '(') {
          start = j;
          break;
        }
      }

      // print(this.eqn.sublist(start, end + 1));

      // generating expression identified in the bracket
      this.genExpression(start + 1, end);

      // Getting result of the expression
      var r = this.genResult();
      if ((r.abs() >= toDouble('1E10')) || r.abs() <= toDouble('1E-6')) {
        r = r.toStringAsExponential();
        r = r.replaceAll("e+", "e");
      } else
        r = r.toString();

      // replacing the expression by result
      this.expression = [
        ...this.expression.sublist(0, start),
        r,
        ...this.expression.sublist(end + 1, this.expression.length),
      ];
    }
    // print(this.eqn);
    finalVal = this.expression.first is double
        ? this.expression.first
        : toDouble(this.expression.first);
    // print(finalVal);
    // return roundOff(finalVal, 7);
    return this.expression.first;
  }

  // Converting infix expression from UI to postfix expression
  void genExpression(int start, int end) {
    // print('gen_exp');
    this.result = [];

    //iterate through the expression in the innermost parenthesis
    for (String i in expression.sublist(start, end)) {
      // print(i);
      if (i is double) this.result.add(i);

      // if not a double
      // check if it is a numerical String
      var d = toDouble(i);
      if (d != double.infinity)
        result.add(d);

      // result from previous evaluation
      else if (i == 'Ans')
        result.add(finalVal);

      // square root
      else if (i.contains('\u{221a}'))
        this.result.add(i);

      // trigonometric and hyperbolic function
      else if (this.mathRegEx.contains(i))
        this.result.add(i);

      // Log functions
      else if (i.contains('log'))
        this.result.add(i);
      else {
        // Update the operator stack using operator precedence
        while (this.operatorStack.isNotEmpty &&
            this.arithmeticPrecedence[i]! <
                this.arithmeticPrecedence[this.operatorStack.top()]!)
          this.result.add(this.operatorStack.pop());
        this.operatorStack.push(i);
      }
      // print('${this.result}, ${this.operatorStack.toString()}');
    }

    // Adding the operators reversed to set the proper order of working
    while (this.operatorStack.isNotEmpty) {
      this.result.add(this.operatorStack.pop());
    }

    // return (this.result);
    // print(this.result);
  }

  // Generating result
  genResult() {
    // print('genResult');
    // print(this.result);

    var j = 0;

    while (this.result.length > 1) {
      // print(this.result);

      var k = this.result[j];
      // print(k);

      // continue if k is a number
      if (k is double)
        j += 1;

      // if k is trigonometric
      else if (this.trigFunctions.containsKey(k)) {
        if (this.isRad == 0) this.result[j + 1] *= pi / 180;
        this.result[j] = this.trigFunctions[k](this.result[j + 1]);
        this.result.removeAt(j + 1);
      }

      // if k is inverse trigonometric
      else if (this.invTrigFunctions.containsKey(k)) {
        this.result[j] = this.invTrigFunctions[k](this.result[j + 1]);
        this.result.removeAt(j + 1);
        if (this.isRad == 0) this.result[j] *= 180 / pi;
      }

      // anti-log
      else if (k.contains('anti')) {
        this.result[j] = antilogarithm(this.result.removeAt(j + 1),
            toDouble(subscriptToText(k.substring(7))));
      }

      // logarithm
      else if (k.contains('log')) {
        this.result[j] = logarithm(this.result.removeAt(j + 1),
            base: toDouble(subscriptToText(k.substring(3))));
      }

      // if hyperbolic
      else if (this.hypFunctions.containsKey(k)) {
        this.result[j] = this.hypFunctions[k](this.result[j + 1]);
        this.result.removeAt(j + 1);
      }

      // containing sqrt
      else if (k.contains('\u{221a}')) {
        String exponent = k.substring(0, k.length - 1);
        this.result[j] =
            pow(this.result[j + 1], 1 / toDouble(superscriptToText(exponent)));
        this.result.removeAt(j + 1);
      }

      // general arithmetic operations
      else if (this.arithmeticPrecedence.containsKey(k)) {
        if (k == '\u{002b}') {
          this.result[j - 2] += this.result[j - 1];
        } else if (k == '\u{2212}') {
          this.result[j - 2] -= this.result[j - 1];
        } else if (k == '\u{00d7}') {
          this.result[j - 2] *= this.result[j - 1];
        } else if (k == '\u{00f7}') {
          this.result[j - 2] /= this.result[j - 1];
        } else if (this.result[j] == '^') {
          num n = pow(this.result[j - 2], this.result[j - 1]);
          if (this.result[j - 1] != 0 && (this.result[j - 2] < 0 && n > 0))
            n *= -1;
          this.result[j - 2] = n;
        }
        this.result.removeAt(j - 1);
        this.result.removeAt(j - 1);
        j -= 1;
      }
      if (j >= this.result.length) j = 0;
      // print('${this.result[j]}');
    }
    // print(this.result.first);
    return (this.result.first);
  }
}

// int boolToInt(bool v) => v? 1:0 ;

// Main fn to test the code.
void main() {
  List eqn = [];
  var cal = Calculate();

  // eqn = "11 \u{00f7} 2 \u{00d7} 2 \u{00f7} 11".split(' ').toList();
  eqn = ['\u{2212}200', '\u{00d7}', '10'];

  print('Enter a equation\n');

  eqn = stdin.readLineSync()!.split(' ').toList();

  // print(eqn);

  print(cal.calculate(eqn));
  print(' ');
  print(pow(10.0, 40.0).toStringAsExponential(7));
  print(antilogarithm(40 * logarithm(10), 10));
  print(antilogarithm(100 * logarithm(2), 10));

  // print(eqn);
  // var x = '10.';
  // print(isNumeric(x));
}
