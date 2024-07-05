import 'package:go_router/go_router.dart';
import 'package:weather_app/pages/add-city.dart';
import 'package:weather_app/pages/air_pollution.dart';
import 'package:weather_app/pages/dashboard.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/add-city',
  routes: [
    GoRoute(
      path: '/add-city',
      name: 'add-city',
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
