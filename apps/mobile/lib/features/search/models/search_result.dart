class SearchResult {
  final String displayName;
  final double latitude;
  final double longitude;

  /// photon / nominatim
  final String source;

  const SearchResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
    this.source = '',
  });

  SearchResult copyWith({
    String? displayName,
    double? latitude,
    double? longitude,
    String? source,
  }) {
    return SearchResult(
      displayName: displayName ?? this.displayName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      source: source ?? this.source,
    );
  }

  factory SearchResult.fromJson(
    Map<String, dynamic> json, {
    String source = 'nominatim',
  }) {
    return SearchResult(
      displayName: json['display_name'] ?? '',
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
      source: source,
    );
  }
}