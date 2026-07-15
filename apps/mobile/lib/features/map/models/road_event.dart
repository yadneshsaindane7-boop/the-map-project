class RoadEvent {
  final String id;
  final String title;
  final String description;
  final String status;
  final double latitude;
  final double longitude;

  const RoadEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  factory RoadEvent.fromJson(Map<String, dynamic> json) {
    return RoadEvent(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      status: json['status'].toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}