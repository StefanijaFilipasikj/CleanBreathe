import '../utils/values.dart';

class TextByAvgValue {

  static String get() {
    return switch(Values.valueType){
      "pm10" => getTextForPm10(),
      "pm25" => getTextForPm25(),
      "temperature" => getTextForTemperature(),
      "humidity" => getTextForHumidity(),
      "pressure" => getTextForPressure(),
      _ => getTextForNoise()
    };
  }

  static String getTextForPm10(){
    double value = Values.average;
    if (value < 26.0) return "Good air quality. Air quality is considered satisfactory, and air pollution poses little or no risk.";
    else if (value < 51.0) return "Moderate air quality. Air quality is acceptable. However, for some pollutants there may be a moderate health concern for a very small number of people.";
    else if (value < 91.0) return "Bad air quality. Unhealthy for sensitive groups, people with heart lung disease, older adults, and children.";
    else if (value < 180.0) return "Very Bad Air Quality. Everyone may begin to experience some adverse health effects, and members of the sensitive groups may experience more serious effects.";
    else return "Hazardous Air Quality. This would trigger health warnings of emergency conditions. The entire population is very likely to be affected.";
  }

  static String getTextForPm25(){
    double value = Values.average;
    if (value < 16.0) return "Good air quality. Air quality is considered satisfactory, and air pollution poses little or no risk.";
    else if (value < 31.0) return "Moderate air quality. Air quality is acceptable; however, for some pollutants there may be a moderate health concern for a very small number of people.";
    else if (value < 56.0) return "Bad air quality. Unhealthy for Sensitive Groups, people with lung disease, older adults and children.";
    else if (value < 110.0) return "Very Bad Air Quality. Everyone may begin to experience some adverse health effects, and members of the sensitive groups may experience more serious effects.";
    else return "Hazardous Air Quality. This would trigger health warnings of emergency conditions. The entire population is very likely to be affected.";
  }

  static String getTextForTemperature(){
    double value = Values.average;
    if (value < -6.0) return "Extremely cold temperature. Frostbite and hypothermia risks are high. Limit outdoor exposure.";
    else if (value < 7.0) return "Very cold temperature. Prolonged exposure may cause frostbite, eye pain and hypothermia.";
    else if (value < 16.0) return "Cool temperature. May cause a cold if not dressed properly.";
    else if (value < 23.0) return "Warm conditions. Intense physical activity may cause heat exhaustion.";
    else if (value < 31.0) return "Very warm temperature. May cause increased sweating, heat exhaustion and headaches.";
    else if (value < 37.0) return "Hot temperature. Extended exposure may lead to dehydration and heat exhaustion.";
    else return "Extreme heat. Risk of heatstroke and severe dehydration. Avoid outdoor activities.";
  }

  static String getTextForHumidity(){
    double value = Values.average;
    if (value < 31.0) return "Dry air. May cause dry nasal passages and skin, sore or scratchy throat and chapped lips.";
    else if (value < 71.0) return "Comfortable conditions. The humidity is considered pleasant and possesses no risk.";
    else return "Very humid. May cause increased sweating and dehydration, fatigue, heat exhaustion and in extreme cases heatstroke.";
  }

  static String getTextForPressure(){
    double value = Values.average;
    if (value < 801.0) return "Extremely low air pressure. Can lead to severe weather conditions like storms.";
    else if (value < 901.0) return "Very low pressure. Can lead to strong winds or heavy rainfall.";
    else if (value < 951.0) return "Low air pressure. Possible indicator of overcast or rainy conditions.";
    else if (value < 1001.0) return "Normal continental air pressure.";
    else if (value < 1051.0) return "Normal sea-side air pressure.";
    else return "High air pressure. Clear skies are likely.";
  }

  static String getTextForNoise(){
    double value = Values.average;
    if (value < 31.0) return "Quiet environment. Suitable for resting or focusing.";
    else if (value < 46.0) return "Generally quiet. Noise levels are noticeable but cause no discomfort.";
    else if (value < 61.0) return "Moderately calm, about the level of a conversation. Shouldn't cause discomfort.";
    else if (value < 76.0) return "Noisy urban daytime. Standard city noise pollution, can cause discomfort, trouble talking on the phone or general conversation.";
    else if (value < 91.0) return "Very noisy. Can cause significant discomfort and potential hearing issues over prolonged exposure.";
    else return "Extremely noisy. Risk of hearing damage. Avoid prolonged exposure.";
  }
}
