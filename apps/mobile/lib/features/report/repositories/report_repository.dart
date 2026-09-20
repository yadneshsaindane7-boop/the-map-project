import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/event_type.dart';

class ReportRepository {
  final SupabaseClient _supabase;

  ReportRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  Future<String> submitReport({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required EventType eventType,
    required int osmWayId,
    XFile? image,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('You must be logged in to submit an incident report.');
    }

    String? imagePath;

    try {
      if (image != null) {
        imagePath = await _uploadImage(
          image: image,
          userId: user.id,
        );
      }

      final result = await _supabase.rpc(
        'submit_incident_report',
        params: {
          'p_title': title,
          'p_description': description,
          'p_event_type_id': eventType.id,
          'p_user_id': user.id,
          'p_latitude': latitude,
          'p_longitude': longitude,
          'p_osm_way_id': osmWayId,
          'p_image_path': imagePath,
        },
      );

      return result as String;
    } catch (error) {
      if (imagePath != null) {
        try {
          await _supabase.storage
              .from('incident-images')
              .remove([imagePath]);
        } catch (cleanupError) {
          debugPrint('Image cleanup failed: $cleanupError');
        }
      }

      rethrow;
    }
  }

  Future<String> _uploadImage({
    required XFile image,
    required String userId,
  }) async {
    final bytes = await image.readAsBytes();

    final extension = _getExtension(image.name);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = '$userId/${timestamp}_incident.$extension';

    await _supabase.storage
        .from('incident-images')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: _getContentType(extension),
            upsert: false,
          ),
        );

    return path;
  }

  String _getExtension(String name) {
    final parts = name.split('.');
    if (parts.length < 2) {
      return 'jpg';
    }

    return parts.last.toLowerCase();
  }

  String _getContentType(String extension) {
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      default:
        return 'image/jpeg';
    }
  }
}