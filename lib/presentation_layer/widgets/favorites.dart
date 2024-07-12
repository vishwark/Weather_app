import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/business_layer/bloc/favorites/favorites_bloc.dart';
import 'package:weather_app/business_layer/bloc/weather/weather_bloc.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (BuildContext context, FavoritesState state) {
          if (state is FavoritesStateAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Your city has been added successfully!',
                ),
              ),
            );
          } else if (state is FavoritesStateDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'City deleted from dashboard!',
                ),
              ),
            );
          }
        },
        builder: (BuildContext context, FavoritesState state) {
          if (state is FavoritesStateLoading) {
            return const CircularProgressIndicator();
          } else if (state is FavoritesStateLoaded) {
            return Text('City');
          } else {
            return const Text("Failed to load data!");
          }
        },
      ),
    );
  }
}
