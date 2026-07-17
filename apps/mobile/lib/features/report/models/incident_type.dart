enum IncidentType {
  roadClosed(
    value: 'road_closed',
    label: 'Road Closed',
  ),

  accident(
    value: 'accident',
    label: 'Accident',
  ),

  construction(
    value: 'construction',
    label: 'Construction',
  ),

  flooding(
    value: 'flooding',
    label: 'Flooding',
  ),

  trafficJam(
    value: 'traffic_jam',
    label: 'Traffic Jam',
  ),

  pothole(
    value: 'pothole',
    label: 'Pothole',
  ),

  event(
    value: 'event',
    label: 'Public Event',
  ),

  other(
    value: 'other',
    label: 'Other',
  );

  final String value;
  final String label;

  const IncidentType({
    required this.value,
    required this.label,
  });

  static IncidentType fromValue(String value) {
    return IncidentType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => IncidentType.other,
    );
  }
}