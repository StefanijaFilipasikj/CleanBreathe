import 'dart:ui';

class GetColorForValue {
  static String valueType = "pm10";

  static Color darkBlue = Color.fromRGBO(9, 76, 135, 1.0);
  static Color lightBlue = Color.fromRGBO(47, 117, 175, 1.0);
  static Color darkGreen = Color.fromRGBO(38, 124, 47, 1);
  static Color lightGreen = Color.fromRGBO(83, 159, 66, 1.0);
  static Color yellowOrange = Color.fromRGBO(255, 167, 85, 1);
  static Color lightRed = Color.fromRGBO(179, 55, 67, 1.0);
  static Color darkRed = Color.fromRGBO(140, 31, 57, 1.0);
  static Color darkPurple = Color.fromRGBO(97, 18, 58, 1.0);

  static Color get(double value) {
    return switch(valueType){
      "pm10" => getColorForPm10(value),
      "pm25" => getColorForPm25(value),
      "temperature" => getColorForTemperature(value),
      "humidity" => getColorForHumidity(value),
      "pressure" => getColorForPressure(value),
      _ => getColorForNoise(value)
    };
  }

  static Color getColorForPm10(double value){
    if (value < 26.0) return darkGreen;
    else if (value < 51.0) return lightGreen;
    else if (value < 91.0) return yellowOrange;
    else if (value < 180.0) return lightRed;
    else return darkRed;
  }

  static Color getColorForPm25(double value){
    if (value < 16.0) return darkGreen;
    else if (value < 31.0) return lightGreen;
    else if (value < 56.0) return yellowOrange;
    else if (value < 110.0) return lightRed;
    else return darkRed;
  }

  static Color getColorForTemperature(double value){
    if (value < -6.0) return darkBlue;
    else if (value < 7.0) return lightBlue;
    else if (value < 16.0) return darkGreen;
    else if (value < 23.0) return lightGreen;
    else if (value < 31.0) return yellowOrange;
    else if (value < 37.0) return lightRed;
    else return darkRed;
  }

  static Color getColorForHumidity(double value){
    if (value < 31.0) return yellowOrange;
    else if (value < 71.0) return lightGreen;
    else return darkBlue;
  }

  static Color getColorForPressure(double value){
    if (value < 801.0) return darkBlue;
    else if (value < 901.0) return lightBlue;
    else if (value < 951.0) return darkGreen;
    else if (value < 1001.0) return lightGreen;
    else if (value < 1051.0) return yellowOrange;
    else return lightRed;
  }

  static Color getColorForNoise(double value){
    if (value < 31.0) return darkGreen;
    else if (value < 46.0) return lightGreen;
    else if (value < 61.0) return yellowOrange;
    else if (value < 76.0) return lightRed;
    else if (value < 91.0) return darkRed;
    else return darkPurple;
  }
}
