// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class SensorData {
  final num humidite;
  final num temperature;
  final num pression;
  final String profile;
  SensorData({
    required this.humidite,
    required this.temperature,
    required this.pression,
    required this.profile,
  });

  SensorData copyWith({
    double? humidite,
    double? temperature,
    double? pression,
    String? profile,
  }) {
    return SensorData(
      humidite: humidite ?? this.humidite,
      temperature: temperature ?? this.temperature,
      pression: pression ?? this.pression,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'humidite': humidite,
      'temperature': temperature,
      'pression': pression,
      'currentProfile': profile,
    };
  }

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      humidite: map['humidite'] as num,
      temperature: map['temperature'] as num,
      pression: map['pression'] as num,
      profile: map['currentProfile'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorData.fromJson(DatabaseReference source) => SensorData.fromMap(
      json.decode(source.toString()) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SensorData(humidite: $humidite, temperature: $temperature, pression: $pression, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SensorData &&
        other.humidite == humidite &&
        other.temperature == temperature &&
        other.pression == pression &&
        other.profile == profile;
  }

  @override
  int get hashCode {
    return humidite.hashCode ^
        temperature.hashCode ^
        pression.hashCode ^
        profile.hashCode;
  }
}
