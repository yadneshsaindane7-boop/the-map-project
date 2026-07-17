import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/incident_type.dart';

class ReportFormState {
  final IncidentType incidentType;
  final bool isSubmitting;

  const ReportFormState({
    this.incidentType = IncidentType.roadClosed,
    this.isSubmitting = false,
  });

  ReportFormState copyWith({
    IncidentType? incidentType,
    bool? isSubmitting,
  }) {
    return ReportFormState(
      incidentType: incidentType ?? this.incidentType,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class ReportFormNotifier extends Notifier<ReportFormState> {
  @override
  ReportFormState build() {
    return const ReportFormState();
  }

  void setIncidentType(IncidentType type) {
    state = state.copyWith(
      incidentType: type,
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