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
      name: json['name'],
      countryCode: json['country'],
      latitude: json['lat'],
      longitude: json['lon'],
      state: json['state'] ?? '',
    );
  }
}
