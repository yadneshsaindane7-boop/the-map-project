import 'package:flutter/foundation.dart';

@immutable
class UserProfile {
  final String id;
  final String email;
  final String? fullName;

  final int totalReports;
  final int activeReports;
  final int approvedReports;

  const UserProfile({
    required this.id,
    required this.email,
    this.fullName,
    this.totalReports = 0,
    this.activeReports = 0,
    this.approvedReports = 0,
  });

  String get displayName {
    if (fullName != null && fullName!.trim().isNotEmpty) {
      return fullName!;
    }

    return email.split('@').first;
  }

  String get initials {
    final parts = displayName.trim().split(' ');

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return "${parts.first[0]}${parts.last[0]}".toUpperCase();
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    int? totalReports,
    int? activeReports,
    int? approvedReports,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      totalReports: totalReports ?? this.totalReports,
      activeReports: activeReports ?? this.activeReports,
      approvedReports: approvedReports ?? this.approvedReports,
    );
  }
}