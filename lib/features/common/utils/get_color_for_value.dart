import 'dart:ui';

class GetColorForValue {
  //TODO: different color scale by pollutant
  static Color get(double value) {
    if (value < 20.0) {
      return const Color.fromRGBO(38, 124, 47, 1);
    } else if (value < 50.0) {
      return const Color.fromRGBO(84, 172, 64, 1);
    } else if (value < 80.0) {
      return const Color.fromRGBO(255, 167, 85, 1);
    } else if (value < 150.0) {
      return const Color.fromRGBO(224, 87, 101, 1);
    } else {
      return const Color.fromRGBO(138, 46, 55, 1);
    }
  }
}
