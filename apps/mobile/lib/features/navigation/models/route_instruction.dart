class RouteInstruction {
  final String text;
  final double distance;
  final int time;
  final int sign;
  final int? pointIndex;
  final double? distanceFromStart;

  const RouteInstruction({
    required this.text,
    required this.distance,
    required this.time,
    required this.sign,
    this.pointIndex,
    this.distanceFromStart,
  });

  factory RouteInstruction.fromJson(Map<String, dynamic> json) {
    return RouteInstruction(
      text: json['text'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      time: json['time'] ?? 0,
      sign: json['sign'] ?? 0,
      pointIndex: (json['pointIndex'] as num?)?.toInt(),
      distanceFromStart:
          (json['distanceFromStart'] as num?)?.toDouble(),
    );
  }
}
