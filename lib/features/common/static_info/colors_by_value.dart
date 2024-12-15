import 'dart:ui';
import '../utils/values.dart';
import '../utils/colors.dart';

class ColorByValue {
  static Color get(double value) {
    return switch(Values.valueType){
      "pm10" => getColorForPm10Value(value),
      "pm25" => getColorForPm25Value(value),
      "temperature" => getColorForTemperatureValue(value),
      "humidity" => getColorForHumidityValue(value),
      "pressure" => getColorForPressureValue(value),
      _ => getColorForNoiseValue(value)
    };
  }

  static Color getColorForPm10Value(double value){
    if (value < 26.0) return CustomColor.darkGreen;
    else if (value < 51.0) return CustomColor.lightGreen;
    else if (value < 91.0) return CustomColor.yellowOrange;
    else if (value < 180.0) return CustomColor.lightRed;
    else return CustomColor.darkRed;
  }

  static Color getColorForPm25Value(double value){
    if (value < 16.0) return CustomColor.darkGreen;
    else if (value < 31.0) return CustomColor.lightGreen;
    else if (value < 56.0) return CustomColor.yellowOrange;
    else if (value < 110.0) return CustomColor.lightRed;
    else return CustomColor.darkRed;
  }

  static Color getColorForTemperatureValue(double value){
    if (value < -6.0) return CustomColor.darkBlue;
    else if (value < 7.0) return CustomColor.lightBlue;
    else if (value < 16.0) return CustomColor.darkGreen;
    else if (value < 23.0) return CustomColor.lightGreen;
    else if (value < 31.0) return CustomColor.yellowOrange;
    else if (value < 37.0) return CustomColor.lightRed;
    else return CustomColor.darkRed;
  }

  static Color getColorForHumidityValue(double value){
    if (value < 31.0) return CustomColor.yellowOrange;
    else if (value < 71.0) return CustomColor.lightGreen;
    else return CustomColor.darkBlue;
  }

  static Color getColorForPressureValue(double value){
    if (value < 801.0) return CustomColor.darkBlue;
    else if (value < 901.0) return CustomColor.lightBlue;
    else if (value < 951.0) return CustomColor.darkGreen;
    else if (value < 1001.0) return CustomColor.lightGreen;
    else if (value < 1051.0) return CustomColor.yellowOrange;
    else return CustomColor.lightRed;
  }

  static Color getColorForNoiseValue(double value){
    if (value < 31.0) return CustomColor.darkGreen;
    else if (value < 46.0) return CustomColor.lightGreen;
    else if (value < 61.0) return CustomColor.yellowOrange;
    else if (value < 76.0) return CustomColor.lightRed;
    else if (value < 91.0) return CustomColor.darkRed;
    else return CustomColor.darkPurple;
  }
}