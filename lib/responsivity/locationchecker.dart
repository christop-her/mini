// import 'package:geolocator/geolocator.dart';

// class LocationProximityChecker {
//   static const double targetLatitude = 6.0976455;
//   static const double targetLongitude = 5.7929118;
//   static const double proximityRadius = 100.0; // Define proximity radius in meters

//   bool _isInProximity = false; // To track if already in proximity

//   void startListening() {
    
//     // Check for location permissions and start listening
//     Geolocator.checkPermission().then((permission) {
//       if (permission == LocationPermission.denied) {
//         Geolocator.requestPermission();
//       }
//     });

//     Geolocator.getPositionStream(
//       locationSettings: LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 1, // Minimum change in distance (meters) to trigger updates
//       ),
//     ).listen((Position? position) {
      
//       if (position != null) {
//         _checkProximity(position);
//     print('Position: ${position.latitude}, ${position.longitude}');
//   } else {
//     print('No position received');
//   }
//     });
//   }

//   void _checkProximity(Position position) {
    
//     double distanceInMeters = Geolocator.distanceBetween(
//       position.longitude,
//       position.latitude,
//       targetLatitude,
//       targetLongitude,
//     );
// print('distanceInMeters $distanceInMeters');
// print('proximityRadius $proximityRadius');
//     if (distanceInMeters <= proximityRadius && !_isInProximity) {
//        print('Entered proximity: Open');
//       _isInProximity = true;
//       print('Entered proximity: Open');
//     } else if (distanceInMeters > proximityRadius && _isInProximity) {
//       print('Left proximity: Closed');
//       _isInProximity = false;
      
//     }
//   }
// }
