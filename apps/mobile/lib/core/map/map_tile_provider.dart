import 'map_styles.dart';

class MapTileProvider {
  MapTileProvider._();

  // TODO:
  // Move this to .env after MVP is complete.
  static const String apiKey = 'lWrQRg8ZjN0FOwwLBhy2';

  static String getTileUrl(MapStyle style) {
    return 'https://api.maptiler.com/maps/${style.styleId}/{z}/{x}/{y}.png?key=$apiKey';
  }
}