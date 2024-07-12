import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/data_layer/data_model/gio_coordinates.dart';

class CityPreferences {
  static const String key = 'favorite_cities';

  Future<List<CityGioOrdinates>?> addCity(CityGioOrdinates city) async {
    List<CityGioOrdinates> cities = await loadCities();
    if (cities.contains(city)) {
      return null; // show snackbar based on return value
    }

    cities.insert(0, city);
    return await saveCities(cities);
  }

  Future<List<CityGioOrdinates>> deleteCity(CityGioOrdinates city) async {
    List<CityGioOrdinates> cities = await loadCities();
    cities.remove(city);
    return await saveCities(cities);
  }

  Future<List<CityGioOrdinates>> saveCities(
      List<CityGioOrdinates> cities) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cityList =
        cities.map((city) => jsonEncode(city.toJson())).toList();
    await prefs.setStringList(key, cityList);
    return cities;
  }

  Future<List<CityGioOrdinates>> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cityList = prefs.getStringList(key);
    if (cityList == null) {
      return [];
    } else {
      return cityList
          .map(
              (cityString) => CityGioOrdinates.fromJson(jsonDecode(cityString)))
          .toList();
    }
  }
}
