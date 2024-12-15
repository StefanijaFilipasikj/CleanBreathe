import '../utils/values.dart';

class Limits {
  static double min() {
    return switch(Values.valueType){
      "pm10" => 0,
      "pm25" => 0,
      "temperature" => -20,
      "humidity" => 0,
      "pressure" => 600,
      _ => 0
    };
  }

  static double max(){
    return switch(Values.valueType){
      "pm10" => 200,
      "pm25" => 110,
      "temperature" => 40,
      "humidity" => 100,
      "pressure" => 1200,
      _ => 90
    };
  }

  static double interval(){
    return switch(Values.valueType){
      "pm10" => 20,
      "pm25" => 10,
      "temperature" => 5,
      "humidity" => 10,
      "pressure" => 100,
      _ => 15
    };
  }
}
