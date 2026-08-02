import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/alerts_repository.dart';

final alertsRepositoryProvider =
    Provider<AlertsRepository>((ref) {
  return AlertsRepository();
});