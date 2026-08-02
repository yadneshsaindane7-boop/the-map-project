import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/traffic_alert.dart';
import 'alerts_repository_provider.dart';

final alertsProvider =
    FutureProvider<List<TrafficAlert>>(
  (ref) async {
    return ref
        .read(alertsRepositoryProvider)
        .getAlerts();
  },
);