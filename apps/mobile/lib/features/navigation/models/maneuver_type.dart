/// Represents the type of driving maneuver at a route waypoint.
///
/// Sign codes mirror the GraphHopper / custom routing convention
/// so the same enum can drive both the local A* back-end and any
/// future GraphHopper integration with zero changes in the UI layer.
enum ManeuverType {
  /// Sign 0 – road continues in roughly the same direction.
  continueStraight(sign: 0, icon: '⬆️'),

  /// Sign 1 – bear slightly to the right (< 45°).
  slightRight(sign: 1, icon: '↗️'),

  /// Sign 2 – normal right turn (45° – 135°).
  right(sign: 2, icon: '➡️'),

  /// Sign 3 – sharp right turn (135° – 165°).
  sharpRight(sign: 3, icon: '⤴️'),

  /// Sign 6 – full U-turn (165° – 195°).
  uTurn(sign: 6, icon: '↩️'),

  /// Sign -3 – sharp left turn.
  sharpLeft(sign: -3, icon: '⤵️'),

  /// Sign -2 – normal left turn.
  left(sign: -2, icon: '⬅️'),

  /// Sign -1 – bear slightly to the left.
  slightLeft(sign: -1, icon: '↖️'),

  /// Sign 4 – journey is complete.
  arrived(sign: 4, icon: '🏁');

  const ManeuverType({
    required this.sign,
    required this.icon,
  });

  /// Numeric sign code compatible with routing engine conventions.
  final int sign;

  /// Single Unicode emoji used in the navigation HUD.
  final String icon;

  /// Classifies a [turnAngle] (degrees, 0–360, clockwise from north)
  /// into the appropriate [ManeuverType].
  ///
  /// A turn angle of 0° / 360° means the vehicle is going perfectly
  /// straight ahead.  Angles between 0° and 180° are right-hand turns;
  /// angles between 180° and 360° are left-hand turns.
  static ManeuverType fromAngle(double turnAngle) {
    // Normalise to [0, 360).
    final a = ((turnAngle % 360) + 360) % 360;

    // Straight (within ±20°)
    if (a <= 20 || a >= 340) return continueStraight;

    // Right-hand side  (0° → 180°)
    if (a <= 45) return slightRight;
    if (a <= 135) return right;
    if (a <= 165) return sharpRight;

    // U-turn  (165° – 195°)
    if (a <= 195) return uTurn;

    // Left-hand side  (195° → 360°)
    if (a <= 225) return sharpLeft;
    if (a <= 315) return left;

    return slightLeft; // 315° – 340°
  }
}
