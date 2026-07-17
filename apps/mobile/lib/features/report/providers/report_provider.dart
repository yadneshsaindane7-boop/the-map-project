import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event_type.dart';

class ReportFormState {
  final EventType? selectedEventType;
  final bool isSubmitting;

  const ReportFormState({
    this.selectedEventType,
    this.isSubmitting = false,
  });

  ReportFormState copyWith({
    EventType? selectedEventType,
    bool? isSubmitting,
    bool clearSelectedEventType = false,
  }) {
    return ReportFormState(
      selectedEventType: clearSelectedEventType
          ? null
          : (selectedEventType ?? this.selectedEventType),
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

  void setSubmitting(bool value) {
    state = state.copyWith(
      isSubmitting: value,
    );
  }
}

final reportProvider =
    NotifierProvider<ReportFormNotifier, ReportFormState>(
  ReportFormNotifier.new,
);