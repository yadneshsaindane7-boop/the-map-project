import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/road_event.dart';

class RoadEventRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<RoadEvent>> getRoadEvents() async {
    final response = await _client
        .from('active_incident_reports_view')
        .select()
        .order('created_at', ascending: false);

    debugPrint('========== ACTIVE INCIDENTS ==========');
    debugPrint('Count: ${response.length}');

    final events = await Future.wait(
      response.map((row) async {
        final json = Map<String, dynamic>.from(row);
        final imagePath = json['image_path']?.toString().trim();

        if (imagePath != null && imagePath.isNotEmpty) {
          try {
            json['image_url'] = await _client.storage
                .from('incident-images')
                .createSignedUrl(imagePath, 3600);
          } catch (error) {
            json['image_url'] = null;
            debugPrint(
              'Could not load incident image for '
              '${json['id']}: $error',
            );
          }
        } else {
          json['image_url'] = null;
        }

        return RoadEvent.fromJson(json);
      }),
    );

    debugPrint('Loaded ${events.length} road events.');
    debugPrint('======================================');

    return events;
  }
}
