import 'package:flutter/foundation.dart';

@immutable
class RoadEvent {
  final String id;
  final String title;
  final String description;
  final String status;

  final double latitude;
  final double longitude;

  final DateTime? createdAt;
  final String? reportedBy;
  final String? imageUrl;

  const RoadEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.createdAt,
    this.reportedBy,
    this.imageUrl,
  });

  factory RoadEvent.fromJson(Map<String, dynamic> json) {
    return RoadEvent(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      status: json['status'].toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
      reportedBy: json['reported_by'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }
}