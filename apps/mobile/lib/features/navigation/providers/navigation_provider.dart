import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/route_instruction.dart';

/// Controls the selected tab in the main bottom navigation.
class NavigationNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void changeTab(int index) {
    state = index;
  }
}

final navigationProvider =
    NotifierProvider<NavigationNotifier, int>(
  NavigationNotifier.new,
);

/// Stores the current live journey/navigation state.
class JourneyNavigationState {
  final bool isNavigating;
  final bool hasArrived;

  final double? remainingDistanceMeters;
  final int? remainingDurationMillis;

  final int currentInstructionIndex;
  final RouteInstruction? currentInstruction;

  const JourneyNavigationState({
    this.isNavigating = false,
    this.hasArrived = false,
    this.remainingDistanceMeters,
    this.remainingDurationMillis,
    this.currentInstructionIndex = 0,
    this.currentInstruction,
  });

  JourneyNavigationState copyWith({
    bool? isNavigating,
    bool? hasArrived,
    double? remainingDistanceMeters,
    int? remainingDurationMillis,
    int? currentInstructionIndex,
    RouteInstruction? currentInstruction,
    bool clearCurrentInstruction = false,
  }) {
    return JourneyNavigationState(
      isNavigating:
          isNavigating ?? this.isNavigating,
      hasArrived:
          hasArrived ?? this.hasArrived,
      remainingDistanceMeters:
          remainingDistanceMeters ??
              this.remainingDistanceMeters,
      remainingDurationMillis:
          remainingDurationMillis ??
              this.remainingDurationMillis,
      currentInstructionIndex:
          currentInstructionIndex ??
              this.currentInstructionIndex,
      currentInstruction:
          clearCurrentInstruction
              ? null
              : currentInstruction ??
                  this.currentInstruction,
    );
  }
}

class JourneyNavigationNotifier
    extends Notifier<JourneyNavigationState> {
  @override
  JourneyNavigationState build() {
    return const JourneyNavigationState();
  }

  void startNavigation({
    required double initialDistanceMeters,
    required int initialDurationMillis,
  }) {
    state = JourneyNavigationState(
      isNavigating: true,
      hasArrived: false,
      remainingDistanceMeters:
          initialDistanceMeters,
      remainingDurationMillis:
          initialDurationMillis,
      currentInstructionIndex: 0,
    );
  }

  void stopNavigation() {
    state = const JourneyNavigationState();
  }

  void arrive() {
    state = JourneyNavigationState(
      isNavigating: false,
      hasArrived: true,
      remainingDistanceMeters: 0,
      remainingDurationMillis: 0,
      currentInstructionIndex:
          state.currentInstructionIndex,
      currentInstruction:
          state.currentInstruction,
    );
  }

  void updateProgress({
    required double remainingDistanceMeters,
    required int remainingDurationMillis,
  }) {
    state = state.copyWith(
      remainingDistanceMeters:
          remainingDistanceMeters,
      remainingDurationMillis:
          remainingDurationMillis,
    );
  }

  void updateInstruction({
    required int instructionIndex,
    required RouteInstruction instruction,
  }) {
    if (state.currentInstructionIndex ==
            instructionIndex &&
        state.currentInstruction?.text ==
            instruction.text) {
      return;
    }

    state = state.copyWith(
      currentInstructionIndex:
          instructionIndex,
      currentInstruction: instruction,
    );
  }
}

final journeyNavigationProvider =
    NotifierProvider<
      JourneyNavigationNotifier,
      JourneyNavigationState
    >(
  JourneyNavigationNotifier.new,
);