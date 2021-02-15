// import 'dart:io';
import 'dart:math';

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
Map<String, double> mass = {
  'g': 0.001,
  'kg': 1.0,
  'lb': 0.45359237,
  'oz': 0.0283495231,
  'ton': 907.185,
  'tonne': 1000.0,
};
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

List<String> temperatureUnits = ['K', '\u00b0C', '\u00b0F', '\u00b0R'];

double lengthConverter(double val, String fromUnit, String toUnit) {
  return val * length[fromUnit]! / length[toUnit]!;
}

double massConverter(double val, String fromUnit, String toUnit) {
  return val * mass[fromUnit]! / mass[toUnit]!;
}

double volumeConverter(double val, String fromUnit, String toUnit) {
  return val * volume[fromUnit]! / volume[toUnit]!;
}

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
  return temperature;
}

void main() {
  num vol = volumeConverter(1, 'm\u00b3', 'l');
  print(vol);
  print(length.keys.toList());
}
