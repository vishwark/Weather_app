import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/business_layer/bloc/geoLocation/location_bloc.dart';
import 'package:weather_app/presentation_layer/pages/add-city.dart';
import 'package:weather_app/presentation_layer/pages/air_quality.dart';
import 'package:weather_app/presentation_layer/pages/dashboard.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/add-city',
      name: 'add-city',
      // builder: (context, state) => MultiBlocProvider(
      //   providers: [
      //     BlocProvider<LocationBloc>(
      //       create: (context)=> LocationBloc()
      //     )
      //   ],
      //   child: AddCity()
      // ),
      builder: (context, state) => AddCity(),
    ),
    GoRoute(
      path: '/air-quality',
      name: 'air-quality',
      builder: (context, state) {
        final Map<String, String> queryParams =
            GoRouterState.of(context).uri.queryParameters;
        final latitude = double.parse(queryParams['latitude'] ?? '14.6192362');
        final longitude =
            double.parse(queryParams['longitude'] ?? '14.6192362');
        return AirQualityScreen(longitude: longitude, latitude: latitude);
      },
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => Favorites(),
    ),
  ],
);
