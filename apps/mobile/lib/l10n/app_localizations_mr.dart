// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appTitle => 'द मॅप प्रोजेक्ट';

  @override
  String get appTagline => 'रिअल-टाईम रस्ता माहिती';

  @override
  String get ok => 'ठीक आहे';

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'जतन करा';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String get close => 'बंद करा';

  @override
  String get back => 'मागे';

  @override
  String get status => 'स्थिती';

  @override
  String get distance => 'अंतर';

  @override
  String get reporter => 'रिपोर्टर';

  @override
  String get reported => 'नोंदवलेली वेळ';

  @override
  String get location => 'स्थान';

  @override
  String get latitude => 'अक्षांश';

  @override
  String get longitude => 'रेखांश';

  @override
  String get community => 'समुदाय';

  @override
  String get nashik => 'नाशिक';

  @override
  String get navMap => 'नकाशा';

  @override
  String get navReport => 'रिपोर्ट';

  @override
  String get navAlerts => 'सूचना';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get searchDestinationHint => 'गंतव्य शोधा...';

  @override
  String get clearSearch => 'शोध साफ करा';

  @override
  String get mapLayers => 'नकाशा स्तर';

  @override
  String get myLocation => 'माझे स्थान';

  @override
  String get zoomToReports => 'अहवालांवर झूम करा';

  @override
  String get findingRoute => 'मार्ग शोधत आहे...';

  @override
  String get rerouting => 'नवीन मार्ग शोधत आहे...';

  @override
  String get routePointsTooFew => 'मार्ग मिळाला परंतु त्यात अपुरे बिंदू आहेत.';

  @override
  String get unableToFindRoute => 'मार्ग शोधण्यात अयशस्वी.';

  @override
  String failedToLoadRoute(String error) {
    return 'मार्ग लोड करण्यात अयशस्वी: $error';
  }

  @override
  String get arrivalMessage => 'तुम्ही तुमच्या गंतव्यस्थानी पोहोचला आहात.';

  @override
  String get roadIncidentRerouting =>
      'रस्त्यावरील अडथळा आढळला. नवीन मार्ग आखला जात आहे...';

  @override
  String get mapStyleStreets => 'रस्ते';

  @override
  String get mapStyleTerrain => 'भूप्रदेश';

  @override
  String get mapStyleSatellite => 'उपग्रह';

  @override
  String get unknownDate => 'अज्ञात';

  @override
  String get navigateButton => 'दिशा-दर्शन';

  @override
  String get navigationFutureNotice => 'नेव्हिगेशन v0.5.0 मध्ये उपलब्ध होईल';

  @override
  String get confirmButton => 'पुष्टी करा';

  @override
  String get incidentConfirmedMessage => 'घटनेची पुष्टी केल्याबद्दल धन्यवाद';

  @override
  String get eta => 'अंदाजे वेळ';

  @override
  String get startNavigation => 'नेव्हिगेशन सुरू करा';

  @override
  String get nextInstruction => 'पुढील वळण / सूचना';

  @override
  String get continueCurrentRoute => 'सध्याच्या मार्गावर पुढे जा';

  @override
  String inDistance(String distance) {
    return '$distance मध्ये';
  }

  @override
  String get endJourney => 'प्रवास समाप्त करा';

  @override
  String get remaining => 'उर्वरित';

  @override
  String distanceMeters(int count) {
    return '$count मी';
  }

  @override
  String distanceKm(String distance) {
    return '$distance किमी';
  }

  @override
  String durationMin(int count) {
    return '$count मिनिटे';
  }

  @override
  String durationHours(int count) {
    return '$count तास';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours तास $minutes मिनिटे';
  }

  @override
  String get reportIncidentTitle => 'घटनेची नोंद करा';

  @override
  String get reportIncidentSubtitle =>
      'नाशिकचे रस्ते सुरक्षित ठेवण्यास मदत करा';

  @override
  String get incidentLocation => 'घटनेचे स्थान';

  @override
  String get locationSelectedOnMap => 'नकाशावर निवडलेले स्थान';

  @override
  String get usingCurrentLocation => 'तुमचे सध्याचे स्थान वापरत आहे';

  @override
  String get changeLocation => 'स्थान बदला';

  @override
  String get chooseOnMap => 'नकाशावर निवडा';

  @override
  String get incidentDetails => 'घटनेचा तपशील';

  @override
  String get incidentTitle => 'घटनेचे शीर्षक';

  @override
  String get incidentTitleHint => 'उदा. पुलाजवळ अपघात';

  @override
  String get incidentTitleEmptyError => 'घटनेचे शीर्षक प्रविष्ट करा';

  @override
  String get incidentTitleMinError => 'शीर्षक किमान ३ अक्षरांचे असावे';

  @override
  String get incidentDescriptionOptional => 'तपशील (पर्यायी)';

  @override
  String get incidentDescriptionHint =>
      'इतर वाहनचालकांसाठी उपयुक्त माहिती जोडा...';

  @override
  String get incidentType => 'घटनेचा प्रकार';

  @override
  String get whatIsHappening => 'रस्त्यावर काय अडचण आहे?';

  @override
  String get selectIncidentType => 'घटनेचा प्रकार निवडा';

  @override
  String get selectIncidentTypeError => 'कृपया घटनेचा प्रकार निवडा';

  @override
  String get resolvingRoadAndSubmitting =>
      'रस्ता पडताळून अहवाल पाठवला जात आहे...';

  @override
  String get submitIncident => 'घटना नोंदवा';

  @override
  String get reportReviewDisclaimer =>
      'सक्रिय वाहतूक सूचना होण्यापूर्वी अहवालांचे पुनरावलोकन केले जाते.';

  @override
  String get reportSuccessMessage =>
      'घटना यशस्वीरित्या नोंदवली गेली.\nतुमचा अहवाल पुनरावलोकनासाठी पाठवला आहे.';

  @override
  String reportErrorMessage(String error) {
    return 'घटना नोंदवण्यात अयशस्वी.\n$error';
  }

  @override
  String get unableToGetLocation => 'तुमचे स्थान मिळवण्यात अयशस्वी';

  @override
  String unableToLoadIncidentTypes(String error) {
    return 'घटनेचे प्रकार लोड करण्यात अयशस्वी.\n$error';
  }

  @override
  String get chooseIncidentLocation => 'घटनेचे स्थान निवडा';

  @override
  String get resetLocation => 'स्थान रिसेट करा';

  @override
  String get tapMapToSelectLocation =>
      'घटनेचे स्थान निवडण्यासाठी नकाशावर टॅप करा';

  @override
  String get selectedPointAttached => 'निवडलेले स्थान अहवालासोबत जोडले आहे';

  @override
  String get useThisLocation => 'हे स्थान वापरा';

  @override
  String get incidentRoadClosed => 'रस्ता बंद';

  @override
  String get incidentAccident => 'अपघात';

  @override
  String get incidentConstruction => 'बांधकाम कार्य';

  @override
  String get incidentFlooding => 'पूर / पाणी साचले';

  @override
  String get incidentTrafficJam => 'वाहतूक कोंडी';

  @override
  String get incidentPothole => 'खड्डा';

  @override
  String get incidentPublicEvent => 'सार्वजनिक कार्यक्रम';

  @override
  String get incidentDiversion => 'वळण रस्ता (डायव्हर्जन)';

  @override
  String get incidentOther => 'इतर';

  @override
  String get trafficAlertsTitle => 'वाहतूक सूचना';

  @override
  String get trafficAlertsSubtitle => 'परिसरातील घटनांची माहिती मिळवा';

  @override
  String get refreshAlertsTooltip => 'सूचना रिफ्रेश करा';

  @override
  String get loadingTrafficAlerts => 'वाहतूक सूचना लोड होत आहेत...';

  @override
  String get unableToLoadAlerts => 'सूचना लोड करण्यात अयशस्वी';

  @override
  String get alertsErrorMessage => 'नवीनतम वाहतूक सूचना लोड करताना समस्या आली.';

  @override
  String activeAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय सूचना',
      one: '1 सक्रिय सूचना',
    );
    return '$_temp0';
  }

  @override
  String get updatedLive => 'थेट अपडेट';

  @override
  String get communityVerified => 'समुदायाने पडताळलेले';

  @override
  String get viewOnMap => 'नकाशावर पहा';

  @override
  String get timeJustNow => 'आत्ताच';

  @override
  String timeMinAgo(int count) {
    return '$count मिनिटांपूर्वी';
  }

  @override
  String timeHrAgo(int count) {
    return '$count तासांपूर्वी';
  }

  @override
  String get timeDayAgo => '१ दिवसापूर्वी';

  @override
  String timeDaysAgo(int count) {
    return '$count दिवसांपूर्वी';
  }

  @override
  String get statusActive => 'सक्रिय';

  @override
  String get statusVerified => 'पडताळलेले';

  @override
  String get statusResolved => 'निवारण झालेले';

  @override
  String get noActiveAlerts => 'कोणतीही सक्रिय सूचना नाही';

  @override
  String get noActiveAlertsDescription =>
      'सध्या रस्ते वाहतुकीवर परिणाम करणारी कोणतीही सत्यापित घटना नाही.';

  @override
  String get youAreAllClear => 'सर्व रस्ते सुरळीत आहेत';

  @override
  String get profileTitle => 'प्रोफाइल';

  @override
  String get profileCommunityActivity => 'तुमची समुदायातील क्रिया';

  @override
  String get yourActivity => 'तुमची कामगिरी';

  @override
  String get yourContribution => 'समुदायासाठी तुमचे योगदान';

  @override
  String get reportsCountLabel => 'अहवाल';

  @override
  String get activeCountLabel => 'सक्रिय';

  @override
  String get reputationLabel => 'प्रतिष्ठा';

  @override
  String get achievementsLabel => 'यश / गौरव';

  @override
  String get communityMilestones => 'तुमचे समुदायातील टप्पे';

  @override
  String get badgeFirstReport => 'पहिला अहवाल';

  @override
  String get badgeRoadGuardian => 'रस्ता संरक्षक';

  @override
  String get badgeCommunityHelper => 'समुदाय मदतनीस';

  @override
  String get authorityTools => 'अधिकार साधनसामग्री';

  @override
  String get authorityToolsSubtitle => 'अधिकृत वापरकर्त्यांसाठी साधने';

  @override
  String get moderateIncidentReports => 'घटना अहवाल व्यवस्थापन';

  @override
  String get moderateReportsSubtitle =>
      'प्रलंबित अहवालांचे पुनरावलोकन, मंजुरी किंवा नकार';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get manageAppPreferences => 'ॲप प्राधान्ये व्यवस्थापित करा';

  @override
  String get notifications => 'सूचना (नोटिफिकेशन्स)';

  @override
  String get manageNotificationPreferences =>
      'सूचना प्राधान्ये व्यवस्थापित करा';

  @override
  String get language => 'भाषा';

  @override
  String get about => 'ॲपबद्दल माहिती';

  @override
  String get aboutAppVersion => 'द मॅप प्रोजेक्ट v2.0';

  @override
  String get footerNashik => 'द मॅप प्रोजेक्ट • नाशिक';

  @override
  String get unableToLoadProfile => 'प्रोफाइल लोड करण्यात अयशस्वी';

  @override
  String get unableToLoadProfileMessage =>
      'आम्ही तुमची प्रोफाइल माहिती मिळवू शकलो नाही.';

  @override
  String get authorityAccount => 'प्राधिकृत खाते';

  @override
  String get communityMember => 'समुदाय सदस्य';

  @override
  String get logout => 'बाहेर पडा (लॉग आउट)';

  @override
  String logoutFailed(String error) {
    return 'लॉग आउट अयशस्वी\n$error';
  }

  @override
  String get incidentModerationTitle => 'घटना व्यवस्थापन';

  @override
  String get incidentModerationSubtitle => 'समुदाय अहवालांचे पुनरावलोकन करा';

  @override
  String get pendingReports => 'प्रलंबित अहवाल';

  @override
  String get pendingReportsSubtitle => 'अधिकृत मंजुरीची प्रतीक्षा';

  @override
  String get activeIncidents => 'सक्रिय घटना';

  @override
  String get activeIncidentsSubtitle => 'सध्या रस्ते वाहतुकीवर परिणाम करत आहेत';

  @override
  String get noPendingReports => 'कोणताही प्रलंबित अहवाल नाही';

  @override
  String get noPendingReportsSubtitle => 'नवीन समुदाय अहवाल येथे दिसतील.';

  @override
  String get noActiveIncidents => 'कोणतीही सक्रिय घटना नाही';

  @override
  String get noActiveIncidentsSubtitle =>
      'सर्व पडताळलेल्या घटनांचे निवारण झाले आहे.';

  @override
  String get pendingReportsUnavailable => 'प्रलंबित अहवाल अनुपलब्ध';

  @override
  String get activeIncidentsUnavailable => 'सक्रिय घटना अनुपलब्ध';

  @override
  String get osmWay => 'OSM वे आयडी';

  @override
  String get notAssigned => 'नियुक्त नाही';

  @override
  String get reject => 'नाकारा';

  @override
  String get approve => 'मंजूर करा';

  @override
  String get resolveIncident => 'घटना निवारण घोषित करा';

  @override
  String get approveIncidentTitle => 'घटना मंजूर करायची?';

  @override
  String approveIncidentMessage(String title) {
    return '\"$title\" मंजूर करून ही घटना रूटिंग प्रणालीसाठी सक्रिय करायची का?';
  }

  @override
  String get incidentApprovedMessage => 'घटना अहवाल मंजूर केला.';

  @override
  String approvalFailedMessage(String error) {
    return 'मंजुरी अयशस्वी: $error';
  }

  @override
  String get rejectIncidentTitle => 'घटना नाकारायची?';

  @override
  String rejectIncidentMessage(String title) {
    return '\"$title\" नाकारायची का? हा अहवाल रूटिंगसाठी सक्रिय केला जाणार नाही.';
  }

  @override
  String get incidentRejectedMessage => 'घटना अहवाल नाकारला.';

  @override
  String rejectionFailedMessage(String error) {
    return 'नकार अयशस्वी: $error';
  }

  @override
  String get resolveIncidentTitle => 'घटनेचे निवारण करायचे?';

  @override
  String resolveIncidentMessage(String title) {
    return '\"$title\" पूर्ण झाल्याची नोंद करून सक्रिय रूटिंगमधून रस्त्यावरील अडथळा काढायचा का?';
  }

  @override
  String get incidentResolvedMessage =>
      'घटनेचे निवारण झाले आणि रस्ता खुला झाला.';

  @override
  String resolutionFailedMessage(String error) {
    return 'निवारण अयशस्वी: $error';
  }

  @override
  String get smartNavigationSubtitle => 'समुदाय संचलित स्मार्ट नेव्हिगेशन';

  @override
  String get loginTaglineDescription =>
      'थेट रस्ता माहिती आणि समुदाय सूचनांसह अधिक हुशारीने प्रवास करा.';

  @override
  String get liveTraffic => 'थेट वाहतूक';

  @override
  String get smartRoutes => 'स्मार्ट मार्ग';

  @override
  String get getStarted => 'सुरू करा';

  @override
  String get signInSubtitle =>
      'तुमच्या वैयक्तिकृत नकाशा अनुभवासाठी साइन इन करा.';

  @override
  String get continueWithGoogle => 'Google सह पुढे जा';

  @override
  String get secureSignInGoogle => 'Google सह सुरक्षित साइन-इन';

  @override
  String get termsNotice =>
      'पुढे जाऊन, तुम्ही ॲप जबाबदारीने वापरण्यास सहमती दर्शवता.';

  @override
  String get stayInformed => 'माहिती मिळवत राहा';

  @override
  String get notificationSettings => 'सूचना सेटिंग्ज';

  @override
  String get pushNotifications => 'पुश नोटिफिकेशन्स';

  @override
  String get pushNotificationsDescription => 'महत्त्वाच्या सूचना मिळवा';

  @override
  String get notificationTypes => 'सूचनांचे प्रकार';

  @override
  String get nearbyRoadAlerts => 'परिसरातील रस्ता सूचना';

  @override
  String get nearbyRoadAlertsDescription =>
      'जवळच्या रस्त्यावरील घटनांची माहिती मिळवा';

  @override
  String get routeUpdates => 'मार्ग अपडेट्स';

  @override
  String get routeUpdatesDescription => 'मार्गातील बदलांची माहिती मिळवा';

  @override
  String get communityReportsNotification => 'समुदाय अहवाल';

  @override
  String get communityReportsNotificationDescription =>
      'समुदाय अहवालांशी संबंधित सूचना मिळवा';

  @override
  String get notificationSessionNotice =>
      'या सेटिंग्ज सध्याच्या सत्रासाठी लागू आहेत';

  @override
  String get notificationFooter => 'तुमची सूचना प्राधान्ये येथे दिसतील';

  @override
  String get choosePreferredLanguage => 'तुमची पसंतीची भाषा निवडा';

  @override
  String get currentLanguage => 'सध्याची भाषा';

  @override
  String get availableLanguages => 'उपलब्ध भाषा';

  @override
  String saveLanguage(String language) {
    return 'भाषा जतन करा';
  }

  @override
  String languageSelectedSnackbar(String language) {
    return 'निवडलेली भाषा: $language';
  }

  @override
  String get languageFutureNotice =>
      'भविष्यातील अपडेट्समध्ये अधिक प्रादेशिक भारतीय भाषा उपलब्ध केल्या जातील.';

  @override
  String get languageEnglish => 'English (इंग्रजी)';

  @override
  String get languageHindi => 'हिन्दी (हिंदी)';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String appVersionBuild(String version, String build) {
    return 'आवृत्ती $version • बिल्ड $build';
  }

  @override
  String get aboutTheProject => 'प्रकल्पाविषयी माहिती';

  @override
  String get hlpName => 'HLP - हिब्रो लॅब प्रॉडक्शन्स';

  @override
  String get aboutProjectDescription =>
      'द मॅप प्रोजेक्ट हे एक समुदाय-संचलित नेव्हिगेशन प्लॅटफॉर्म आहे जे रिअल-टाइम रस्त्यांची स्थिती, बंद रस्ते, वाहतूक कोंडी आणि आधुनिक मॅपिंग तंत्रज्ञान व समुदाय अहवालांचा वापर करून मार्ग मार्गदर्शन प्रदान करण्यासाठी विकसित केले गेले आहे.';

  @override
  String get developmentTeam => 'विकास कार्यसंघ';

  @override
  String get roleProjectGuide => 'प्रकल्प मार्गदर्शक';

  @override
  String get roleLeadDeveloper => 'मुख्य विकासक (लीड डेव्हलपर)';

  @override
  String get roleDocumentation => 'प्रकल्प दस्तऐवजीकरण';

  @override
  String get roleResearchValidation => 'संशोधन आणि प्रत्यक्ष पडताळणी';

  @override
  String get technologyStack => 'तंत्रज्ञान स्टॅक';

  @override
  String get techFramework => 'फ्रेमवर्क';

  @override
  String get techBackend => 'बॅकएंड';

  @override
  String get techMaps => 'नकाशे';

  @override
  String get techRouting => 'रूटिंग';

  @override
  String get techLanguage => 'प्रोग्रॅमिंग लँग्वेज';

  @override
  String get featureReporting => 'घटना अहवाल';

  @override
  String get featureTrafficAlerts => 'रिअल-टाइम वाहतूक सूचना';

  @override
  String get featureRoadClosure => 'बंद रस्त्यांचा शोध';

  @override
  String get featureSmartRouting => 'स्मार्ट रूटिंग';

  @override
  String get featureCommunityVerification => 'समुदाय पडताळणी';

  @override
  String get featureUserProfiles => 'वापरकर्ता प्रोफाइल आणि आकडेवारी';

  @override
  String get projectInformation => 'प्रकल्प माहिती';

  @override
  String get statusLabel => 'स्थिती';

  @override
  String get statusActiveDevelopment => 'सक्रिय विकास';

  @override
  String get publisherLabel => 'प्रकाशक';

  @override
  String get licenseLabel => 'परवाना (लायसन्स)';

  @override
  String get licenseEducational => 'शैक्षणिक आणि संशोधन प्रकल्प';

  @override
  String get support => 'मदत आणि पाठबळ';

  @override
  String get reportBug => 'त्रुटी (बग) नोंदवा';

  @override
  String get contactDeveloper => 'विकासकाशी संपर्क साधा';

  @override
  String get reportBugDialogTitle => 'बगची तक्रार करा';

  @override
  String get reportBugDialogContent =>
      'कृपया समस्या स्पष्ट करा, जेणेकरून आम्ही ती दुरुस्त करू शकू';

  @override
  String get unableOpenEmail => 'ईमेल उघडता आले नाही';

  @override
  String get hlpDescription =>
      'द मॅप प्रोजेक्ट हे HLP - हिब्रो लॅब प्रॉडक्शन्स द्वारे विकसित आणि देखरेख केलेले उत्पादन आहे.';

  @override
  String get developerContact => 'विकासक संपर्क';

  @override
  String get copyrightNotice => '© 2026 HLP - हिब्रो लॅब प्रॉडक्शन्स';

  @override
  String get allRightsReserved => 'सर्व हक्क राखीव.';

  @override
  String get notificationGeneralName => 'द मॅप प्रोजेक्ट';

  @override
  String get notificationGeneralDescription =>
      'नेव्हिगेशन, मार्ग आणि रस्ता सूचना नोटिफिकेशन्स.';

  @override
  String get notificationTestBody =>
      'नोटिफिकेशन्स यशस्वीरित्या कार्य करत आहेत!';

  @override
  String get notificationJourneyStartedTitle => 'प्रवास सुरू झाला';

  @override
  String get notificationJourneyStartedBody => 'नेव्हिगेशन सुरू झाले आहे.';

  @override
  String get notificationJourneyCompletedTitle => 'प्रवास पूर्ण झाला';

  @override
  String get notificationJourneyCompletedBody =>
      'तुम्ही तुमच्या गंतव्यस्थानी पोहोचला आहात.';

  @override
  String get notificationRouteUpdatedTitle => 'मार्ग अपडेट केला';

  @override
  String get notificationRouteUpdatedBody =>
      'रस्त्यावरील अडथळ्यामुळे तुमचा मार्ग अपडेट केला गेला आहे.';

  @override
  String get noUserLoggedIn => 'कोणताही वापरकर्ता लॉग इन नाही';

  @override
  String welcomeUser(String email) {
    return 'स्वागत आहे\n\n$email';
  }

  @override
  String get singleActiveAlert => '1 सक्रिय सूचना';

  @override
  String multipleActiveAlerts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय अलर्ट',
      one: '1 सक्रिय अलर्ट',
      zero: 'कोणतेही सक्रिय अलर्ट नाहीत',
    );
    return '$_temp0';
  }

  @override
  String get somethingWentWrongAlerts => 'अलर्ट लोड करताना काहीतरी चूक झाली.';

  @override
  String get arrivedAtDestinationSnackbar =>
      'तुम्ही तुमच्या गंतव्यस्थानी पोहोचलात.';

  @override
  String get communityReporterFallback => 'समुदाय सदस्य';

  @override
  String get navigationAvailableSoon => 'नेव्हिगेशन सुविधा लवकरच उपलब्ध होईल.';

  @override
  String get thanksForConfirming =>
      'पुष्टी केल्याबद्दल धन्यवाद. ही माहिती इतर प्रवाशांना मदत करेल.';

  @override
  String get continueOnCurrentRoute => 'सध्याच्या मार्गावर सुरू ठेवा';

  @override
  String get statReports => 'अहवाल';

  @override
  String get statActive => 'सक्रिय';

  @override
  String get statReputation => 'प्रतिष्ठा';

  @override
  String get statAchievements => 'यशस्वी कामगिरी';

  @override
  String get appTitleWithCity => 'द मॅप प्रोजेक्ट • नाशिक';

  @override
  String get couldNotLoadProfileInfo => 'प्रोफाइल माहिती लोड करता आली नाही.';

  @override
  String get achievementFirstReport => 'पहिला अहवाल';

  @override
  String get achievementRoadGuardian => 'रस्ता संरक्षक';

  @override
  String get achievementCommunityHelper => 'समुदाय सहाय्यक';

  @override
  String get unableToOpenEmail => 'ईमेल अअप उघडता आले नाही.';

  @override
  String get reportBugContent =>
      'कृपया समस्येबद्दल अधिक माहिती द्या, जेणेकरून आम्ही ती दुरुस्त करू शकू.\nधन्यवाद.';

  @override
  String get coreFeatures => 'मुख्य वैशिष्ट्ये';

  @override
  String get featureIncidentReporting => 'घटना अहवाल';

  @override
  String get featureSmartNavigation => 'स्मार्ट नेव्हिगेशन';

  @override
  String versionBuildSummary(Object appVersion, Object buildNumber) {
    return 'आवृत्ती आणि बिल्ड माहिती';
  }

  @override
  String languageChangedSnackbar(Object language) {
    return 'भाषा $language मध्ये बदलली आहे.';
  }

  @override
  String saveLanguageButton(Object language) {
    return '$language जतन करा';
  }

  @override
  String get languageAppliesInstantly => 'भाषा त्वरित लागू होते';

  @override
  String get notificationPreferencesFootnote =>
      'सूचना प्राधान्ये फक्त या सत्रासाठी लागू आहेत.';

  @override
  String get notificationSettingsSummary =>
      'या पेजवरून तुमची सूचना प्राधान्ये नियंत्रित करा.\nबदल सध्याच्या सत्रात लागू होतात.';
}
