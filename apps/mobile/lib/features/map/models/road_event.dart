import 'package:flutter/foundation.dart';

@immutable
class RoadEvent {
  final String id;
  final String title;
  final String description;
  final String status;

  final String? eventTypeId;
  final String? eventType;
  final int? osmWayId;

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
    this.eventTypeId,
    this.eventType,
    this.osmWayId,
    this.createdAt,
    this.reportedBy,
    this.imageUrl,
  });

  bool get isRoadClosure {
    return eventType?.trim().toLowerCase() ==
        'road closure';
  }

  bool get isActive {
    final normalizedStatus =
        status.trim().toLowerCase();

    return normalizedStatus == 'pending' ||
        normalizedStatus == 'approved' ||
        normalizedStatus == 'active';
  }

  bool get shouldAvoid {
    return isRoadClosure && isActive;
  }

  factory RoadEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    return RoadEvent(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      description:
          (json['description'] ?? '') as String,
      status: json['status'].toString(),

      eventTypeId:
          json['event_type_id'] as String?,

      eventType:
          json['event_type'] as String?,

      osmWayId:
          (json['osm_way_id'] as num?)?.toInt(),

      latitude:
          (json['latitude'] as num).toDouble(),

      longitude:
          (json['longitude'] as num).toDouble(),

      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(
              json['created_at'] as String,
            ),

      reportedBy:
          json['reported_by'] as String?,

      imageUrl:
          json['image_url'] as String?,
    );
  }
}