import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/business_layer/bloc/favorites/favorites_bloc.dart';
import 'package:weather_app/data_layer/data_model/weather_data.dart';

import 'package:weather_app/presentation_layer/widgets/weather.dart';

class Favorites extends StatefulWidget {
  @override
  FavotiesState createState() => FavotiesState();
}

class FavotiesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
  }

  int _activePage = 0;
  int noOfCities = 0;
  void _setActivePage(int page) {
    setState(() {
      _activePage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (BuildContext context, FavoritesState state) {
        if (state is FavoritesStateLoaded) {
          noOfCities = state.favoritesStateData.length;
        }
        if (state is FavoritesStateAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Your city has been added successfully!',
              ),
            ),
          );
        } else if (state is FavoritesStateDuplicateEntry) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'City already exist in dashboard!',
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
        } else if (state is FavoritesStateEmpty) {
          return context.go("/add-city");
        }
      },
      builder: (BuildContext context, FavoritesState state) {
        return Scaffold(
          body: _buildContent(state),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (noOfCities > 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You can add only 5 cities to dashboard!"),
                  ),
                );
              } else {
                context.pushNamed("add-city");
              }
            },
            elevation: 10,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildContent(FavoritesState state) {
    if (state is FavoritesStateLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is FavoritesStateLoaded) {
      return OnLoadWidget(
        activePage: _activePage,
        setActivePage: _setActivePage,
        weatherData: state.favoritesStateData,
      );
    } else {
      return Center(child: const Text("Failed to load data!"));
    }
  }
}

class OnLoadWidget extends StatefulWidget {
  final int activePage;
  final ValueChanged<int> setActivePage;
  final List<WeatherData> weatherData;

  OnLoadWidget({
    required this.activePage,
    required this.setActivePage,
    required this.weatherData,
  });

  @override
  State<OnLoadWidget> createState() => _OnLoadWidgetState();
}

class _OnLoadWidgetState extends State<OnLoadWidget> {
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      if (_pageController.page == widget.weatherData.length - 1) {
        _pageController.animateToPage(0,
            duration: Duration(milliseconds: 300), curve: Curves.bounceOut);
      } else {
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // startTimer();
  }

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: widget.weatherData.length,
                  itemBuilder: (context, index) {
                    return WeatherPage(weatherData: widget.weatherData[index]);
                    //(weatherData: weatherData[index]);
                  },
                  controller: _pageController,
                  onPageChanged: (value) {
                    widget.setActivePage(value);
                  },
                ),
                if (widget.weatherData.length > 1)
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                            widget.weatherData.length,
                            (index) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: InkWell(
                                    onTap: () {
                                      _pageController.animateToPage(index,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeIn);
                                    },
                                    child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor:
                                          widget.activePage == index
                                              ? Colors.green
                                              : Colors.grey,
                                    ),
                                  ),
                                )),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
