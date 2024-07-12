import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/business_layer/bloc/favorites/favorites_bloc.dart';
import 'package:weather_app/data_layer/data_model/gio_coordinates.dart';
import 'package:weather_app/data_layer/data_model/weather_data.dart';
import 'package:weather_app/presentation_layer/widgets/commons/info_row.dart';
import 'package:weather_app/presentation_layer/widgets/weather-comp/temperature.dart';
import 'package:weather_app/presentation_layer/widgets/weather-comp/wind_speed.dart';

class WeatherPage extends StatelessWidget {
  WeatherData weatherData;

  final ScrollController _scrollController = ScrollController();

  WeatherPage({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      Future.delayed(Duration.zero, () {
        BlocProvider.of<FavoritesBloc>(context).add(reFetchFavotires());
      });
    }

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
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(weatherData.weatherIcon),
                          Text(
                            "${weatherData.mainTemp}",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        "published at :${weatherData.publishedAt}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${weatherData.weatherDescription}",
                        style: TextStyle(fontSize: 20),
                      ),
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
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  WindCompass(
                    direction: weatherData.windDeg.toDouble(),
                    speed: weatherData.windSpeed,
                    gust: weatherData.windGust,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/sunrise.svg',
                                width: 100,
                                height: 50,
                              ),
                              InfoRow(
                                  value: '${weatherData.sysSunrise}',
                                  label: "Sunrise"),
                              SizedBox(height: 18),
                              Divider(),
                              SizedBox(height: 18),
                              SvgPicture.asset(
                                'assets/sunset.svg',
                                width: 100,
                                height: 50,
                              ),
                              InfoRow(
                                  value: '${weatherData.sysSunset}',
                                  label: "sunset"),
                            ],
                          ),
                        ),
                        Container(
                          width: 200,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              InfoRow(
                                  value: '${weatherData.mainHumidity}',
                                  label: "Humidity"),
                              Divider(),
                              InfoRow(
                                  value: '${weatherData.mainPressure}',
                                  label: "Pressure"),
                              Divider(),
                              InfoRow(
                                  value: '${weatherData.visibility}',
                                  label: "Visibility"),
                              Divider(),
                              InfoRow(
                                  value: '${weatherData.mainSeaLevel}',
                                  label: "Sea level"),
                              Divider(),
                              InfoRow(
                                  value: '${weatherData.mainGrndLevel}',
                                  label: "Ground level"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Temperature(
                        tempMin: weatherData.mainTempMin,
                        tempAvg: weatherData.mainFeelsLike,
                        tempMax: weatherData.mainTempMax),
                  ),
                  SizedBox(height: 8),
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
