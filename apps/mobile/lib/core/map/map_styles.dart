enum MapStyle {
  streets,
  terrain,
  satellite,
}

extension MapStyleExtension on MapStyle {
  String get displayName {
    switch (this) {
      case MapStyle.streets:
        return 'Streets';

      case MapStyle.terrain:
        return 'Terrain';

      case MapStyle.satellite:
        return 'Satellite';
    }
  }

  String get styleId {
    switch (this) {
      case MapStyle.streets:
        return 'streets-v2';

      case MapStyle.terrain:
        return 'outdoor-v2';

      case MapStyle.satellite:
        return 'satellite';
    }
  }
}