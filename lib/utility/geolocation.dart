import 'package:geolocator/geolocator.dart';

class GeolocationUtility {
  Future<GeolocationResult> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return GeolocationResult(
          position: null, status: GeolocationStatus.disabled);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return GeolocationResult(
            position: null, status: GeolocationStatus.denied);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return GeolocationResult(
          position: null, status: GeolocationStatus.deniedForever);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return GeolocationResult(
        position: position, status: GeolocationStatus.granted);
  }
}

class GeolocationResult {
  final Position? position;
  final GeolocationStatus status;

  GeolocationResult({required this.position, required this.status});
}

enum GeolocationStatus {
  granted,
  denied,
  deniedForever,
  disabled,
}
