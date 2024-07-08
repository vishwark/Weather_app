// import 'package:location/location.dart';

// class GeolocationUtility {
//   Future<LocationData?> getLocation() async {
//     Location location = new Location();
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//     LocationData currentPosition;

//     serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) {
//         //if location service not enabled show proper msg
//         return null;
//       }
//     }

//     permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         //if app permission not given location show proper msg
//         return null;
//       }
//     }

//     currentPosition = await location.getLocation();
//     //location service enabled and location permission given return Location data
//     return currentPosition;
//   }
// }
