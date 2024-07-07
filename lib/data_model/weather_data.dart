class WeatherData {
  final String coordLon;
  final String coordLat;
  final int weatherId;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final String base;
  final double mainTemp;
  final double mainFeelsLike;
  final double mainTempMin;
  final double mainTempMax;
  final int mainPressure;
  final int mainHumidity;
  final int mainSeaLevel;
  final int mainGrndLevel;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final int cloudsAll;
  final DateTime dateTime;
  final int sysType;
  final int sysId;
  final String sysCountry;
  final DateTime sysSunrise;
  final DateTime sysSunset;
  final int timezone;
  final int id;
  final String name;
  final int cod;

  WeatherData({
    required this.coordLon,
    required this.coordLat,
    required this.weatherId,
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.base,
    required this.mainTemp,
    required this.mainFeelsLike,
    required this.mainTempMin,
    required this.mainTempMax,
    required this.mainPressure,
    required this.mainHumidity,
    required this.mainSeaLevel,
    required this.mainGrndLevel,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.cloudsAll,
    required this.dateTime,
    required this.sysType,
    required this.sysId,
    required this.sysCountry,
    required this.sysSunrise,
    required this.sysSunset,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    var weatherList = json['weather'] as List;
    var weather = weatherList[0];
    print("111111111111111-----2");
    print(json['name']);
    // Debugging prints
    print('Received JSON: $json');
    print('Name field: ${json['name']}');
    return WeatherData(
      coordLon: json['coord']['lon'].toString(),
      coordLat: json['coord']['lat'].toString(),
      weatherId: weather['id'] ?? 0,
      weatherMain: weather['main'] ?? '',
      weatherDescription: weather['description'] ?? '',
      weatherIcon: weather['icon'] ?? '',
      base: json['base'] ?? '',
      mainTemp: (json['main']['temp'] ?? 0).toDouble(),
      mainFeelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      mainTempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      mainTempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      mainPressure: json['main']['pressure'] ?? 0,
      mainHumidity: json['main']['humidity'] ?? 0,
      mainSeaLevel: json['main']['sea_level'] ?? 0,
      mainGrndLevel: json['main']['grnd_level'] ?? 0,
      visibility: json['visibility'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      windDeg: json['wind']['deg'] ?? 0,
      cloudsAll: json['clouds']['all'] ?? 0,
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      sysType: json['sys']['type'] ?? 0,
      sysId: json['sys']['id'] ?? 0,
      sysCountry: json['sys']['country'] ?? '',
      sysSunrise: DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunrise'] ?? 0) * 1000),
      sysSunset: DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunset'] ?? 0) * 1000),
      timezone: json['timezone'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      cod: json['cod'] ?? 0,
    );
  }
}
