import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/road_event.dart';

class RoadEventRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<RoadEvent>> getRoadEvents() async {
    final response = await _client
        .from('road_events')
        .select()
        .order('created_at', ascending: false);

    debugPrint("========== ROAD EVENTS ==========");
    debugPrint("Count : ${response.length}");
    debugPrint(response.toString());
    debugPrint("================================");

    return response
        .map<RoadEvent>(
          (json) => RoadEvent.fromJson(json),
        )
        .toList();
  }
}