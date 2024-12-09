
class GetTextForValue {
  //TODO: different color scale by pollutant
  static String get(double value) {
    if (value < 20.0) {
      return "Good air quality. Air quality is considered satisfactory, and air pollution poses little or no risk.";
    } else if (value < 50.0) {
      return "Moderate air quality. Air quality is acceptable. However, for some pollutants there may be a moderate health concern for a very small number of people.";
    } else if (value < 80.0) {
      return "Bad air quality. Unhealthy for Sensitive Groups, people with heart lung disease, older adults, and children.";
    } else if (value < 150.0) {
      return "Very Poor Air Quality. Consider limiting your outside exposure.";
    } else {
      return "Toxic Air Quality. Consider limiting your outside exposure.";
    }
  }
}
