// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'The Map Project';

  @override
  String get appTagline => 'Real-time Road Intelligence';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Try Again';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get status => 'Status';

  @override
  String get distance => 'Distance';

  @override
  String get reporter => 'Reporter';

  @override
  String get reported => 'Reported';

  @override
  String get location => 'Location';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get community => 'Community';

  @override
  String get nashik => 'Nashik';

  @override
  String get navMap => 'Map';

  @override
  String get navReport => 'Report';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navProfile => 'Profile';

  @override
  String get searchDestinationHint => 'Search destination...';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get mapLayers => 'Map layers';

  @override
  String get myLocation => 'My location';

  @override
  String get zoomToReports => 'Zoom to Reports';

  @override
  String get findingRoute => 'Finding route...';

  @override
  String get rerouting => 'Rerouting...';

  @override
  String get routePointsTooFew =>
      'Route was returned but contains too few points.';

  @override
  String get unableToFindRoute => 'Unable to find a route.';

  @override
  String failedToLoadRoute(String error) {
    return 'Failed to load route: $error';
  }

  @override
  String get arrivalMessage => 'You have arrived at your destination.';

  @override
  String get roadIncidentRerouting => 'Road incident detected. Rerouting...';

  @override
  String get mapStyleStreets => 'Streets';

  @override
  String get mapStyleTerrain => 'Terrain';

  @override
  String get mapStyleSatellite => 'Satellite';

  @override
  String get unknownDate => 'Unknown';

  @override
  String get navigateButton => 'Navigate';

  @override
  String get navigationFutureNotice => 'Navigation will be available in v0.5.0';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get incidentConfirmedMessage => 'Thanks for confirming this incident.';

  @override
  String get eta => 'ETA';

  @override
  String get startNavigation => 'START NAVIGATION';

  @override
  String get nextInstruction => 'Next instruction';

  @override
  String get continueCurrentRoute => 'Continue on the current route';

  @override
  String inDistance(String distance) {
    return 'In $distance';
  }

  @override
  String get endJourney => 'End journey';

  @override
  String get remaining => 'Remaining';

  @override
  String distanceMeters(int count) {
    return '$count m';
  }

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String durationMin(int count) {
    return '$count min';
  }

  @override
  String durationHours(int count) {
    return '$count hr';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String get reportIncidentTitle => 'Report Incident';

  @override
  String get reportIncidentSubtitle => 'Help keep Nashik roads safer';

  @override
  String get incidentLocation => 'Incident Location';

  @override
  String get locationSelectedOnMap => 'Location selected on map';

  @override
  String get usingCurrentLocation => 'Using your current location';

  @override
  String get changeLocation => 'Change Location';

  @override
  String get chooseOnMap => 'Choose on Map';

  @override
  String get incidentDetails => 'Incident Details';

  @override
  String get incidentTitle => 'Incident Title';

  @override
  String get incidentTitleHint => 'e.g. Accident near bridge';

  @override
  String get incidentTitleEmptyError => 'Enter an incident title';

  @override
  String get incidentTitleMinError => 'Title must be at least 3 characters';

  @override
  String get incidentDescriptionOptional => 'Description (Optional)';

  @override
  String get incidentDescriptionHint =>
      'Add useful details for other drivers...';

  @override
  String get incidentType => 'Incident Type';

  @override
  String get whatIsHappening => 'What is happening on the road?';

  @override
  String get selectIncidentType => 'Select incident type';

  @override
  String get selectIncidentTypeError => 'Please select an incident type';

  @override
  String get resolvingRoadAndSubmitting => 'Resolving Road & Submitting...';

  @override
  String get submitIncident => 'Submit Incident';

  @override
  String get reportReviewDisclaimer =>
      'Reports are reviewed before becoming active traffic alerts.';

  @override
  String get reportSuccessMessage =>
      'Incident submitted successfully.\nYour report has been sent for review.';

  @override
  String reportErrorMessage(String error) {
    return 'Unable to submit the incident.\n$error';
  }

  @override
  String get unableToGetLocation => 'Unable to get your location';

  @override
  String unableToLoadIncidentTypes(String error) {
    return 'Unable to load incident types.\n$error';
  }

  @override
  String get chooseIncidentLocation => 'Choose Incident Location';

  @override
  String get resetLocation => 'Reset location';

  @override
  String get tapMapToSelectLocation =>
      'Tap the map to select the incident location';

  @override
  String get selectedPointAttached =>
      'The selected point will be attached to your report.';

  @override
  String get useThisLocation => 'Use This Location';

  @override
  String get incidentRoadClosed => 'Road Closed';

  @override
  String get incidentAccident => 'Accident';

  @override
  String get incidentConstruction => 'Construction';

  @override
  String get incidentFlooding => 'Flooding';

  @override
  String get incidentTrafficJam => 'Traffic Jam';

  @override
  String get incidentPothole => 'Pothole';

  @override
  String get incidentPublicEvent => 'Public Event';

  @override
  String get incidentDiversion => 'Diversion';

  @override
  String get incidentOther => 'Other';

  @override
  String get trafficAlertsTitle => 'Traffic Alerts';

  @override
  String get trafficAlertsSubtitle => 'Stay informed about incidents nearby';

  @override
  String get refreshAlertsTooltip => 'Refresh alerts';

  @override
  String get loadingTrafficAlerts => 'Loading traffic alerts...';

  @override
  String get unableToLoadAlerts => 'Unable to load alerts';

  @override
  String get alertsErrorMessage =>
      'Something went wrong while loading the latest traffic alerts.';

  @override
  String activeAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active alerts',
      one: '1 active alert',
    );
    return '$_temp0';
  }

  @override
  String get updatedLive => 'Updated live';

  @override
  String get communityVerified => 'Community verified';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinAgo(int count) {
    return '$count min ago';
  }

  @override
  String timeHrAgo(int count) {
    return '$count hr ago';
  }

  @override
  String get timeDayAgo => '1 day ago';

  @override
  String timeDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get statusActive => 'ACTIVE';

  @override
  String get statusVerified => 'VERIFIED';

  @override
  String get statusResolved => 'RESOLVED';

  @override
  String get noActiveAlerts => 'No active alerts';

  @override
  String get noActiveAlertsDescription =>
      'There are no verified traffic incidents affecting the road network right now.';

  @override
  String get youAreAllClear => 'You are all clear';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileCommunityActivity => 'Your community activity';

  @override
  String get yourActivity => 'Your Activity';

  @override
  String get yourContribution => 'Your contribution to the community';

  @override
  String get reportsCountLabel => 'Reports';

  @override
  String get activeCountLabel => 'Active';

  @override
  String get reputationLabel => 'Reputation';

  @override
  String get achievementsLabel => 'Achievements';

  @override
  String get communityMilestones => 'Your community milestones';

  @override
  String get badgeFirstReport => 'First Report';

  @override
  String get badgeRoadGuardian => 'Road Guardian';

  @override
  String get badgeCommunityHelper => 'Community Helper';

  @override
  String get authorityTools => 'Authority Tools';

  @override
  String get authorityToolsSubtitle => 'Tools available to authorized users';

  @override
  String get moderateIncidentReports => 'Moderate Incident Reports';

  @override
  String get moderateReportsSubtitle =>
      'Review, approve, or reject pending reports';

  @override
  String get settings => 'Settings';

  @override
  String get manageAppPreferences => 'Manage your app preferences';

  @override
  String get notifications => 'Notifications';

  @override
  String get manageNotificationPreferences => 'Manage notification preferences';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get aboutAppVersion => 'The Map Project v2.0';

  @override
  String get footerNashik => 'The Map Project • Nashik';

  @override
  String get unableToLoadProfile => 'Unable to load profile';

  @override
  String get unableToLoadProfileMessage =>
      'We could not load your profile information.';

  @override
  String get authorityAccount => 'Authority account';

  @override
  String get communityMember => 'Community member';

  @override
  String get logout => 'Logout';

  @override
  String logoutFailed(String error) {
    return 'Logout failed\n$error';
  }

  @override
  String get incidentModerationTitle => 'Incident Moderation';

  @override
  String get incidentModerationSubtitle => 'Review community reports';

  @override
  String get pendingReports => 'Pending Reports';

  @override
  String get pendingReportsSubtitle => 'Awaiting authority review';

  @override
  String get activeIncidents => 'Active Incidents';

  @override
  String get activeIncidentsSubtitle => 'Currently affecting road routing';

  @override
  String get noPendingReports => 'No pending reports';

  @override
  String get noPendingReportsSubtitle =>
      'New community reports will appear here.';

  @override
  String get noActiveIncidents => 'No active incidents';

  @override
  String get noActiveIncidentsSubtitle =>
      'All verified incidents are currently resolved.';

  @override
  String get pendingReportsUnavailable => 'Pending reports unavailable';

  @override
  String get activeIncidentsUnavailable => 'Active incidents unavailable';

  @override
  String get osmWay => 'OSM Way';

  @override
  String get notAssigned => 'Not assigned';

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String get resolveIncident => 'Resolve Incident';

  @override
  String get approveIncidentTitle => 'Approve incident?';

  @override
  String approveIncidentMessage(String title) {
    return 'Approve \"$title\" and make this incident available to the routing system?';
  }

  @override
  String get incidentApprovedMessage => 'Incident report approved.';

  @override
  String approvalFailedMessage(String error) {
    return 'Approval failed: $error';
  }

  @override
  String get rejectIncidentTitle => 'Reject incident?';

  @override
  String rejectIncidentMessage(String title) {
    return 'Reject \"$title\"? This report will not be activated for routing.';
  }

  @override
  String get incidentRejectedMessage => 'Incident report rejected.';

  @override
  String rejectionFailedMessage(String error) {
    return 'Rejection failed: $error';
  }

  @override
  String get resolveIncidentTitle => 'Resolve incident?';

  @override
  String resolveIncidentMessage(String title) {
    return 'Mark \"$title\" as completed and remove its road restriction from active routing?';
  }

  @override
  String get incidentResolvedMessage =>
      'Incident resolved and road restriction removed.';

  @override
  String resolutionFailedMessage(String error) {
    return 'Resolution failed: $error';
  }

  @override
  String get smartNavigationSubtitle => 'Community Powered Smart Navigation';

  @override
  String get loginTaglineDescription =>
      'Navigate smarter with live road information and community-powered alerts.';

  @override
  String get liveTraffic => 'Live Traffic';

  @override
  String get smartRoutes => 'Smart Routes';

  @override
  String get getStarted => 'Get started';

  @override
  String get signInSubtitle =>
      'Sign in to access your personalized map experience.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get secureSignInGoogle => 'Secure sign-in with Google';

  @override
  String get termsNotice =>
      'By continuing, you agree to use the app responsibly.';

  @override
  String get stayInformed => 'Stay informed';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get pushNotificationsDescription =>
      'Receive important notifications from The Map Project.';

  @override
  String get notificationTypes => 'Notification Types';

  @override
  String get nearbyRoadAlerts => 'Nearby Road Alerts';

  @override
  String get nearbyRoadAlertsDescription =>
      'Get alerts about incidents and road conditions near you.';

  @override
  String get routeUpdates => 'Route Updates';

  @override
  String get routeUpdatesDescription =>
      'Be notified when your active route needs to change.';

  @override
  String get communityReportsNotification => 'Community Reports';

  @override
  String get communityReportsNotificationDescription =>
      'Receive updates related to community-reported incidents.';

  @override
  String get notificationSessionNotice =>
      'Notification preferences currently apply to this session. Persistent notification preferences will be added in a future update.';

  @override
  String get notificationFooter => 'The Map Project • Notification Settings';

  @override
  String get choosePreferredLanguage => 'Choose your preferred language';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get availableLanguages => 'Available Languages';

  @override
  String saveLanguage(String language) {
    return 'Save $language';
  }

  @override
  String languageSelectedSnackbar(String language) {
    return '$language selected.';
  }

  @override
  String get languageFutureNotice =>
      'More regional Indian languages will be available in future updates.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get languageMarathi => 'Marathi';

  @override
  String appVersionBuild(String version, String build) {
    return 'Version $version • Build $build';
  }

  @override
  String get aboutTheProject => 'About the Project';

  @override
  String get hlpName => 'HLP - Hibro Lab Productions';

  @override
  String get aboutProjectDescription =>
      'The Map Project is a community-powered navigation platform designed to provide real-time road conditions, road closures, traffic incidents and intelligent route guidance using community reports and modern mapping technologies.';

  @override
  String get developmentTeam => 'Development Team';

  @override
  String get roleProjectGuide => 'Project Guide';

  @override
  String get roleLeadDeveloper => 'Lead Developer';

  @override
  String get roleDocumentation => 'Project Documentation';

  @override
  String get roleResearchValidation => 'Research & Field Validation';

  @override
  String get technologyStack => 'Technology Stack';

  @override
  String get techFramework => 'Framework';

  @override
  String get techBackend => 'Backend';

  @override
  String get techMaps => 'Maps';

  @override
  String get techRouting => 'Routing';

  @override
  String get techLanguage => 'Programming Language';

  @override
  String get featureReporting => 'Community Incident Reporting';

  @override
  String get featureTrafficAlerts => 'Real-Time Traffic Alerts';

  @override
  String get featureRoadClosure => 'Road Closure Detection';

  @override
  String get featureSmartRouting => 'Smart Route Navigation';

  @override
  String get featureCommunityVerification => 'Community Verification';

  @override
  String get featureUserProfiles => 'User Profiles & Statistics';

  @override
  String get projectInformation => 'Project Information';

  @override
  String get statusLabel => 'Status';

  @override
  String get statusActiveDevelopment => 'Active Development';

  @override
  String get publisherLabel => 'Publisher';

  @override
  String get licenseLabel => 'License';

  @override
  String get licenseEducational => 'Educational & Research Project';

  @override
  String get support => 'Support';

  @override
  String get reportBug => 'Report a Bug';

  @override
  String get contactDeveloper => 'Contact Developer';

  @override
  String get reportBugDialogTitle => 'Report a Bug';

  @override
  String get reportBugDialogContent =>
      'Bug reporting portal will be available in a future update.\n\nFor now, you can report bugs directly to the developer using the Contact Developer option.';

  @override
  String get unableOpenEmail => 'Unable to open email application.';

  @override
  String get hlpDescription =>
      'The Map Project is a product developed and maintained by HLP - Hibro Lab Productions.';

  @override
  String get developerContact => 'Developer Contact';

  @override
  String get copyrightNotice => '© 2026 HLP - Hibro Lab Productions';

  @override
  String get allRightsReserved => 'All Rights Reserved.';

  @override
  String get notificationGeneralName => 'The Map Project';

  @override
  String get notificationGeneralDescription =>
      'Navigation, route, and road alert notifications.';

  @override
  String get notificationTestBody => 'Notifications are working successfully!';

  @override
  String get notificationJourneyStartedTitle => 'Journey Started';

  @override
  String get notificationJourneyStartedBody => 'Navigation has started.';

  @override
  String get notificationJourneyCompletedTitle => 'Journey Completed';

  @override
  String get notificationJourneyCompletedBody =>
      'You have reached your destination.';

  @override
  String get notificationRouteUpdatedTitle => 'Route Updated';

  @override
  String get notificationRouteUpdatedBody =>
      'Your route has been updated because of a road event.';

  @override
  String get noUserLoggedIn => 'No User Logged In';

  @override
  String welcomeUser(String email) {
    return 'Welcome\n\n$email';
  }

  @override
  String get singleActiveAlert => '1 active alert';

  @override
  String multipleActiveAlerts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active alerts',
      one: '1 active alert',
      zero: 'No active alerts',
    );
    return '$_temp0';
  }

  @override
  String get somethingWentWrongAlerts =>
      'Something went wrong while loading traffic alerts.';

  @override
  String get arrivedAtDestinationSnackbar =>
      'You have arrived at your destination.';

  @override
  String get communityReporterFallback => 'Community member';

  @override
  String get navigationAvailableSoon =>
      'Navigation for this incident will be available soon.';

  @override
  String get thanksForConfirming => 'Thanks for confirming this incident.';

  @override
  String get continueOnCurrentRoute => 'Continue on current route';

  @override
  String get statReports => 'Reports';

  @override
  String get statActive => 'Active';

  @override
  String get statReputation => 'Reputation';

  @override
  String get statAchievements => 'Achievements';

  @override
  String get appTitleWithCity => 'The Map Project ? Nashik';

  @override
  String get couldNotLoadProfileInfo => 'Could not load profile information.';

  @override
  String get achievementFirstReport => 'First Report';

  @override
  String get achievementRoadGuardian => 'Road Guardian';

  @override
  String get achievementCommunityHelper => 'Community Helper';

  @override
  String get unableToOpenEmail => 'Unable to open email.';

  @override
  String get reportBugContent =>
      'If you found a problem with the app, please describe it and send us the details.';

  @override
  String get coreFeatures => 'Core Features';

  @override
  String get featureIncidentReporting => 'Incident Reporting';

  @override
  String get featureSmartNavigation => 'Smart Navigation';

  @override
  String versionBuildSummary(Object appVersion, Object buildNumber) {
    return 'Version $appVersion ? Build $buildNumber';
  }

  @override
  String languageChangedSnackbar(Object language) {
    return 'Language changed to $language.';
  }

  @override
  String saveLanguageButton(Object language) {
    return 'Save $language';
  }

  @override
  String get languageAppliesInstantly =>
      'Language changes apply instantly throughout the app.';

  @override
  String get notificationPreferencesFootnote =>
      'Notification preferences are currently applied for this session.';

  @override
  String get notificationSettingsSummary =>
      'Manage your notification preferences for road alerts and community updates.';
}
