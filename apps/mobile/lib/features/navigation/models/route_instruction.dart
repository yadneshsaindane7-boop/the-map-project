class RouteInstruction {
  final String text;
  final double distance;
  final int time;
  final int sign;

  const RouteInstruction({
    required this.text,
    required this.distance,
    required this.time,
    required this.sign,
  });

  factory RouteInstruction.fromJson(Map<String, dynamic> json) {
    return RouteInstruction(
      text: json['text'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0,
      time: json['time'] ?? 0,
      sign: json['sign'] ?? 0,
    );
  }
}