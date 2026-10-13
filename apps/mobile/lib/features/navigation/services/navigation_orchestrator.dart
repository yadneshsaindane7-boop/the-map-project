import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/maneuver_type.dart';
import '../models/route_instruction.dart';
import '../models/route_model.dart';
import '../providers/navigation_provider.dart';
import '../utils/maneuver_calculator.dart';
import 'navigation_tts_service.dart';

final navigationOrchestratorProvider =
    Provider<NavigationOrchestrator>((ref) {
  final orchestrator = NavigationOrchestrator(ref);
  ref.onDispose(orchestrator.dispose);
  return orchestrator;
});

class NavigationOrchestrator {
  NavigationOrchestrator(this._ref) {
    _tts = NavigationTtsService();

    _tts.initialize().then((_) {
      debugPrint('[Orchestrator] TTS ready.');
    }).catchError((Object error) {
      debugPrint('[Orchestrator] TTS initialization failed: $error');
    });
  }

  final Ref _ref;
  late final NavigationTtsService _tts;

  List<RouteInstruction> _instructions = [];
  List<LatLng> _maneuverPoints = [];

  final Set<int> _advanceFired = {};
  final Set<int> _immediateFired = {};

  double _totalRouteDistance = 0;

  bool get muted => _tts.muted;

  set muted(bool value) {
    _tts.muted = value;
  }

  void attachRoute(RouteModel route, {String locale = 'en'}) {
    _instructions = ManeuverCalculator.calculate(route.points);
    _totalRouteDistance = route.distance;

    _advanceFired.clear();
    _immediateFired.clear();

    _maneuverPoints = _extractManeuverPoints(
      route.points,
      _instructions,
    );

    debugPrint(
      '[Orchestrator] Route attached: '
      '${route.points.length} points, '
      '${_instructions.length} instructions.',
    );

    unawaited(_tts.speakNavigationStarted(locale: locale));
  }

  void updatePosition({
    required double latitude,
    required double longitude,
    required double remainingDistanceMeters,
    required String locale,
  }) {
    if (_instructions.isEmpty || _maneuverPoints.isEmpty) {
      return;
    }

    final idx = ManeuverCalculator.currentInstructionIndex(
      instructions: _instructions,
      remainingDistanceMeters: remainingDistanceMeters,
      totalRouteDistanceMeters: _totalRouteDistance,
    );

    final instruction = _instructions[idx];

    _ref.read(journeyNavigationProvider.notifier).updateInstruction(
          instructionIndex: idx,
          instruction: instruction,
        );

    if (instruction.sign == ManeuverType.arrived.sign) {
      if (_immediateFired.add(idx)) {
        unawaited(_tts.speakArrived(locale: locale));
      }
      return;
    }

    if (idx >= _maneuverPoints.length) {
      return;
    }

    final point = _maneuverPoints[idx];

    final distance = Geolocator.distanceBetween(
      latitude,
      longitude,
      point.latitude,
      point.longitude,
    );

    if (distance <= 35) {
      if (_immediateFired.add(idx)) {
        _advanceFired.add(idx);

        unawaited(
          _tts.speakNow(
            maneuverKey: instruction.text,
            locale: locale,
          ),
        );
      }
      return;
    }

    if (distance <= 200 && _advanceFired.add(idx)) {
      unawaited(
        _tts.speakInstruction(
          maneuverKey: instruction.text,
          locale: locale,
          distanceMeters: distance,
        ),
      );
    }
  }

  void dispose() {
    unawaited(_tts.dispose());
    debugPrint('[Orchestrator] Disposed.');
  }

  static List<LatLng> _extractManeuverPoints(
    List<LatLng> points,
    List<RouteInstruction> instructions,
  ) {
    if (points.isEmpty) {
      return [];
    }

    return instructions.map((instruction) {
      final index = (instruction.pointIndex ?? points.length - 1)
          .clamp(0, points.length - 1);

      return points[index];
    }).toList();
  }
}