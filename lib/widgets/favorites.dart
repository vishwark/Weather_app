import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/favorites/favorites_bloc.dart';
import 'package:weather_app/bloc/weather/weather_bloc.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Cities'),
      ),
      body: BlocListener<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state is FavoritesStateWithNewEntry) {
            print("11111111111111---scaffold");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('New city added to favorites!')),
            );
          }
        },
        child: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            if (state is FavoritesStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoritesStateLoaded) {
              return ListView.builder(
                itemCount: state.favoritesStateData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.favoritesStateData[index].name),
                  );
                },
              );
            } else if (state is FavoritesStateError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No favorite cities'));
            }
          },
        ),
      ),
    );
  }
}
