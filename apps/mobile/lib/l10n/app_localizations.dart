import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr'),
  ];

  /// Name of the application
  ///
  /// In en, this message translates to:
  /// **'Maarg Saarthi'**
  String get appTitle;

  /// App subtitle / tagline
  ///
  /// In en, this message translates to:
  /// **'Real-time Road Intelligence'**
  String get appTagline;

  /// Generic OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Generic Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Generic Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Generic Retry button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get retry;

  /// Generic Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Generic Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Distance label
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// Reporter label
  ///
  /// In en, this message translates to:
  /// **'Reporter'**
  String get reporter;

  /// Reported time label
  ///
  /// In en, this message translates to:
  /// **'Reported'**
  String get reported;

  /// Location label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Latitude coordinate label
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// Longitude coordinate label
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitude;

  /// Community label
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// City name Nashik
  ///
  /// In en, this message translates to:
  /// **'Nashik'**
  String get nashik;

  /// Bottom navigation label for Map
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// Bottom navigation label for Report
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get navReport;

  /// Bottom navigation label for Alerts
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get navAlerts;

  /// Bottom navigation label for Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// Search destination input hint
  ///
  /// In en, this message translates to:
  /// **'Search destination...'**
  String get searchDestinationHint;

  /// Tooltip for clear search button
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// Tooltip for map layers button
  ///
  /// In en, this message translates to:
  /// **'Map layers'**
  String get mapLayers;

  /// Tooltip for my location button
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get myLocation;

  /// Tooltip for zoom to reports button
  ///
  /// In en, this message translates to:
  /// **'Zoom to Reports'**
  String get zoomToReports;

  /// Loading indicator when finding route
  ///
  /// In en, this message translates to:
  /// **'Finding route...'**
  String get findingRoute;

  /// Loading indicator when recalculating route
  ///
  /// In en, this message translates to:
  /// **'Rerouting...'**
  String get rerouting;

  /// Error message when route has insufficient points
  ///
  /// In en, this message translates to:
  /// **'Route was returned but contains too few points.'**
  String get routePointsTooFew;

  /// Error message when routing fails
  ///
  /// In en, this message translates to:
  /// **'Unable to find a route.'**
  String get unableToFindRoute;

  /// Error message when route loading fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load route: {error}'**
  String failedToLoadRoute(String error);

  /// Notification message upon destination arrival
  ///
  /// In en, this message translates to:
  /// **'You have arrived at your destination.'**
  String get arrivalMessage;

  /// Snackbar when rerouting due to incident
  ///
  /// In en, this message translates to:
  /// **'Road incident detected. Rerouting...'**
  String get roadIncidentRerouting;

  /// Streets map style display name
  ///
  /// In en, this message translates to:
  /// **'Streets'**
  String get mapStyleStreets;

  /// Terrain map style display name
  ///
  /// In en, this message translates to:
  /// **'Terrain'**
  String get mapStyleTerrain;

  /// Satellite map style display name
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapStyleSatellite;

  /// Label when timestamp is unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownDate;

  /// Navigate action button
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigateButton;

  /// Notice for navigation release
  ///
  /// In en, this message translates to:
  /// **'Navigation will be available in v0.5.0'**
  String get navigationFutureNotice;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// Snackbar thanking user for confirmation
  ///
  /// In en, this message translates to:
  /// **'Thanks for confirming this incident.'**
  String get incidentConfirmedMessage;

  /// Estimated time of arrival label
  ///
  /// In en, this message translates to:
  /// **'ETA'**
  String get eta;

  /// Button to start navigation mode
  ///
  /// In en, this message translates to:
  /// **'START NAVIGATION'**
  String get startNavigation;

  /// Label for next turn instruction
  ///
  /// In en, this message translates to:
  /// **'Next instruction'**
  String get nextInstruction;

  /// Default navigation instruction
  ///
  /// In en, this message translates to:
  /// **'Continue on the current route'**
  String get continueCurrentRoute;

  /// Distance remaining until next instruction
  ///
  /// In en, this message translates to:
  /// **'In {distance}'**
  String inDistance(String distance);

  /// Tooltip for ending active journey
  ///
  /// In en, this message translates to:
  /// **'End journey'**
  String get endJourney;

  /// Remaining distance/time label
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// Distance in meters
  ///
  /// In en, this message translates to:
  /// **'{count} m'**
  String distanceMeters(int count);

  /// Distance in kilometers
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String distanceKm(String distance);

  /// Duration in minutes
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String durationMin(int count);

  /// Duration in hours
  ///
  /// In en, this message translates to:
  /// **'{count} hr'**
  String durationHours(int count);

  /// Duration in hours and minutes
  ///
  /// In en, this message translates to:
  /// **'{hours} hr {minutes} min'**
  String durationHoursMinutes(int hours, int minutes);

  /// Title of report incident page
  ///
  /// In en, this message translates to:
  /// **'Report Incident'**
  String get reportIncidentTitle;

  /// Subtitle of report incident page
  ///
  /// In en, this message translates to:
  /// **'Help keep Nashik roads safer'**
  String get reportIncidentSubtitle;

  /// Heading for incident location section
  ///
  /// In en, this message translates to:
  /// **'Incident Location'**
  String get incidentLocation;

  /// Notice that location is manually chosen
  ///
  /// In en, this message translates to:
  /// **'Location selected on map'**
  String get locationSelectedOnMap;

  /// Notice that GPS location is used
  ///
  /// In en, this message translates to:
  /// **'Using your current location'**
  String get usingCurrentLocation;

  /// Button to change selected location
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocation;

  /// Button to pick location on map
  ///
  /// In en, this message translates to:
  /// **'Choose on Map'**
  String get chooseOnMap;

  /// Heading for incident details section
  ///
  /// In en, this message translates to:
  /// **'Incident Details'**
  String get incidentDetails;

  /// Field label for incident title
  ///
  /// In en, this message translates to:
  /// **'Incident Title'**
  String get incidentTitle;

  /// Placeholder hint for incident title
  ///
  /// In en, this message translates to:
  /// **'e.g. Accident near bridge'**
  String get incidentTitleHint;

  /// Validation error when title is empty
  ///
  /// In en, this message translates to:
  /// **'Enter an incident title'**
  String get incidentTitleEmptyError;

  /// Validation error when title is too short
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 3 characters'**
  String get incidentTitleMinError;

  /// Field label for optional description
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get incidentDescriptionOptional;

  /// Placeholder hint for incident description
  ///
  /// In en, this message translates to:
  /// **'Add useful details for other drivers...'**
  String get incidentDescriptionHint;

  /// Field label for incident type
  ///
  /// In en, this message translates to:
  /// **'Incident Type'**
  String get incidentType;

  /// Subtitle on incident type picker sheet
  ///
  /// In en, this message translates to:
  /// **'What is happening on the road?'**
  String get whatIsHappening;

  /// Placeholder when no incident type is selected
  ///
  /// In en, this message translates to:
  /// **'Select incident type'**
  String get selectIncidentType;

  /// Validation error when incident type missing
  ///
  /// In en, this message translates to:
  /// **'Please select an incident type'**
  String get selectIncidentTypeError;

  /// Button label during submission
  ///
  /// In en, this message translates to:
  /// **'Resolving Road & Submitting...'**
  String get resolvingRoadAndSubmitting;

  /// Button label to submit incident
  ///
  /// In en, this message translates to:
  /// **'Submit Incident'**
  String get submitIncident;

  /// Disclaimer under report submit button
  ///
  /// In en, this message translates to:
  /// **'Reports are reviewed before becoming active traffic alerts.'**
  String get reportReviewDisclaimer;

  /// Snackbar on report success
  ///
  /// In en, this message translates to:
  /// **'Incident submitted successfully.\nYour report has been sent for review.'**
  String get reportSuccessMessage;

  /// Snackbar on report error
  ///
  /// In en, this message translates to:
  /// **'Unable to submit the incident.\n{error}'**
  String reportErrorMessage(String error);

  /// Error heading when location cannot be fetched
  ///
  /// In en, this message translates to:
  /// **'Unable to get your location'**
  String get unableToGetLocation;

  /// Error banner when incident types fail to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load incident types.\n{error}'**
  String unableToLoadIncidentTypes(String error);

  /// AppBar title on location picker
  ///
  /// In en, this message translates to:
  /// **'Choose Incident Location'**
  String get chooseIncidentLocation;

  /// Tooltip to reset location to GPS
  ///
  /// In en, this message translates to:
  /// **'Reset location'**
  String get resetLocation;

  /// Instruction overlay on map picker
  ///
  /// In en, this message translates to:
  /// **'Tap the map to select the incident location'**
  String get tapMapToSelectLocation;

  /// Subtitle in location picker bottom card
  ///
  /// In en, this message translates to:
  /// **'The selected point will be attached to your report.'**
  String get selectedPointAttached;

  /// Confirmation button on location picker
  ///
  /// In en, this message translates to:
  /// **'Use This Location'**
  String get useThisLocation;

  /// Incident type Road Closed
  ///
  /// In en, this message translates to:
  /// **'Road Closed'**
  String get incidentRoadClosed;

  /// Incident type Accident
  ///
  /// In en, this message translates to:
  /// **'Accident'**
  String get incidentAccident;

  /// Incident type Construction
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get incidentConstruction;

  /// Incident type Flooding
  ///
  /// In en, this message translates to:
  /// **'Flooding'**
  String get incidentFlooding;

  /// Incident type Traffic Jam
  ///
  /// In en, this message translates to:
  /// **'Traffic Jam'**
  String get incidentTrafficJam;

  /// Incident type Pothole
  ///
  /// In en, this message translates to:
  /// **'Pothole'**
  String get incidentPothole;

  /// Incident type Public Event
  ///
  /// In en, this message translates to:
  /// **'Public Event'**
  String get incidentPublicEvent;

  /// Incident type Diversion
  ///
  /// In en, this message translates to:
  /// **'Diversion'**
  String get incidentDiversion;

  /// Incident type Other
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get incidentOther;

  /// Title of alerts page
  ///
  /// In en, this message translates to:
  /// **'Traffic Alerts'**
  String get trafficAlertsTitle;

  /// Subtitle of alerts page
  ///
  /// In en, this message translates to:
  /// **'Stay informed about incidents nearby'**
  String get trafficAlertsSubtitle;

  /// Tooltip for refresh button on alerts page
  ///
  /// In en, this message translates to:
  /// **'Refresh alerts'**
  String get refreshAlertsTooltip;

  /// Loading state on alerts page
  ///
  /// In en, this message translates to:
  /// **'Loading traffic alerts...'**
  String get loadingTrafficAlerts;

  /// Error title on alerts page
  ///
  /// In en, this message translates to:
  /// **'Unable to load alerts'**
  String get unableToLoadAlerts;

  /// Error description on alerts page
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading the latest traffic alerts.'**
  String get alertsErrorMessage;

  /// Summary count of active alerts
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active alert} other{{count} active alerts}}'**
  String activeAlertsCount(int count);

  /// Badge indicating live updates
  ///
  /// In en, this message translates to:
  /// **'Updated live'**
  String get updatedLive;

  /// Badge indicating community verification
  ///
  /// In en, this message translates to:
  /// **'Community verified'**
  String get communityVerified;

  /// Button to focus alert on map
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// Relative time: just now
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get timeJustNow;

  /// Relative time: minutes ago
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String timeMinAgo(int count);

  /// Relative time: hours ago
  ///
  /// In en, this message translates to:
  /// **'{count} hr ago'**
  String timeHrAgo(int count);

  /// Relative time: 1 day ago
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get timeDayAgo;

  /// Relative time: days ago
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String timeDaysAgo(int count);

  /// Status badge: ACTIVE
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get statusActive;

  /// Status badge: VERIFIED
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get statusVerified;

  /// Status badge: RESOLVED
  ///
  /// In en, this message translates to:
  /// **'RESOLVED'**
  String get statusResolved;

  /// Empty state title on alerts page
  ///
  /// In en, this message translates to:
  /// **'No active alerts'**
  String get noActiveAlerts;

  /// Empty state description on alerts page
  ///
  /// In en, this message translates to:
  /// **'There are no verified traffic incidents affecting the road network right now.'**
  String get noActiveAlertsDescription;

  /// Empty state reassurance pill
  ///
  /// In en, this message translates to:
  /// **'You are all clear'**
  String get youAreAllClear;

  /// Title of profile page
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// Subtitle of profile page
  ///
  /// In en, this message translates to:
  /// **'Your community activity'**
  String get profileCommunityActivity;

  /// Heading for activity stats section
  ///
  /// In en, this message translates to:
  /// **'Your Activity'**
  String get yourActivity;

  /// Subtitle for activity section
  ///
  /// In en, this message translates to:
  /// **'Your contribution to the community'**
  String get yourContribution;

  /// Stats tile label for reports
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsCountLabel;

  /// Stats tile label for active reports
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeCountLabel;

  /// Stats tile label for reputation
  ///
  /// In en, this message translates to:
  /// **'Reputation'**
  String get reputationLabel;

  /// Heading / tile label for achievements
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsLabel;

  /// Subtitle for achievements card
  ///
  /// In en, this message translates to:
  /// **'Your community milestones'**
  String get communityMilestones;

  /// Achievement badge: First Report
  ///
  /// In en, this message translates to:
  /// **'First Report'**
  String get badgeFirstReport;

  /// Achievement badge: Road Guardian
  ///
  /// In en, this message translates to:
  /// **'Road Guardian'**
  String get badgeRoadGuardian;

  /// Achievement badge: Community Helper
  ///
  /// In en, this message translates to:
  /// **'Community Helper'**
  String get badgeCommunityHelper;

  /// Heading for authority tools section
  ///
  /// In en, this message translates to:
  /// **'Authority Tools'**
  String get authorityTools;

  /// Subtitle for authority tools section
  ///
  /// In en, this message translates to:
  /// **'Tools available to authorized users'**
  String get authorityToolsSubtitle;

  /// Menu tile title for moderation page
  ///
  /// In en, this message translates to:
  /// **'Moderate Incident Reports'**
  String get moderateIncidentReports;

  /// Menu tile subtitle for moderation page
  ///
  /// In en, this message translates to:
  /// **'Review, approve, or reject pending reports'**
  String get moderateReportsSubtitle;

  /// Heading for settings section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Subtitle for settings section
  ///
  /// In en, this message translates to:
  /// **'Manage your app preferences'**
  String get manageAppPreferences;

  /// Menu tile for notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Menu tile subtitle for notifications
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get manageNotificationPreferences;

  /// Menu tile for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Menu tile for about
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Menu tile subtitle for about
  ///
  /// In en, this message translates to:
  /// **'Maarg Saarthi v4.0'**
  String get aboutAppVersion;

  /// Profile footer text
  ///
  /// In en, this message translates to:
  /// **'Maarg Saarthi • Nashik'**
  String get footerNashik;

  /// Error title on profile page
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get unableToLoadProfile;

  /// Error message on profile page
  ///
  /// In en, this message translates to:
  /// **'We could not load your profile information.'**
  String get unableToLoadProfileMessage;

  /// Badge for authority account
  ///
  /// In en, this message translates to:
  /// **'Authority account'**
  String get authorityAccount;

  /// Badge for community member
  ///
  /// In en, this message translates to:
  /// **'Community member'**
  String get communityMember;

  /// Logout button label
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Snackbar when logout fails
  ///
  /// In en, this message translates to:
  /// **'Logout failed\n{error}'**
  String logoutFailed(String error);

  /// AppBar title on moderation page
  ///
  /// In en, this message translates to:
  /// **'Incident Moderation'**
  String get incidentModerationTitle;

  /// AppBar subtitle on moderation page
  ///
  /// In en, this message translates to:
  /// **'Review community reports'**
  String get incidentModerationSubtitle;

  /// Section header for pending reports
  ///
  /// In en, this message translates to:
  /// **'Pending Reports'**
  String get pendingReports;

  /// Subtitle for pending reports
  ///
  /// In en, this message translates to:
  /// **'Awaiting authority review'**
  String get pendingReportsSubtitle;

  /// Section header for active incidents
  ///
  /// In en, this message translates to:
  /// **'Active Incidents'**
  String get activeIncidents;

  /// Subtitle for active incidents
  ///
  /// In en, this message translates to:
  /// **'Currently affecting road routing'**
  String get activeIncidentsSubtitle;

  /// Empty state title for pending reports
  ///
  /// In en, this message translates to:
  /// **'No pending reports'**
  String get noPendingReports;

  /// Empty state subtitle for pending reports
  ///
  /// In en, this message translates to:
  /// **'New community reports will appear here.'**
  String get noPendingReportsSubtitle;

  /// Empty state title for active incidents
  ///
  /// In en, this message translates to:
  /// **'No active incidents'**
  String get noActiveIncidents;

  /// Empty state subtitle for active incidents
  ///
  /// In en, this message translates to:
  /// **'All verified incidents are currently resolved.'**
  String get noActiveIncidentsSubtitle;

  /// Error title for pending reports
  ///
  /// In en, this message translates to:
  /// **'Pending reports unavailable'**
  String get pendingReportsUnavailable;

  /// Error title for active incidents
  ///
  /// In en, this message translates to:
  /// **'Active incidents unavailable'**
  String get activeIncidentsUnavailable;

  /// OSM Way label
  ///
  /// In en, this message translates to:
  /// **'OSM Way'**
  String get osmWay;

  /// Label when OSM Way is not assigned
  ///
  /// In en, this message translates to:
  /// **'Not assigned'**
  String get notAssigned;

  /// Reject button label
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Approve button label
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Resolve incident button label
  ///
  /// In en, this message translates to:
  /// **'Resolve Incident'**
  String get resolveIncident;

  /// Dialog title for approving incident
  ///
  /// In en, this message translates to:
  /// **'Approve incident?'**
  String get approveIncidentTitle;

  /// Dialog body for approving incident
  ///
  /// In en, this message translates to:
  /// **'Approve \"{title}\" and make this incident available to the routing system?'**
  String approveIncidentMessage(String title);

  /// Snackbar on incident approval
  ///
  /// In en, this message translates to:
  /// **'Incident report approved.'**
  String get incidentApprovedMessage;

  /// Snackbar when approval fails
  ///
  /// In en, this message translates to:
  /// **'Approval failed: {error}'**
  String approvalFailedMessage(String error);

  /// Dialog title for rejecting incident
  ///
  /// In en, this message translates to:
  /// **'Reject incident?'**
  String get rejectIncidentTitle;

  /// Dialog body for rejecting incident
  ///
  /// In en, this message translates to:
  /// **'Reject \"{title}\"? This report will not be activated for routing.'**
  String rejectIncidentMessage(String title);

  /// Snackbar on incident rejection
  ///
  /// In en, this message translates to:
  /// **'Incident report rejected.'**
  String get incidentRejectedMessage;

  /// Snackbar when rejection fails
  ///
  /// In en, this message translates to:
  /// **'Rejection failed: {error}'**
  String rejectionFailedMessage(String error);

  /// Dialog title for resolving incident
  ///
  /// In en, this message translates to:
  /// **'Resolve incident?'**
  String get resolveIncidentTitle;

  /// Dialog body for resolving incident
  ///
  /// In en, this message translates to:
  /// **'Mark \"{title}\" as completed and remove its road restriction from active routing?'**
  String resolveIncidentMessage(String title);

  /// Snackbar on incident resolution
  ///
  /// In en, this message translates to:
  /// **'Incident resolved and road restriction removed.'**
  String get incidentResolvedMessage;

  /// Snackbar when resolution fails
  ///
  /// In en, this message translates to:
  /// **'Resolution failed: {error}'**
  String resolutionFailedMessage(String error);

  /// Tagline on login and about screen
  ///
  /// In en, this message translates to:
  /// **'Community Powered Smart Navigation'**
  String get smartNavigationSubtitle;

  /// Login hero description
  ///
  /// In en, this message translates to:
  /// **'Navigate smarter with live road information and community-powered alerts.'**
  String get loginTaglineDescription;

  /// Feature highlight: Live Traffic
  ///
  /// In en, this message translates to:
  /// **'Live Traffic'**
  String get liveTraffic;

  /// Feature highlight: Smart Routes
  ///
  /// In en, this message translates to:
  /// **'Smart Routes'**
  String get smartRoutes;

  /// Login sign-in card header
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// Login sign-in card subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your personalized map experience.'**
  String get signInSubtitle;

  /// Google sign-in button label
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Login helper note
  ///
  /// In en, this message translates to:
  /// **'Secure sign-in with Google'**
  String get secureSignInGoogle;

  /// Login terms footnote
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to use the app responsibly.'**
  String get termsNotice;

  /// AppBar title on notifications page
  ///
  /// In en, this message translates to:
  /// **'Stay informed'**
  String get stayInformed;

  /// AppBar subtitle on notifications page
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// Master switch label for push notifications
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// Master switch subtitle for notifications
  ///
  /// In en, this message translates to:
  /// **'Receive important notifications from Maarg Saarthi.'**
  String get pushNotificationsDescription;

  /// Section header on notifications page
  ///
  /// In en, this message translates to:
  /// **'Notification Types'**
  String get notificationTypes;

  /// Setting tile for nearby road alerts
  ///
  /// In en, this message translates to:
  /// **'Nearby Road Alerts'**
  String get nearbyRoadAlerts;

  /// Setting description for nearby alerts
  ///
  /// In en, this message translates to:
  /// **'Get alerts about incidents and road conditions near you.'**
  String get nearbyRoadAlertsDescription;

  /// Setting tile for route updates
  ///
  /// In en, this message translates to:
  /// **'Route Updates'**
  String get routeUpdates;

  /// Setting description for route updates
  ///
  /// In en, this message translates to:
  /// **'Be notified when your active route needs to change.'**
  String get routeUpdatesDescription;

  /// Setting tile for community reports
  ///
  /// In en, this message translates to:
  /// **'Community Reports'**
  String get communityReportsNotification;

  /// Setting description for community reports
  ///
  /// In en, this message translates to:
  /// **'Receive updates related to community-reported incidents.'**
  String get communityReportsNotificationDescription;

  /// Info box in notifications settings
  ///
  /// In en, this message translates to:
  /// **'Notification preferences currently apply to this session. Persistent notification preferences will be added in a future update.'**
  String get notificationSessionNotice;

  /// Footer text on notifications settings
  ///
  /// In en, this message translates to:
  /// **'Maarg Saarthi • Notification Settings'**
  String get notificationFooter;

  /// Subtitle on language selection page
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get choosePreferredLanguage;

  /// Heading for current language card
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// Heading for available languages list
  ///
  /// In en, this message translates to:
  /// **'Available Languages'**
  String get availableLanguages;

  /// Button to save selected language
  ///
  /// In en, this message translates to:
  /// **'Save {language}'**
  String saveLanguage(String language);

  /// Snackbar confirming saved language
  ///
  /// In en, this message translates to:
  /// **'{language} selected.'**
  String languageSelectedSnackbar(String language);

  /// Notice at bottom of language page
  ///
  /// In en, this message translates to:
  /// **'More regional Indian languages will be available in future updates.'**
  String get languageFutureNotice;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Hindi language name
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// Marathi language name
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get languageMarathi;

  /// Version and build badge text
  ///
  /// In en, this message translates to:
  /// **'Version {version} • Build {build}'**
  String appVersionBuild(String version, String build);

  /// Heading for project overview in about page
  ///
  /// In en, this message translates to:
  /// **'About the Project'**
  String get aboutTheProject;

  /// Organization name
  ///
  /// In en, this message translates to:
  /// **'HLP - Hibro Lab Productions'**
  String get hlpName;

  /// Full description of project
  ///
  /// In en, this message translates to:
  /// **'Maarg Saarthi is a community-powered navigation platform designed to provide real-time road conditions, road closures, traffic incidents and intelligent route guidance using community reports and modern mapping technologies.'**
  String get aboutProjectDescription;

  /// Heading for team section in about page
  ///
  /// In en, this message translates to:
  /// **'Development Team'**
  String get developmentTeam;

  /// Role: Project Guide
  ///
  /// In en, this message translates to:
  /// **'Project Guide'**
  String get roleProjectGuide;

  /// Role: Lead Developer
  ///
  /// In en, this message translates to:
  /// **'Lead Developer'**
  String get roleLeadDeveloper;

  /// Role: Project Documentation
  ///
  /// In en, this message translates to:
  /// **'Project Documentation'**
  String get roleDocumentation;

  /// Role: Research & Field Validation
  ///
  /// In en, this message translates to:
  /// **'Research & Field Validation'**
  String get roleResearchValidation;

  /// Heading for tech stack in about page
  ///
  /// In en, this message translates to:
  /// **'Technology Stack'**
  String get technologyStack;

  /// Technology category: Framework
  ///
  /// In en, this message translates to:
  /// **'Framework'**
  String get techFramework;

  /// Technology category: Backend
  ///
  /// In en, this message translates to:
  /// **'Backend'**
  String get techBackend;

  /// Technology category: Maps
  ///
  /// In en, this message translates to:
  /// **'Maps'**
  String get techMaps;

  /// Technology category: Routing
  ///
  /// In en, this message translates to:
  /// **'Routing'**
  String get techRouting;

  /// Technology category: Programming Language
  ///
  /// In en, this message translates to:
  /// **'Programming Language'**
  String get techLanguage;

  /// Core feature: Incident Reporting
  ///
  /// In en, this message translates to:
  /// **'Community Incident Reporting'**
  String get featureReporting;

  /// Core feature: Traffic Alerts
  ///
  /// In en, this message translates to:
  /// **'Real-Time Traffic Alerts'**
  String get featureTrafficAlerts;

  /// Core feature: Road Closure Detection
  ///
  /// In en, this message translates to:
  /// **'Road Closure Detection'**
  String get featureRoadClosure;

  /// Core feature: Smart Route Navigation
  ///
  /// In en, this message translates to:
  /// **'Smart Route Navigation'**
  String get featureSmartRouting;

  /// Core feature: Community Verification
  ///
  /// In en, this message translates to:
  /// **'Community Verification'**
  String get featureCommunityVerification;

  /// Core feature: User Profiles
  ///
  /// In en, this message translates to:
  /// **'User Profiles & Statistics'**
  String get featureUserProfiles;

  /// Heading for project metadata
  ///
  /// In en, this message translates to:
  /// **'Project Information'**
  String get projectInformation;

  /// Label for project status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Value: Active Development
  ///
  /// In en, this message translates to:
  /// **'Active Development'**
  String get statusActiveDevelopment;

  /// Label for publisher
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisherLabel;

  /// Label for license
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get licenseLabel;

  /// Value: Educational & Research Project
  ///
  /// In en, this message translates to:
  /// **'Educational & Research Project'**
  String get licenseEducational;

  /// Heading for support section
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// Button to report bug
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get reportBug;

  /// Button to contact developer
  ///
  /// In en, this message translates to:
  /// **'Contact Developer'**
  String get contactDeveloper;

  /// Dialog title for report bug
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get reportBugDialogTitle;

  /// Dialog body for report bug
  ///
  /// In en, this message translates to:
  /// **'Bug reporting portal will be available in a future update.\n\nFor now, you can report bugs directly to the developer using the Contact Developer option.'**
  String get reportBugDialogContent;

  /// Snackbar when email app cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Unable to open email application.'**
  String get unableOpenEmail;

  /// HLP summary card body
  ///
  /// In en, this message translates to:
  /// **'Maarg Saarthi is a product developed and maintained by HLP - Hibro Lab Productions.'**
  String get hlpDescription;

  /// Heading for developer contact
  ///
  /// In en, this message translates to:
  /// **'Developer Contact'**
  String get developerContact;

  /// Copyright notice in about page
  ///
  /// In en, this message translates to:
  /// **'© 2026 HLP - Hibro Lab Productions'**
  String get copyrightNotice;

  /// Rights reserved note
  ///
  /// In en, this message translates to:
  /// **'All Rights Reserved.'**
  String get allRightsReserved;

  /// Notification channel name
  ///
  /// In en, this message translates to:
  /// **'Maarg Saarthi'**
  String get notificationGeneralName;

  /// Notification channel description
  ///
  /// In en, this message translates to:
  /// **'Navigation, route, and road alert notifications.'**
  String get notificationGeneralDescription;

  /// Body for test notification
  ///
  /// In en, this message translates to:
  /// **'Notifications are working successfully!'**
  String get notificationTestBody;

  /// Title for journey started notification
  ///
  /// In en, this message translates to:
  /// **'Journey Started'**
  String get notificationJourneyStartedTitle;

  /// Body for journey started notification
  ///
  /// In en, this message translates to:
  /// **'Navigation has started.'**
  String get notificationJourneyStartedBody;

  /// Title for journey completed notification
  ///
  /// In en, this message translates to:
  /// **'Journey Completed'**
  String get notificationJourneyCompletedTitle;

  /// Body for journey completed notification
  ///
  /// In en, this message translates to:
  /// **'You have reached your destination.'**
  String get notificationJourneyCompletedBody;

  /// Title for route updated notification
  ///
  /// In en, this message translates to:
  /// **'Route Updated'**
  String get notificationRouteUpdatedTitle;

  /// Body for route updated notification
  ///
  /// In en, this message translates to:
  /// **'Your route has been updated because of a road event.'**
  String get notificationRouteUpdatedBody;

  /// Home page placeholder when logged out
  ///
  /// In en, this message translates to:
  /// **'No User Logged In'**
  String get noUserLoggedIn;

  /// Home page greeting with email
  ///
  /// In en, this message translates to:
  /// **'Welcome\n\n{email}'**
  String welcomeUser(String email);

  /// No description provided for @singleActiveAlert.
  ///
  /// In en, this message translates to:
  /// **'1 active alert'**
  String get singleActiveAlert;

  /// No description provided for @multipleActiveAlerts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {No active alerts} =1 {1 active alert} other {{count} active alerts}}'**
  String multipleActiveAlerts(num count);

  /// No description provided for @somethingWentWrongAlerts.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading traffic alerts.'**
  String get somethingWentWrongAlerts;

  /// No description provided for @arrivedAtDestinationSnackbar.
  ///
  /// In en, this message translates to:
  /// **'You have arrived at your destination.'**
  String get arrivedAtDestinationSnackbar;

  /// No description provided for @communityReporterFallback.
  ///
  /// In en, this message translates to:
  /// **'Community member'**
  String get communityReporterFallback;

  /// No description provided for @navigationAvailableSoon.
  ///
  /// In en, this message translates to:
  /// **'Navigation for this incident will be available soon.'**
  String get navigationAvailableSoon;

  /// No description provided for @thanksForConfirming.
  ///
  /// In en, this message translates to:
  /// **'Thanks for confirming this incident.'**
  String get thanksForConfirming;

  /// No description provided for @continueOnCurrentRoute.
  ///
  /// In en, this message translates to:
  /// **'Continue on current route'**
  String get continueOnCurrentRoute;

  /// No description provided for @statReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get statReports;

  /// No description provided for @statActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statActive;

  /// No description provided for @statReputation.
  ///
  /// In en, this message translates to:
  /// **'Reputation'**
  String get statReputation;

  /// No description provided for @statAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get statAchievements;

  /// No description provided for @appTitleWithCity.
  ///
  /// In en, this message translates to:
  /// **'Maarg Saarthi • Nashik'**
  String get appTitleWithCity;

  /// No description provided for @couldNotLoadProfileInfo.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile information.'**
  String get couldNotLoadProfileInfo;

  /// No description provided for @achievementFirstReport.
  ///
  /// In en, this message translates to:
  /// **'First Report'**
  String get achievementFirstReport;

  /// No description provided for @achievementRoadGuardian.
  ///
  /// In en, this message translates to:
  /// **'Road Guardian'**
  String get achievementRoadGuardian;

  /// No description provided for @achievementCommunityHelper.
  ///
  /// In en, this message translates to:
  /// **'Community Helper'**
  String get achievementCommunityHelper;

  /// No description provided for @unableToOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'Unable to open email.'**
  String get unableToOpenEmail;

  /// No description provided for @reportBugContent.
  ///
  /// In en, this message translates to:
  /// **'If you found a problem with the app, please describe it and send us the details.'**
  String get reportBugContent;

  /// No description provided for @coreFeatures.
  ///
  /// In en, this message translates to:
  /// **'Core Features'**
  String get coreFeatures;

  /// No description provided for @featureIncidentReporting.
  ///
  /// In en, this message translates to:
  /// **'Incident Reporting'**
  String get featureIncidentReporting;

  /// No description provided for @featureSmartNavigation.
  ///
  /// In en, this message translates to:
  /// **'Smart Navigation'**
  String get featureSmartNavigation;

  /// No description provided for @versionBuildSummary.
  ///
  /// In en, this message translates to:
  /// **'Version {appVersion} ? Build {buildNumber}'**
  String versionBuildSummary(Object appVersion, Object buildNumber);

  /// No description provided for @languageChangedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}.'**
  String languageChangedSnackbar(Object language);

  /// No description provided for @saveLanguageButton.
  ///
  /// In en, this message translates to:
  /// **'Save {language}'**
  String saveLanguageButton(Object language);

  /// No description provided for @languageAppliesInstantly.
  ///
  /// In en, this message translates to:
  /// **'Language changes apply instantly throughout the app.'**
  String get languageAppliesInstantly;

  /// No description provided for @notificationPreferencesFootnote.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences are currently applied for this session.'**
  String get notificationPreferencesFootnote;

  /// No description provided for @notificationSettingsSummary.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences for road alerts and community updates.'**
  String get notificationSettingsSummary;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
