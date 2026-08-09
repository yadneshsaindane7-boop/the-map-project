import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Controls whether the user has started a journey.
class JourneyNavigationState {
  final bool isNavigating;

  const JourneyNavigationState({
    this.isNavigating = false,
  });

  JourneyNavigationState copyWith({
    bool? isNavigating,
  }) {
    return JourneyNavigationState(
      isNavigating: isNavigating ?? this.isNavigating,
    );
  }
}

class JourneyNavigationNotifier
    extends Notifier<JourneyNavigationState> {
  @override
  JourneyNavigationState build() {
    return const JourneyNavigationState();
  }

  void startNavigation() {
    state = state.copyWith(
      isNavigating: true,
    );
  }

  void stopNavigation() {
    state = state.copyWith(
      isNavigating: false,
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