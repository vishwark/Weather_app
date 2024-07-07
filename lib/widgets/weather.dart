import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/bloc/favorites/favorites_bloc.dart';
import 'package:weather_app/data_model/gio_coordinates.dart';
import 'package:weather_app/data_model/weather_data.dart';

class WeatherPage extends StatelessWidget {
  WeatherData weatherData;
  Future<void> onRefresh() async {
    Future.delayed(Duration.zero);
  }

  final ScrollController _scrollController = ScrollController();

  WeatherPage({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            collapsedHeight: 100,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                weatherData.name,
                style: TextStyle(fontSize: 20),
              ),
              background: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${(weatherData.mainTemp - 273.15).toStringAsFixed(1)}°C",
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text("Cloudy 82/80"),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.pushNamed(
                            'air-quality',
                            queryParameters: {
                              'latitude': weatherData.coordLat,
                              'longitude': weatherData.coordLon,
                            },
                          );
                        },
                        label: const Text("AQI"),
                        icon: const Icon(Icons.air),
                      )
                    ],
                  ),
                ),
              ),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final cityCoordinates = CityGioOrdinates(
                      latitude: double.parse(weatherData.coordLat),
                      longitude: double.parse(weatherData.coordLon),
                    );
                    BlocProvider.of<FavoritesBloc>(context).add(
                      deleteFromFavorites(city: cityCoordinates),
                    );
                  },
                  label: const Text("Remove this city!"),
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: SizedBox(
                    height: 800,
                    child: Text("Hello"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
