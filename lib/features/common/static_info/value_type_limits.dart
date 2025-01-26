import '../utils/values.dart';

class Limits {
  static Map<String, double> minMap = {
    "pm10" : 0,
    "pm25" : 0,
    "temperature" : -20,
    "humidity" : 0,
    "pressure" : 600,
    "noise": 0
  };
  static double min() {
    return minMap[Values.valueType] ?? 0.0;
  }

  static Map<String, double> maxMap = {
    "pm10": 200.0,
    "pm25": 110.0,
    "temperature": 40.0,
    "humidity": 100.0,
    "pressure": 1200.0,
    "noise": 90.0
  };
  static double max(){
    return maxMap[Values.valueType] ?? 0.0;
  }

  static double interval(){
    final double max = maxMap[Values.valueType] ?? 0.0;
    final double min = minMap[Values.valueType] ?? 0.0;
    double l = (max - min) / 10;
    print('max: ' + max.toString() + ' min:' + min.toString() + ' l: ' + l.toString());
    return ((l + 9) ~/ 10) * 10; //next larger number divisible by 10
  }
}
