import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/report_repository.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository();
});