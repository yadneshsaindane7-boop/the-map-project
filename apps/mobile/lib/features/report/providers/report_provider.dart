import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../models/event_type.dart';

class ReportFormState {
  final EventType? selectedEventType;
  final LatLng? selectedLocation;
  final bool isSubmitting;

  const ReportFormState({
    this.selectedEventType,
    this.selectedLocation,
    this.isSubmitting = false,
  });

  ReportFormState copyWith({
    EventType? selectedEventType,
    LatLng? selectedLocation,
    bool? isSubmitting,
    bool clearSelectedEventType = false,
    bool clearSelectedLocation = false,
  }) {
    return ReportFormState(
      selectedEventType: clearSelectedEventType
          ? null
          : (selectedEventType ?? this.selectedEventType),

      selectedLocation: clearSelectedLocation
          ? null
          : (selectedLocation ?? this.selectedLocation),

      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ReportFormNotifier extends Notifier<ReportFormState> {
  @override
  ReportFormState build() {
    return const ReportFormState();
  }

  void setSelectedEventType(EventType eventType) {
    state = state.copyWith(
      selectedEventType: eventType,
    );
  }

  void clearSelectedEventType() {
    state = state.copyWith(
      clearSelectedEventType: true,
    );
  }

  void setSelectedLocation(LatLng location) {
    state = state.copyWith(
      selectedLocation: location,
    );
  }

  void clearSelectedLocation() {
    state = state.copyWith(
      clearSelectedLocation: true,
    );
  }

  void setSubmitting(bool value) {
    state = state.copyWith(
      isSubmitting: value,
    );
  }

  void reset() {
    state = const ReportFormState();
  }
}

final reportProvider =
    NotifierProvider<ReportFormNotifier, ReportFormState>(
  ReportFormNotifier.new,
);