class SearchResult {
  final String displayName;
  final double latitude;
  final double longitude;

  const SearchResult({
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      displayName: json['display_name'] ?? '',
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
    );
  }
}