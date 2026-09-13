import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../map/map_styles.dart';
import '../../features/report/models/incident_type.dart';

extension IncidentTypeLocalization on IncidentType {
  String localizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case IncidentType.roadClosed:
        return l10n.incidentRoadClosed;
      case IncidentType.accident:
        return l10n.incidentAccident;
      case IncidentType.construction:
        return l10n.incidentConstruction;
      case IncidentType.flooding:
        return l10n.incidentFlooding;
      case IncidentType.trafficJam:
        return l10n.incidentTrafficJam;
      case IncidentType.pothole:
        return l10n.incidentPothole;
      case IncidentType.event:
        return l10n.incidentPublicEvent;
      case IncidentType.other:
        return l10n.incidentOther;
    }
  }
}

extension MapStyleLocalization on MapStyle {
  String localizedDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case MapStyle.streets:
        return l10n.mapStyleStreets;
      case MapStyle.terrain:
        return l10n.mapStyleTerrain;
      case MapStyle.satellite:
        return l10n.mapStyleSatellite;
    }
  }
}

String getLocalizedIncidentType(BuildContext context, String rawType) {
  final l10n = AppLocalizations.of(context)!;
  final normalized = rawType.trim().toLowerCase();

  if (normalized.contains('closure') || normalized.contains('closed')) {
    return l10n.incidentRoadClosed;
  }
  if (normalized.contains('accident')) {
    return l10n.incidentAccident;
  }
  if (normalized.contains('construction')) {
    return l10n.incidentConstruction;
  }
  if (normalized.contains('flood') || normalized.contains('water')) {
    return l10n.incidentFlooding;
  }
  if (normalized.contains('traffic') || normalized.contains('jam') || normalized.contains('congestion')) {
    return l10n.incidentTrafficJam;
  }
  if (normalized.contains('pothole')) {
    return l10n.incidentPothole;
  }
  if (normalized.contains('event')) {
    return l10n.incidentPublicEvent;
  }
  if (normalized.contains('diversion') || normalized.contains('detour')) {
    return l10n.incidentDiversion;
  }

  return rawType.isNotEmpty ? rawType : l10n.incidentOther;
}

String getLocalizedAlertStatus(BuildContext context, String status) {
  final l10n = AppLocalizations.of(context)!;
  final normalized = status.trim().toLowerCase();

  switch (normalized) {
    case 'active':
      return l10n.statusActive;
    case 'verified':
      return l10n.statusVerified;
    case 'resolved':
    case 'completed':
      return l10n.statusResolved;
    default:
      return status.toUpperCase();
  }
}

String formatTimeAgo(BuildContext context, DateTime dateTime) {
  final l10n = AppLocalizations.of(context)!;
  final difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return l10n.timeJustNow;
  }
  if (difference.inMinutes < 60) {
    return l10n.timeMinAgo(difference.inMinutes);
  }
  if (difference.inHours < 24) {
    return l10n.timeHrAgo(difference.inHours);
  }
  if (difference.inDays == 1) {
    return l10n.timeDayAgo;
  }
  return l10n.timeDaysAgo(difference.inDays);
}
