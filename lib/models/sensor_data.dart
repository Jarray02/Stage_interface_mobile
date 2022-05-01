class SensorData {
  final double humidite;
  final double temperature;
  final double pression;
  final String profile;

  SensorData(
      {required this.humidite,
      required this.pression,
      required this.profile,
      required this.temperature});

  factory SensorData.fromRTDB(Map<String, dynamic> data) {
    return SensorData(
        humidite: data['humidite'],
        pression: data['pression'],
        profile: data['profile'],
        temperature: data['temperature']);
  }

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
        humidite: json['humidite'],
        temperature: json['temperature'],
        pression: json['pression'],
        profile: json['profile']);
  }
}
