import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/business_layer/bloc/aqi/aqi_bloc.dart';
import 'package:weather_app/business_layer/bloc/favorites/favorites_bloc.dart';
import 'package:weather_app/business_layer/bloc/geoLocation/location_bloc.dart';
import 'package:weather_app/business_layer/bloc/weather/weather_bloc.dart';
import 'package:weather_app/presentation_layer/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromARGB(255, 5, 187, 11),
        // ···
        brightness: Brightness.light,
        primary: Color.fromARGB(255, 116, 166, 51),
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor:
            Color.fromARGB(255, 122, 208, 125), // Set app bar background color
        foregroundColor: Colors.black, // Set app bar text/icon color
      ),
      fontFamily: 'Roboto', // Example font family
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<AQIBloc>(
          create: (context) => AQIBloc(),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => FavoritesBloc(),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(),
        ),
      ],
      child: MaterialApp.router(
        theme: theme,
        routerConfig: routes,
      ),
    );
  }
}
