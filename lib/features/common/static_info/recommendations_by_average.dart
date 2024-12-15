import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/values.dart';

class Recommendation {
  static List<Map<String, dynamic>> getRecommendationForValue() {
    return switch (Values.valueType) {
      "pm10" => getRecommendationsForPm10(),
      "pm25" => getRecommendationsForPm25(),
      "temperature" => getRecommendationsForTemperature(),
      "humidity" => getRecommendationsForHumidity(),
      "pressure" => getRecommendationsForPressure(),
      _ => getRecommendationsForNoise()
    };
  }

  static List<Map<String, dynamic>> getRecommendationsForPm10() {
    List<String> texts = [];
    double value = Values.average;
    if (value < 26.0) {
      texts.add('Air quality is good for health-sensitive groups.');
      texts.add('Feel free to enjoy outdoor activities.');
      texts.add('Indoor air quality is excellent.');
      texts.add('No masks are needed. Enjoy your day!');
    } else if (value < 51.0) {
      texts.add('People with chronic heart or lung disease, children and asthmatics might feel discomfort.');
      texts.add('Outdoor activities are generally safe but limit exposure.');
      texts.add('Keep indoor spaces well-ventilated.');
      texts.add('Sensitive groups can use lightweight masks outdoors if needed.');
    } else if (value < 91.0) {
      texts.add('People with chronic heart or lung disease, children and asthmatics could feel discomfort.');
      texts.add('Consider postponing outdoor activities.');
      texts.add('Use air purifiers indoors.');
      texts.add('Use N95 masks when outdoors.');
    } else if (value < 180.0) {
      texts.add('People with chronic heart or lung disease, children and asthmatics will feel discomfort.');
      texts.add('Avoid prolonged outdoor exposure.');
      texts.add('Avoid opening windows to maintain indoor air quality.');
      texts.add('High-grade masks like N95 are strongly recommended.');
    } else {
      texts.add('People with chronic heart or lung disease, children and asthmatics will definitely feel discomfort.');
      texts.add('Avoid all outdoor activities, air quality is hazardous.');
      texts.add('Seal indoor spaces to prevent pollution, and use air purifiers.');
      texts.add('Only go outdoors for emergencies, wearing an N95 or FFP3 mask.');
    }

    return [
      {'icon': FontAwesomeIcons.heartPulse, 'text': texts[0]},    // health-sensitive groups
      {'icon': FontAwesomeIcons.cloudSunRain, 'text': texts[1]},  // outdoor activities
      {'icon': FontAwesomeIcons.houseChimney, 'text': texts[2]},  // indoor recommendations
      {'icon': FontAwesomeIcons.maskFace, 'text': texts[3]},      // personal protection
    ];
  }

  static List<Map<String, dynamic>> getRecommendationsForPm25() {
    List<String> texts = [];
    double value = Values.average;
    if (value < 16.0) {
      texts.add('Air quality is excellent for all groups.');
      texts.add('Outdoor activities are completely safe.');
      texts.add('Enjoy fresh indoor air.');
      texts.add('No protective measures are necessary. Enjoy your day!');
    } else if (value < 31.0) {
      texts.add('Health-sensitive individuals should minimize exposure.');
      texts.add('Outdoor activities are fine with precautions.');
      texts.add('Maintain proper indoor air circulation.');
      texts.add('Carry a lightweight mask if you are sensitive to air pollution.');
    } else if (value < 56.0) {
      texts.add('Asthmatics, people with respiratory inflammation or jeopardized lung functions might feel discomfort.');
      texts.add('Avoid outdoor activities.');
      texts.add('Use air purifiers indoors.');
      texts.add('Wear an N95 mask if you are sensitive to air pollution.');
    } else if (value < 110.0) {
      texts.add('Asthmatics, people with respiratory inflammation or jeopardized lung functions will feel discomfort.');
      texts.add('Avoid all outdoor activities.');
      texts.add('Seal indoor spaces to prevent pollution, and use air purifiers.');
      texts.add('Use N95 or FFP3 masks if you must go outside.');
    }else{
      texts.add('Asthmatics, people with respiratory inflammation or jeopardized lung functions will feel discomfort.');
      texts.add('Avoid all outdoor activities, air quality is hazardous.');
      texts.add('Seal indoor spaces to prevent pollution, and use air purifiers.');
      texts.add('Only leave your home for emergencies, wearing an N95 or FFP3 mask.');
    }

    return [
      {'icon': FontAwesomeIcons.heartPulse, 'text': texts[0]},    // health-sensitive groups
      {'icon': FontAwesomeIcons.cloudSunRain, 'text': texts[1]},  // outdoor activities
      {'icon': FontAwesomeIcons.houseChimney, 'text': texts[2]},  // indoor recommendations
      {'icon': FontAwesomeIcons.maskFace, 'text': texts[3]},      // personal protection
    ];
  }

  static List<Map<String, dynamic>> getRecommendationsForTemperature() {
    List<String> texts = [];
    double value = Values.average;
    if(value < -6){
      texts.add('People with heart conditions, asthma, respiratory infections or joint pain might feel discomfort.');
      texts.add('Avoid going outside, but if you do, dress warmly with a lot of layers.');
      texts.add('Ensure indoor heating is sufficient, wear warm clothing and make yourself some tea.');
      texts.add('Skin conditions like psoriasis and eczema might worsen. Protect exposed skin to prevent frostbite. Use a heavy moisturizer.');
    }else if(value < 7.0){
      texts.add('People with heart conditions, asthma, respiratory infections or joint pain might feel discomfort.');
      texts.add('Dress warmly for outdoor activities, wear a lot of layers.');
      texts.add('Ensure indoor heating is sufficient.');
      texts.add('Skin conditions like psoriasis and eczema might worsen. Cover hands and face with gloves and scarves. Moisturize regularly.');
    }
    else if (value < 16.0) {
      texts.add('People with heart conditions, asthma, respiratory infections or joint pain might feel discomfort.');
      texts.add('Dress warmly for outdoor activities.');
      texts.add('Keep indoor temperatures comfortable.');
      texts.add('Use sunscreen if the UV is above 3 to protect your skin.');
    }else if (value < 23.0) {
      texts.add('Temperature is ideal for all health-sensitive groups.');
      texts.add('Wear a light jacket for outdoor activities.');
      texts.add('Keep indoor temperatures comfortable.');
      texts.add('Use sunscreen if the UV is above 3 to protect your skin.');
    } else if (value < 31.0) {
      texts.add('Temperature is ideal for all health-sensitive groups.');
      texts.add('Perfect temperature for outdoor activities.');
      texts.add('Keep indoor temperatures comfortable.');
      texts.add('Use sunscreen to protect your skin and drink a lot of water to stay hydrated.');
    } else if(value < 37.0) {
      texts.add('People with cardiovascular diseases, diabetes, mental health or asthma might feel discomfort.');
      texts.add('Limit outdoor activities during midday.');
      texts.add('Use air conditioning or fans to maintain comfort indoors.');
      texts.add('Use sunscreen to protect your skin and drink a lot of water to stay hydrated.');
    }else{
      texts.add('People with cardiovascular diseases, diabetes, mental health or asthma might feel discomfort.');
      texts.add('Avoid outdoor activities, especially during the hottest hours.');
      texts.add('Use air conditioning or fans to maintain comfort indoors.');
      texts.add('Use sunscreen to protect your skin, wear protective clothing, and drink a lot of water to stay hydrated.');
    }

    return [
      {'icon': FontAwesomeIcons.heartPulse, 'text': texts[0]},          // health-sensitive groups
      {'icon': FontAwesomeIcons.cloudSunRain, 'text': texts[1]},        // outdoor activities
      {'icon': FontAwesomeIcons.houseChimney, 'text': texts[2]},        // indoor recommendations
      {'icon': FontAwesomeIcons.handHoldingDroplet, 'text': texts[3]},  // skin
    ];
  }

  static List<Map<String, dynamic>> getRecommendationsForHumidity() {
    List<String> texts = [];
    double value = Values.average;

    if (value < 31.0) {
      texts.add('Low humidity can cause dry skin, eyes, and respiratory passages. Use moisturizers and stay hydrated.');
      texts.add('Outdoor activities are generally safe, but protect your skin from dryness.');
      texts.add('Use a humidifier indoors to maintain comfort and prevent static electricity buildup.');
      texts.add('Allergy sufferers may experience relief from reduced mold and dust mites.');
    } else if (value < 71.0) {
      texts.add('Humidity is within the ideal range for most individuals. Maintain hydration for overall health.');
      texts.add('Outdoor activities are perfectly safe and enjoyable.');
      texts.add('Indoor air is comfortable. No additional measures are needed.');
      texts.add('Allergy sufferers are unlikely to experience significant symptoms.');
    } else {
      texts.add('High humidity can worsen respiratory issues and promote mold growth. Ventilate indoor spaces properly.');
      texts.add('Limit outdoor activities, especially if combined with high temperatures.');
      texts.add('Use a dehumidifier or air conditioning indoors to reduce humidity levels.');
      texts.add('Allergy sufferers should minimize exposure, as mold and dust mites thrive in high humidity.');
    }

    return [
      {'icon': FontAwesomeIcons.heartPulse, 'text': texts[0]},          // health-sensitive groups
      {'icon': FontAwesomeIcons.cloudSunRain, 'text': texts[1]},        // outdoor activities
      {'icon': FontAwesomeIcons.houseChimney, 'text': texts[2]},        // indoor recommendations
      {'icon': FontAwesomeIcons.allergies, 'text': texts[3]},           // allergies
    ];
  }

  static List<Map<String, dynamic>> getRecommendationsForPressure() {
    List<String> texts = [];
    double value = Values.average;

    if (value < 801.0) {
      texts.add('Low pressure may cause mild discomfort in people with joint pain or sinus issues.');
      texts.add('Avoid strenuous outdoor activities and take breaks often.');
      texts.add('Maintain comfortable indoor conditions. Use a humidifier to prevent dryness caused by pressure fluctuations.');
      texts.add('Low pressure may lead to fatigue or mood swings. Stay hydrated and rest if needed.');
    } else if (value < 901.0) {
      texts.add('Low pressure may cause mild discomfort in people with joint pain or sinus issues.');
      texts.add('Outdoor activities are fine with precautions.');
      texts.add('Ensure comfortable indoor conditions. Set up soft lighting and relaxing scents.');
      texts.add('Low pressure may cause headaches or fatigue. Take breaks if needed.');
    } else if (value < 951.0) {
      texts.add('Low pressure may affect heart-sensitive individuals or those prone to sinus issues.');
      texts.add('Outdoor activities are generally safe.');
      texts.add('Ensure comfortable indoor conditions. Ensure adequate ventilation for fresh air.');
      texts.add('Minor mood swings or headaches may occur. Relaxation and hydration can help.');
    } else if (value < 1001.0) {
      texts.add('Pressure is suitable for most individuals, but heart-sensitive groups should take precautions.');
      texts.add('Outdoor activities are generally safe and enjoyable.');
      texts.add('No special indoor considerations are needed.');
      texts.add('Mood stability is likely, but stay hydrated and rest to prevent fatigue.');
    } else if (value < 1051.0) {
      texts.add('Pressure is ideal for most individuals.');
      texts.add('Outdoor activities are completely safe and enjoyable.');
      texts.add('No special indoor considerations are needed.');
      texts.add('Mental well-being is optimal under stable pressure conditions.');
    } else {
      texts.add('High pressure may cause discomfort for people with sinus issues or hypertension.');
      texts.add('Limit strenuous outdoor activities during sudden pressure changes.');
      texts.add('Ensure proper ventilation indoors, especially if feeling discomfort.');
      texts.add('High pressure may lead to irritability or headaches. Relaxation techniques can help.');
    }

    return [
      {'icon': FontAwesomeIcons.heartPulse, 'text': texts[0]},          // health-sensitive groups
      {'icon': FontAwesomeIcons.cloudSunRain, 'text': texts[1]},        // outdoor activities
      {'icon': FontAwesomeIcons.houseChimney, 'text': texts[2]},        // indoor recommendations
      {'icon': FontAwesomeIcons.brain, 'text': texts[3]},               // mental well-being
    ];
  }

  static List<Map<String, dynamic>> getRecommendationsForNoise() {
    List<String> texts = [];
    double value = Values.average;

    if (value < 31.0) {
      texts.add('Very quiet environment, perfect for relaxation and concentration.');
      texts.add('Outdoor activities are enjoyable with no noise-related concerns.');
      texts.add('No specific indoor adjustments needed, ideal for quiet tasks.');
      texts.add('No ear protection needed.');
    } else if (value < 46.0) {
      texts.add('Mild noise may disturb sensitive sleepers or those with anxiety.');
      texts.add('Outdoor activities are generally safe, but choose less noisy areas.');
      texts.add('Indoors, consider light noise masking with white noise machines.');
      texts.add('Earplugs may be helpful for light sleepers or sensitive individuals.');
    } else if (value < 61.0) {
      texts.add('Moderate noise can affect focus and relaxation for some individuals.');
      texts.add('Avoid prolonged outdoor exposure in noisy environments.');
      texts.add('Indoors, use soundproofing measures or noise-cancelling devices.');
      texts.add('Noise-cancelling headphones or earplugs can improve comfort.');
    } else if (value < 76.0) {
      texts.add('High noise levels may cause stress and fatigue over time.');
      texts.add('Limit outdoor activities in areas with sustained noise.');
      texts.add('Seek quieter indoor spaces for relaxation and recovery from noise exposure.');
      texts.add('Prolonged exposure can lead to hearing damage. Use earplugs or earmuffs.');
    } else if (value < 91.0) {
      texts.add('Very high noise can cause discomfort and stress in most individuals.');
      texts.add('Avoid outdoor activities near loud sources like construction or concerts.');
      texts.add('Indoors, close windows and doors to reduce noise intrusion. Use noise-cancelling devices');
      texts.add('Extended exposure risks permanent hearing loss. Wear protective gear.');
    } else {
      texts.add('Extremely high noise is dangerous and can cause immediate discomfort.');
      texts.add('Avoid all outdoor activities in noisy areas to prevent harm.');
      texts.add('Stay indoors and use noise barriers or soundproofed rooms.');
      texts.add('Hearing protection is essential. Use high-grade earplugs or earmuffs.');
    }

    return [
      {'icon': FontAwesomeIcons.solidMoon, 'text': texts[0]},           // sleep/health
      {'icon': FontAwesomeIcons.cloudSunRain, 'text': texts[1]},        // outdoor activities
      {'icon': FontAwesomeIcons.houseChimney, 'text': texts[2]},        // indoor recommendations
      {'icon': FontAwesomeIcons.earDeaf, 'text': texts[3]},             // ear protection
    ];
  }

}
