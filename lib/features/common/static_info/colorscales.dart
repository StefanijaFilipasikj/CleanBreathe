import '../utils/values.dart';
import '../utils/colors.dart';

class ColorScale {

  static List<Map<String, dynamic>> get() {
    return switch(Values.valueType){
      "pm10" => getColorScaleForPm10(),
      "pm25" => getColorScaleForPm25(),
      "temperature" => getColorScaleForTemperature(),
      "humidity" => getColorScaleForHumidity(),
      "pressure" => getColorScaleForPressure(),
      _ => getColorScaleForNoise()
    };
  }

  static List<Map<String, dynamic>> getColorScaleForPm10() {
    return [
      {'color': CustomColor.darkGreen, 'label': '0 μg/m³'},
      {'color': CustomColor.lightGreen, 'label': '25 μg/m³'},
      {'color': CustomColor.yellowOrange, 'label': '50 μg/m³'},
      {'color': CustomColor.lightRed, 'label': '90 μg/m³'},
      {'color': CustomColor.darkRed, 'label': '180 μg/m³'},
    ];
  }

  static List<Map<String, dynamic>> getColorScaleForPm25() {
    return [
      {'color': CustomColor.darkGreen, 'label': '0 μg/m³'},
      {'color': CustomColor.lightGreen, 'label': '15 μg/m³'},
      {'color': CustomColor.yellowOrange, 'label': '30 μg/m³'},
      {'color': CustomColor.lightRed, 'label': '55 μg/m³'},
      {'color': CustomColor.darkRed, 'label': '110 μg/m³'},
    ];
  }

  static List<Map<String, dynamic>> getColorScaleForTemperature() {
    return [
      {'color': CustomColor.darkBlue, 'label': '-20 °C'},
      {'color': CustomColor.lightBlue, 'label': '-5 °C'},
      {'color': CustomColor.darkGreen, 'label': '6 °C'},
      {'color': CustomColor.lightGreen, 'label': '15 °C'},
      {'color': CustomColor.yellowOrange, 'label': '22 °C'},
      {'color': CustomColor.lightRed, 'label': '30 °C'},
      {'color': CustomColor.darkRed, 'label': '36 °C'},
    ];
  }

  static List<Map<String, dynamic>> getColorScaleForHumidity() {
    return [
      {'color': CustomColor.yellowOrange, 'label': '0 %'},
      {'color': CustomColor.lightGreen, 'label': '30 %'},
      {'color': CustomColor.darkBlue, 'label': '70 %'}
    ];
  }

  static List<Map<String, dynamic>> getColorScaleForPressure() {
    return [
      {'color': CustomColor.darkBlue, 'label': '600 hPa'},
      {'color': CustomColor.lightBlue, 'label': '800 hPa'},
      {'color': CustomColor.darkGreen, 'label': '900 hPa'},
      {'color': CustomColor.lightGreen, 'label': '950 hPa'},
      {'color': CustomColor.yellowOrange, 'label': '1000 hPa'},
      {'color': CustomColor.lightRed, 'label': '1050 hPa'}
    ];
  }

  static List<Map<String, dynamic>> getColorScaleForNoise() {
    return [
      {'color': CustomColor.darkGreen, 'label': '0 dBA'},
      {'color': CustomColor.lightGreen, 'label': '30 dBA'},
      {'color': CustomColor.yellowOrange, 'label': '45 dBA'},
      {'color': CustomColor.lightRed, 'label': '60 dBA'},
      {'color': CustomColor.darkRed, 'label': '75 dBA'},
      {'color': CustomColor.darkPurple, 'label': '90 dBA'}
    ];
  }
}