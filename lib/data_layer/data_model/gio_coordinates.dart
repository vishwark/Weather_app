import 'dart:convert';

class CityGioOrdinates {
  final double latitude;
  final double longitude;

  CityGioOrdinates({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  factory CityGioOrdinates.fromJson(Map<String, dynamic> json) {
    return CityGioOrdinates(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CityGioOrdinates &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
