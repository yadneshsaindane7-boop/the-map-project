import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/event_type.dart';

class EventTypeRepository {
  final SupabaseClient _supabase;

  EventTypeRepository({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  Future<List<EventType>> fetchEventTypes() async {
    final response = await _supabase
        .from('event_types')
        .select()
        .order('name');

    return response
        .map<EventType>(
          (json) => EventType.fromMap(json),
        )
        .toList();
  }
}