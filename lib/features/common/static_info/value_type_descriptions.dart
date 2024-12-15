import '../utils/values.dart';

class Descriptions {
  static String get() {
    return switch(Values.valueType){
      "pm10" => "Pm-10 is an air particle with a diameter of 10 microns or less. It is inhalable into the lungs, so it can induce adverse health effects such as respiratory issues and aggravated cardiovascular conditions.",
      "pm25" => "Pm-2.5 is an air particle with a diameter of 2.5 microns or less. Breathing it in can increase the risk of health problems such as heart disease, asthma, respiratory infections, and low birth weight for babies.",
      "temperature" => "Temperature refers to the warmth or coldness of the air. Extreme temperatures, whether too hot or too cold, can affect human health, cause heat stress, or increase the risk of hypothermia.",
      "humidity" => "Humidity is the concentration of water vapor in the air. High levels of it can trigger bronchoconstriction - narrowing of airways, which may worsen symptoms like asthma and other respiratory issues.",
      "pressure" => "Pressure is the force exerted by air molecules on a unit area of the Earth's surface. Changes in it can make blood vessels expand, causing discomfort or pain for individuals with medical conditions.",
      _ => "Noise refers to unwanted sound. Prolonged exposure to loud or continuous noise can result in hearing loss, increased stress, sleep disturbances, and negative impacts on overall well-being.",
    };
  }
}
