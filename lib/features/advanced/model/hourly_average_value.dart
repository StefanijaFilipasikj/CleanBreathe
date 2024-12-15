class HourlyAverageValue {
  final DateTime timestamp;
  final double value;

  HourlyAverageValue({required this.timestamp, required this.value});

  factory HourlyAverageValue.fromJson(Map<String, dynamic> json) {
    DateTime timestamp = DateTime.parse(json['stamp']);
    double value = double.parse(json['value']);
    return HourlyAverageValue(timestamp: timestamp, value: value);
  }
}
