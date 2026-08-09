import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final liveLocationProvider = StreamProvider<Position>((ref) async* {
  final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  LocationPermission permission =
      await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission =
        await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied) {
    throw Exception('Location permission was denied.');
  }

  if (permission ==
      LocationPermission.deniedForever) {
    throw Exception(
      'Location permission is permanently denied.',
    );
  }

  const locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 5,
  );

  yield* Geolocator.getPositionStream(
    locationSettings: locationSettings,
  );
});