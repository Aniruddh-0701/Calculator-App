import 'dart:io';
import 'dart:math';
// import 'package:string_validator/string_validator.dart';

class Calculate {
  List eqn = List();
  List result = List();
  List op = List();
  var isRad = 1;

  Map trig = {'sin': sin, 'cos': cos, 'tan': tan,};
  Map logFn = {'log': log, 'ln': log,};

  Map invTrig = {'arcsin': asin, 'arccos': acos, 'arctan': atan,};

  // Map hyp = {'arcsinh': asinh, 'arccosh': acosh,
  //   'arctanh': atanh, 'sinh': sinh, 'cosh': cosh, 'tanh': tanh,};

  // List l = ['^', '/', '*', '%', '+', '-'];
  List l = ['^', '\u{00d7}', '\u{00f7}', '%', '\u{002b}', '\u{2212}'];
  // RegExp digits = new RegExp(r"(\d+)");

  genExpression(int start, int end){
    // print('gen_exp');
    this.result = List();
    var i;
    for(i in eqn.sublist(start, end)) {
      try {
        result.add(double.parse(i));
        continue;
      }catch(e){

      if(i == 'pi')
        this.result.add(pi);
      else if(i == 'e')
        this.result.add(e);
      else if (this.trig.containsKey(i))
        this.result.add(i);
      else if(logFn.containsKey(i))
        this.result.add(i);
      else if(this.invTrig.containsKey(i))
        this.result.add(i);
      // else if( i in this.hyp.keys()
      // this.result.add(i);
      // else if i == "(":
      //   this.op.append(i)
      //else if i == ")":
      //   while "(" in this.op and this.op[-1] != "(":
      //      this.result.append(this.op.pop())
      // this.op.pop()
      else{
        if(this.op.length > 0 && this.op.last != "("){
          while(this.op.length > 0 && this.l.indexOf(i) > this.l.indexOf(this.op.last))
            this.result.add(this.op.removeLast());
        }
        this.op.add(i);
      }
      // print('${this.result}, ${this.op}');
    }}
    this.result.addAll(this.op.reversed);
    this.op = List();
    // return (this.result)
    // print(this.result);
  }

  genResult(){
    // print('genResult');
    // print(this.result);
    var j = 0;
    while(this.result.length > 1){
      var k = this.result[j];
      if (k is double)
        j += 1;
      else if(this.trig.containsKey(k)){
        if (this.isRad == 0)
          this.result[j + 1] *= pi / 180;
        this.result[j] = this.trig[k](this.result[j + 1]);
        this.result.removeAt(j - 1);
      }
      else if(this.invTrig.containsKey(k)){
        this.result[j] = this.invTrig[k](this.result[j + 1]);
        this.result.removeAt(j - 1);
        if (this.isRad == 0)
          this.result[j] *= 180 / pi;
      }
      else if(this.logFn.containsKey(k)){
        this.result[j] = this.logFn[k](this.result[j + 1]);
        this.result.removeAt(j - 1);
      }
      // elif this.result[j] in this.hyp.keys(){
      //   this.result[j] = this.hyp[this.result[j]](this.result[j + 1])
      //   this.result.pop(j - 1)
      // }
      else if(this.l.contains(k)){
        if(k == '\u{002b}')
          this.result[j - 2] += this.result[j - 1];
        else if(k == '\u{2212}')
          this.result[j - 2] -= this.result[j - 1];
        else if(k == '\u{00d7}')
          this.result[j - 2] *= this.result[j - 1];
        else if(k == '\u{00f7}')
          this.result[j - 2] /= this.result[j - 1];
        else if(this.result[j] == '^'){}
          // implementation needed this.result[j - 2] **= this.result[j - 1]
        this.result.removeAt(j - 1);
        this.result.removeAt(j - 1);
        j-=1;
      }
      if(j >= this.result.length)
        j = 0;
    }
    return(this.result.first);
  }

}

class ECalculate extends Calculate{

  ECalculate(List eqn, {int rad = 1}){
    this.eqn = ['(', ...eqn, ')'];
    this.isRad = rad;
    // print(this.eqn);
  }

  calculate(){
    int start, end;
    if(eqn.where((e) => e == ')').length != eqn.where((e) => e == '(').length)
      return 'Syntax Error';
    while(this.eqn.contains(')')) {
      end = this.eqn.indexOf(')');
      for (int j = end; j > -1; j--) {
        if (this.eqn[j] == '(') {
          start = j;
          break;
        }
      }
      // print(this.eqn.sublist(start, end + 1));
      this.genExpression(start + 1, end);
      // this.eqn.replaceRange(start, end + 1, this.genResult());
      this.eqn = [...eqn.sublist(0, start), this.genResult(), ...eqn.sublist(end+1, eqn.length)];
      // print(this.eqn);
    }
    var value = this.eqn.first;
    if(value.toInt().toDouble() == eqn.first)
      return value.toInt();
    else
      return roundOff(value, 7);
  }

}

bool isNumeric(String s) {
  if(s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

double roundOff(double value, int places){
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

// int boolToInt(bool v) => v? 1:0 ;

// Main fn to test the code.
void main(){
  // List eqn = List();
  // eqn = stdin.readLineSync().split(' ').toList();
  // var cal = ECalculate(eqn);
  // print(cal.calculate());
  // print(eqn);
  var x = '10.';
  print(isNumeric(x));
}
