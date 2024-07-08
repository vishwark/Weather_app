import 'package:intl/intl.dart';

class WeatherData {
  final String coordLon;
  final String coordLat;
  final int weatherId;
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final String base;
  final String mainTemp;
  final String mainFeelsLike;
  final String mainTempMin;
  final String mainTempMax;
  final int mainPressure;
  final int mainHumidity;
  final int mainSeaLevel;
  final int mainGrndLevel;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final int cloudsAll;
  final String publishedAt;
  final int sysType;
  final int sysId;
  final String sysCountry;
  final String sysSunrise;
  final String sysSunset;
  final int timezone;
  final int id;
  final String name;
  final int cod;
  final double windGust;

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
    required this.publishedAt,
    required this.sysType,
    required this.sysId,
    required this.sysCountry,
    required this.sysSunrise,
    required this.sysSunset,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod,
    required this.windGust,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final DateFormat formatter = DateFormat('HH:mm a');
    var weatherList = json['weather'] as List;
    var weather = weatherList[0];

    return WeatherData(
      coordLon: json['coord']['lon'].toString(),
      coordLat: json['coord']['lat'].toString(),
      weatherId: weather['id'] ?? 0,
      weatherMain: weather['main'] ?? '',
      weatherDescription: weather['description'] ?? '',
      weatherIcon: 'https://openweathermap.org/img/wn/${weather['icon']}.png',
      base: json['base'] ?? '',
      mainTemp:
          '${((json['main']['temp'] ?? 0).toDouble() - 273.15).toStringAsFixed(1)}°C',
      mainFeelsLike:
          '${((json['main']['feels_like'] ?? 0).toDouble() - 273.15).toStringAsFixed(1)}°C',
      mainTempMin:
          '${((json['main']['temp_min'] ?? 0).toDouble() - 273.15).toStringAsFixed(1)}°C',
      mainTempMax:
          '${((json['main']['temp_max'] ?? 0).toDouble() - 273.15).toStringAsFixed(1)}°C',
      mainPressure: json['main']['pressure'] ?? 0,
      mainHumidity: json['main']['humidity'] ?? 0,
      mainSeaLevel: json['main']['sea_level'] ?? 0,
      mainGrndLevel: json['main']['grnd_level'] ?? 0,
      visibility: json['visibility'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      windDeg: json['wind']['deg'] ?? 0,
      windGust: json['wind']['gust'] ?? 0,
      cloudsAll: json['clouds']['all'] ?? 0,
      publishedAt: formatter.format(
          DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000)),
      sysType: json['sys']['type'] ?? 0,
      sysId: json['sys']['id'] ?? 0,
      sysCountry: json['sys']['country'] ?? '',
      sysSunrise: formatter.format(DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunrise'] ?? 0) * 1000)),
      sysSunset: formatter.format(DateTime.fromMillisecondsSinceEpoch(
          (json['sys']['sunset'] ?? 0) * 1000)),
      timezone: json['timezone'] ?? 0,
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      cod: json['cod'] ?? 0,
    );
  }
}
