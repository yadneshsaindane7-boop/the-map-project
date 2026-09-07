class PendingReport {
  const PendingReport({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.userId,
    required this.eventTypeId,
    required this.eventTypeName,
    required this.osmWayId,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final String? userId;
  final String eventTypeId;
  final String eventTypeName;
  final int? osmWayId;

  factory PendingReport.fromMap(Map<String, dynamic> map) {
    final osmWayIdValue = map['osm_way_id'];

    final eventTypeId = map['event_type_id'] as String;

    final eventTypeName =
        (map['event_type'] as String?) ?? eventTypeId;

    return PendingReport(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      status: map['status'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
      userId: (map['user_id'] ?? map['reported_by']) as String?,
      eventTypeId: eventTypeId,
      eventTypeName: eventTypeName,
      osmWayId: osmWayIdValue == null
          ? null
          : osmWayIdValue is num
              ? osmWayIdValue.toInt()
              : int.parse(osmWayIdValue.toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'event_type_id': eventTypeId,
      'event_type': eventTypeName,
      'osm_way_id': osmWayId,
    };
  }

  PendingReport copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    String? userId,
    String? eventTypeId,
    String? eventTypeName,
    int? osmWayId,
  }) {
    return PendingReport(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      eventTypeName: eventTypeName ?? this.eventTypeName,
      osmWayId: osmWayId ?? this.osmWayId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingReport &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}