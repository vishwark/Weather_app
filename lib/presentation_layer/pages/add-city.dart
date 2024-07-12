import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/business_layer/bloc/favorites/favorites_bloc.dart';
import 'package:weather_app/business_layer/bloc/geoLocation/location_bloc.dart';
import 'package:weather_app/data_layer/data_model/gio_coordinates.dart';
import 'package:weather_app/utility/countryCodeToName.dart';
import 'package:weather_app/utility/geolocation.dart';
import 'package:weather_app/data_layer/api_provider.dart';

class AddCity extends StatefulWidget {
  const AddCity({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<AddCity> {
  FocusNode _focusNode = FocusNode();
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
    print("22222222222----function triggred");
    if (city == 'Locate') {
      // Position position = await GeolocationUtility().determinePosition();
      // print(position);
      // print(position.runtimeType);
      // addCityToFavorites(position.latitude, position.longitude);
      print("22222222222----adding event");
      context.read<LocationBloc>().add(GetLocation());
    } else {
      searchCities = await WeatherAPI().searchCity(city);
      if (searchCities.isNotEmpty) {
        hasSearchResults = true;
        setState(() {});
      }
    }
  }

  void setPopularCity(String city) {
    _searchController.text = city;
  }

  void addCityToFavorites(double latitude, double longitude) {
    final cityCoordinates = CityGioOrdinates(
      latitude: double.parse(latitude.toStringAsFixed(4)),
      longitude: double.parse(longitude.toStringAsFixed(4)),
    );
    BlocProvider.of<FavoritesBloc>(context).add(
      saveToFavorites(city: cityCoordinates),
    );
    context.go('/dashboard');
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    // Use addPostFrameCallback to focus after the widget has been laid out
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
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
        title: TextField(
          focusNode: _focusNode,
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
              suffixIcon: GestureDetector(
                  onTap: () {
                    _searchController.clear();
                  },
                  child: Icon(Icons.cancel, color: Colors.grey))),
        ),
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
                          setPopularCity(city);
                        },
                        child: Chip(
                          label: Text(city),
                          backgroundColor: city == 'Locate'
                              ? Colors.grey[300]
                              : Color.fromARGB(255, 168, 219, 167),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            : BlocListener<LocationBloc, LocationState>(
                listener: (context, state) {
                  print('11111111111111111111 $state');
                  if (state is FetchingLocation) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Fetching location pls wait!')),
                    );
                  } else if (state is LocationLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location loaded!')),
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
                              addCityToFavorites(city.latitude, city.longitude);
                            },
                            child: Card(
                              color: Color.fromARGB(255, 174, 233, 169),
                              child: ListTile(
                                title: Text(city.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(city.state),
                                    Text(CountryCodeHelper()
                                        .getCountryName(city.countryCode)),
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
