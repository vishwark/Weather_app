import 'package:flutter/material.dart';

class AirQualityModel {
  final double aqi;
  final double longitude;
  final double latitude;
  final double co;
  final double no;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final double nh3;
  final DateTime timeStamp;
  late final Color colorIndicator;
  late final String tagLine;

  AirQualityModel({
    required this.aqi,
    required this.longitude,
    required this.latitude,
    required this.co,
    required this.no,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
    required this.timeStamp,
  }) {
    colorIndicator = getColorFromAqi(aqi.toInt());
    tagLine = getLabelBasedOnAqi(aqi.toInt());
  }

  Color getColorFromAqi(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green; // Safe
      case 2:
        return Colors.lightGreen; // Moderate
      case 3:
        return Colors.yellow; // Unhealthy for sensitive groups
      case 4:
        return Colors.orange; // Unhealthy
      case 5:
        return Colors.red; // Very unhealthy
      default:
        return Colors.grey; // Default color or error state
    }
  }

  String getLabelBasedOnAqi(int aqi) {
    switch (aqi) {
      case 1:
        return 'Air quality is good. A perfect day for a walk!'; // Safe
      case 2:
        return 'Air quality is moderate. Enjoy outdoor activities with ease.'; // Moderate
      case 3:
        return 'Air quality is suitable for most, but sensitive groups may be affected.'; // Unhealthy for sensitive groups
      case 4:
        return 'Air quality is unhealthy. Consider reducing prolonged outdoor exertion.'; // Unhealthy
      case 5:
        return 'Air quality is very unhealthy. Minimize outdoor activities and stay indoors.'; // Very unhealthy
      default:
        return 'Get some fresh air ; )'; // Default
    }
  }

  factory AirQualityModel.fromJson(Map<String, dynamic> json) {
    var list = json['list'][0];
    var main = list['main'];
    var components = list['components'];

    return AirQualityModel(
      aqi: main['aqi'].toDouble(),
      longitude: json['coord']['lon'].toDouble(),
      latitude: json['coord']['lat'].toDouble(),
      co: components['co'].toDouble(),
      no: components['no'].toDouble(),
      o3: components['o3'].toDouble(),
      so2: components['so2'].toDouble(),
      pm2_5: components['pm2_5'].toDouble(),
      pm10: components['pm10'].toDouble(),
      nh3: components['nh3'].toDouble(),
      timeStamp: DateTime.fromMillisecondsSinceEpoch(list['dt'] * 1000),
    );
  }
}
