import 'package:flutter/foundation.dart';

@immutable
class TrafficAlert {
  final String id;
  final String title;
  final String description;
  final String status;

  final double latitude;
  final double longitude;

  final DateTime createdAt;

  const TrafficAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  factory TrafficAlert.fromJson(
    Map<String, dynamic> json,
  ) {
    return TrafficAlert(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      status: json['status'].toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(
        json['created_at'],
      ),
    );
  }
}