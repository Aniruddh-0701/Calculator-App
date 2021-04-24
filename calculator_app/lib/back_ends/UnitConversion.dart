// import 'dart:io';
import 'dart:math';
import 'package:calculator_app/back_ends/CalculatorFunctions.dart';

//length units
Map<String, double> length = {
  'km': 1000.0,
  'm': 1.0,
  'cm': 0.01,
  'mm': 0.001,
  'in': 0.0254,
  'ft': 0.3048,
  'yd': 0.944,
  'mi': 1609.344,
  '\u{00b5}m': 0.000001
};

//mass units
Map<String, double> mass = {
  'g': 0.001,
  'kg': 1.0,
  'lb': 0.45359237,
  'oz': 0.0283495231,
  'ton': 907.185,
  'tonne': 1000.0,
};

// volume units
Map<String, double> volume = {
  'cm\u00B3': pow(0.01, 3).toDouble(),
  'm\u00B3': 1.0,
  'mm\u00B3': pow(0.001, 3).toDouble(),
  'in\u00B3': pow(0.0254, 3).toDouble(),
  'ft\u00B3': pow(0.3048, 3).toDouble(),
  'yd\u00B3': pow(0.944, 3).toDouble(),
  'mi\u00B3': pow(1609.344, 3).toDouble(),
  '\u2113': 0.001,
  'm\u2113': pow(0.01, 3).toDouble(),
  'us-gal': 0.00378541178,
  'imp-gal': 0.00454609,
  'quart': 0.00113652,
  'pint': 0.000568261,
};

// force units
Map<String, double> force = {
  'N': 1.0,
  'kgf': 9.80665,
  'dyne': 0.00001,
  'lbf': 4.4482216153,
  'gf': 0.00980665,
  'pdl': 0.1382250,
};

//pressure units
Map<String, double> pressure = {
  'Pa': 1.0,
  'bar': 100000,
  'atm': 101325,
  'psi': 6894.75729,
  'torr': 101325 / 760,
};

//temperature units
List<String> temperatureUnits = ['K', '\u00b0C', '\u00b0F', '\u00b0R'];

//length converter
double lengthConverter(double val, String fromUnit, String toUnit) {
  return roundOff(val * length[fromUnit]! / length[toUnit]!, 7);
}

//mass converter
double massConverter(double val, String fromUnit, String toUnit) {
  return roundOff(val * mass[fromUnit]! / mass[toUnit]!, 7);
}

//volume converter
double volumeConverter(double val, String fromUnit, String toUnit) {
  return roundOff(val * volume[fromUnit]! / volume[toUnit]!, 7);
}

//temperature converter
double temperatureConverter(double val, String fromUnit, String toUnit) {
  double temperature = val;
  switch (fromUnit) {
    case 'K':
      temperature -= 273.15;
      break;
    case '\u00b0F':
      temperature = (temperature - 32) * 5 / 9;
      break;
    case '\u00b0R':
      temperature = (temperature - 491.67) * 5 / 9;
      break;
    default:
      temperature *= 1.0;
  }
  switch (toUnit) {
    case 'K':
      temperature += 273.15;
      break;
    case '\u00b0F':
      temperature = (temperature * 9 / 5) + 32;
      break;
    case '\u00b0R':
      temperature = (temperature * 9 / 5) + 491.67;
      break;
    default:
      temperature /= 1.0;
  }
  return roundOff(temperature, 7);
}

//force converter
double forceConverter(double val, String fromUnit, String toUnit) {
  return roundOff(val * force[fromUnit]! / force[toUnit]!, 7);
}

//pressure converter
double pressureConverter(double val, String fromUnit, String toUnit) {
  return roundOff(val * pressure[fromUnit]! / pressure[toUnit]!, 7);
}

void main() {
  num vol = volumeConverter(1, 'm\u00b3', 'l');
  print(vol);
  print(length.keys.toList());
}
