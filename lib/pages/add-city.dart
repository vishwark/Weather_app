import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/bloc/favorites/favorites_bloc.dart';
import 'package:weather_app/data_model/gio_coordinates.dart';
import 'package:weather_app/utility/countryCodeToName.dart';
import 'package:weather_app/utility/service_calls.dart';

class AddCity extends StatefulWidget {
  const AddCity({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<AddCity> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final List<String> _cities = [
    'Locate',
    'Delhi',
    'Mumbai',
    'Jakarta',
    'Kuala Lumpur',
    'Singapore',
    'Los Angeles',
    'New York'
  ];
  var hasSearchResults = false;
  var searchCities = [];

  void searchThisCity(String city) async {
    searchCities = await WeatherAPI().searchCity(city);
    if (searchCities.isNotEmpty) {
      hasSearchResults = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text;
      if (query.isNotEmpty) {
        searchThisCity(query);
      } else {
        searchCities = [];
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search city',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: !hasSearchResults
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular cities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _cities.map((city) {
                      return GestureDetector(
                        onTap: () {
                          searchThisCity(city);
                        },
                        child: Chip(
                          label: Text(city),
                          backgroundColor: city == 'Locate'
                              ? Colors.grey[300]
                              : Colors.grey[200],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            : BlocListener<FavoritesBloc, FavoritesState>(
                listener: (context, state) {
                  if (state is FavoritesStateDuplicateEntry) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('City already exists in favorites')),
                    );
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select search city! ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: searchCities.length,
                        itemBuilder: (context, index) {
                          final city = searchCities[index];
                          return GestureDetector(
                            onTap: () {
                              final cityCoordinates = CityGioOrdinates(
                                latitude: double.parse(
                                    city.latitude.toStringAsFixed(4)),
                                longitude: double.parse(
                                    city.longitude.toStringAsFixed(4)),
                              );
                              BlocProvider.of<FavoritesBloc>(context).add(
                                saveToFavorites(city: cityCoordinates),
                              );
                              context.go('/dashboard');
                            },
                            child: Card(
                              color: const Color.fromARGB(255, 140, 189, 212),
                              child: ListTile(
                                title: Text(city.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(city.state),
                                    Text(CountryCodeHelper()
                                        .getCountryName(city.countryCode)),
                                    Text(
                                      'Latitude : ${city.latitude.toString()}',
                                    ),
                                    Text(
                                      'Longitude : ${city.longitude.toString()}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
