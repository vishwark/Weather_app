import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/data_layer/data_model/air_pollution_param.dart';
import 'package:weather_app/data_layer/data_model/gio_coordinates.dart';
import 'package:weather_app/data_layer/data_model/search_city_data.dart';
import 'package:weather_app/data_layer/data_model/weather_data.dart';

class WeatherAPI {
  final apiKey = '63771725444d583752367b19b2fc5cc2';

  Future<List<dynamic>> searchCity(String city) async {
    try {
      final url =
          'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=10&appid=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data.map((city) => SearchCityData.fromJson(city)).toList();
      } else {
        print('Failed to search city!');
        return [];
      }
    } catch (e) {
      print('Failed to search city : $e');
      return [];
    }
  }

  Future<WeatherData?> fetchWeatherData(double lat, double lon) async {
    try {
      final url =
          'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        print('Failed to fetch weather data');
        return null;
      }
    } catch (e) {
      print('Failed to fetch weather data : $e');
      return null;
    }
  }

  Future<AirQualityModel?> getAQIdata(double lon, double lat) async {
    try {
      final url =
          'http://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AirQualityModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Failed to load AQI data : $e');
    }
  }

  Future<List<WeatherData>> fetchFavoritesWeatherData(
      List<CityGioOrdinates> cities) async {
    try {
      List<Future<WeatherData?>> weatherFutures = cities.map((city) {
        return fetchWeatherData(city.latitude, city.longitude);
      }).toList();
      // List<WeatherData> results =
      //     await Future.wait(weatherFutures as Iterable<Future<WeatherData>>);
      // return results;

      List<WeatherData?> weatherDataList = await Future.wait(weatherFutures);
      // Filter out null values (if any)
      List<WeatherData> validWeatherDataList = weatherDataList
          .where((weatherData) => weatherData != null)
          .cast<WeatherData>()
          .toList();
      return validWeatherDataList;
    } catch (e) {
      print("Error fetching weather data: $e");
      return [];
    }
  }
}
