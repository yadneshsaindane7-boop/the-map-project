import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/event_type.dart';
import '../repositories/report_repository.dart';
import 'report_repository_provider.dart';

final reportControllerProvider = Provider<ReportController>((ref) {
  return ReportController(ref.read(reportRepositoryProvider));
});

class ReportController {
  ReportController(this._repository);

  final ReportRepository _repository;

  Future<String> submitReport({
    required String description,
    required EventType eventType,
    required double latitude,
    required double longitude,
    required int osmWayId,
    XFile? image,
  }) {
    return _repository.submitReport(
      title: eventType.name,
      description: description,
      eventType: eventType,
      latitude: latitude,
      longitude: longitude,
      osmWayId: osmWayId,
      image: image,
    );
  }
}