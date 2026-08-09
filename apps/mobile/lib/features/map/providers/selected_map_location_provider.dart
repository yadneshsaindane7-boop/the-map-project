import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class SelectedMapLocationNotifier extends Notifier<LatLng?> {
  @override
  LatLng? build() {
    return null;
  }

  void selectLocation({
    required double latitude,
    required double longitude,
  }) {
    state = LatLng(latitude, longitude);
  }

  void clearLocation() {
    state = null;
  }
}

final selectedMapLocationProvider =
    NotifierProvider<SelectedMapLocationNotifier, LatLng?>(
  SelectedMapLocationNotifier.new,
);