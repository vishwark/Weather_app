class SearchCityData {
  final String name;
  final String state;
  final String countryCode;
  final double latitude;
  final double longitude;

  SearchCityData({
    required this.name,
    required this.state,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  factory SearchCityData.fromJson(Map<String, dynamic> json) {
    return SearchCityData(
      name: json['name'] ?? 'NA',
      countryCode: json['country'] ?? 'NA',
      latitude: json['lat'] ?? 0.0,
      longitude: json['lon'] ?? 0.0,
      state: json['state'] ?? '',
    );
  }
}
