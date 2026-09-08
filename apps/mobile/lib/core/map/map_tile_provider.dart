import '../constants/app_constants.dart';
import 'map_styles.dart';

class MapTileProvider {
  MapTileProvider._();

  static String getTileUrl(MapStyle style) {
    return 'https://api.maptiler.com/maps/'
        '${style.styleId}/{z}/{x}/{y}.png'
        '?key=${AppConstants.mapTilerApiKey}';
  }
}