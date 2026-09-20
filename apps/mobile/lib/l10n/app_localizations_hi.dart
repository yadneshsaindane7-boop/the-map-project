// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'मार्ग सारथी';

  @override
  String get appTagline => 'सटीक व त्वरित सड़क जानकारी';

  @override
  String get ok => 'ठीक है';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get close => 'बंद करें';

  @override
  String get back => 'वापस';

  @override
  String get status => 'स्थिति';

  @override
  String get distance => 'दूरी';

  @override
  String get reporter => 'रिपोर्टर';

  @override
  String get reported => 'रिपोर्ट किया गया';

  @override
  String get location => 'स्थान';

  @override
  String get latitude => 'अक्षांश';

  @override
  String get longitude => 'देशांतर';

  @override
  String get community => 'समुदाय';

  @override
  String get nashik => 'नाशिक';

  @override
  String get navMap => 'मानचित्र';

  @override
  String get navReport => 'रिपोर्ट';

  @override
  String get navAlerts => 'अलर्ट';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get searchDestinationHint => 'गंतव्य खोजें...';

  @override
  String get clearSearch => 'खोज साफ करें';

  @override
  String get mapLayers => 'मानचित्र परतें';

  @override
  String get myLocation => 'मेरा स्थान';

  @override
  String get zoomToReports => 'रिपोर्ट्स पर ज़ूम करें';

  @override
  String get findingRoute => 'मार्ग खोजा जा रहा है...';

  @override
  String get rerouting => 'नया मार्ग बनाया जा रहा है...';

  @override
  String get routePointsTooFew =>
      'मार्ग प्राप्त हुआ किंतु इसमें अपर्याप्त बिंदु हैं।';

  @override
  String get unableToFindRoute => 'मार्ग खोजने में असमर्थ।';

  @override
  String failedToLoadRoute(String error) {
    return 'मार्ग लोड करने में विफल: $error';
  }

  @override
  String get arrivalMessage => 'आप अपने गंतव्य पर पहुँच गए हैं।';

  @override
  String get roadIncidentRerouting =>
      'सड़क पर घटना का पता चला। नया मार्ग बनाया जा रहा है...';

  @override
  String get mapStyleStreets => 'सड़कें';

  @override
  String get mapStyleTerrain => 'धरातल';

  @override
  String get mapStyleSatellite => 'उपग्रह';

  @override
  String get unknownDate => 'अज्ञात';

  @override
  String get navigateButton => 'दिशा-निर्देश';

  @override
  String get navigationFutureNotice => 'नेविगेशन v0.5.0 में उपलब्ध होगा';

  @override
  String get confirmButton => 'पुष्टि करें';

  @override
  String get incidentConfirmedMessage => 'घटना की पुष्टि करने के लिए धन्यवाद';

  @override
  String get eta => 'अनुमानित समय';

  @override
  String get startNavigation => 'नेविगेशन शुरू करें';

  @override
  String get nextInstruction => 'अगला मोड़ / निर्देश';

  @override
  String get continueCurrentRoute => 'वर्तमान मार्ग पर जारी रखें';

  @override
  String inDistance(String distance) {
    return '$distance में';
  }

  @override
  String get endJourney => 'यात्रा समाप्त करें';

  @override
  String get remaining => 'शेष';

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
    return '$count मिनट';
  }

  @override
  String durationHours(int count) {
    return '$count घंटे';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours घंटे $minutes मिनट';
  }

  @override
  String get reportIncidentTitle => 'घटना की रिपोर्ट करें';

  @override
  String get reportIncidentSubtitle =>
      'नाशिक की सड़कों को सुरक्षित बनाने में मदद करें';

  @override
  String get incidentLocation => 'घटना का स्थान';

  @override
  String get locationSelectedOnMap => 'नक्शे पर चुना गया स्थान';

  @override
  String get usingCurrentLocation =>
      'आपके वर्तमान स्थान का उपयोग किया जा रहा है';

  @override
  String get changeLocation => 'स्थान बदलें';

  @override
  String get chooseOnMap => 'मानचित्र पर चुनें';

  @override
  String get incidentDetails => 'घटना का विवरण';

  @override
  String get incidentTitle => 'घटना का शीर्षक';

  @override
  String get incidentTitleHint => 'उदा. पुल के पास दुर्घटना';

  @override
  String get incidentTitleEmptyError => 'घटना का शीर्षक दर्ज करें';

  @override
  String get incidentTitleMinError => 'शीर्षक कम से कम 3 अक्षरों का होना चाहिए';

  @override
  String get incidentDescriptionOptional => 'विवरण (वैकल्पिक)';

  @override
  String get incidentDescriptionHint =>
      'अन्य चालकों के लिए उपयोगी विवरण जोड़ें...';

  @override
  String get incidentType => 'घटना का प्रकार';

  @override
  String get whatIsHappening => 'सड़क पर क्या समस्या है?';

  @override
  String get selectIncidentType => 'घटना का प्रकार चुनें';

  @override
  String get selectIncidentTypeError => 'कृपया घटना का प्रकार चुनें';

  @override
  String get resolvingRoadAndSubmitting =>
      'सड़क सत्यापित कर रिपोर्ट भेजी जा रही है...';

  @override
  String get submitIncident => 'घटना दर्ज करें';

  @override
  String get reportReviewDisclaimer =>
      'सक्रिय ट्रैफ़िक अलर्ट बनने से पहले रिपोर्टों की समीक्षा की जाती है।';

  @override
  String get reportSuccessMessage =>
      'घटना सफलतापूर्वक दर्ज की गई।\nआपकी रिपोर्ट समीक्षा के लिए भेज दी गई है।';

  @override
  String reportErrorMessage(String error) {
    return 'घटना दर्ज करने में असमर्थ।\n$error';
  }

  @override
  String get unableToGetLocation => 'आपका स्थान प्राप्त करने में असमर्थ';

  @override
  String unableToLoadIncidentTypes(String error) {
    return 'घटना के प्रकार लोड करने में असमर्थ।\n$error';
  }

  @override
  String get chooseIncidentLocation => 'घटना का स्थान चुनें';

  @override
  String get resetLocation => 'स्थान रीसेट करें';

  @override
  String get tapMapToSelectLocation =>
      'घटना का स्थान चुनने के लिए मानचित्र पर स्पर्श करें';

  @override
  String get selectedPointAttached => 'चयनित स्थान रिपोर्ट के साथ जोड़ा गया है';

  @override
  String get useThisLocation => 'इस स्थान का उपयोग करें';

  @override
  String get incidentRoadClosed => 'सड़क बंद';

  @override
  String get incidentAccident => 'दुर्घटना';

  @override
  String get incidentConstruction => 'निर्माण कार्य';

  @override
  String get incidentFlooding => 'जलभराव / बाढ़';

  @override
  String get incidentTrafficJam => 'ट्रैफ़िक जाम';

  @override
  String get incidentPothole => 'गड्ढा';

  @override
  String get incidentPublicEvent => 'सार्वजनिक आयोजन';

  @override
  String get incidentDiversion => 'मार्ग परिवर्तन (डायवर्जन)';

  @override
  String get incidentOther => 'अन्य';

  @override
  String get trafficAlertsTitle => 'यातायात अलर्ट';

  @override
  String get trafficAlertsSubtitle => 'आस-पास की घटनाओं से अवगत रहें';

  @override
  String get refreshAlertsTooltip => 'अलर्ट रीफ़्रेश करें';

  @override
  String get loadingTrafficAlerts => 'यातायात अलर्ट लोड हो रहे हैं...';

  @override
  String get unableToLoadAlerts => 'अलर्ट लोड करने में असमर्थ';

  @override
  String get alertsErrorMessage =>
      'नवीनतम यातायात अलर्ट लोड करते समय कुछ गड़बड़ हुई।';

  @override
  String activeAlertsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय अलर्ट',
      one: '1 सक्रिय अलर्ट',
    );
    return '$_temp0';
  }

  @override
  String get updatedLive => 'लाइव अपडेट';

  @override
  String get communityVerified => 'समुदाय द्वारा सत्यापित';

  @override
  String get viewOnMap => 'मानचित्र पर देखें';

  @override
  String get timeJustNow => 'अभी-अभी';

  @override
  String timeMinAgo(int count) {
    return '$count मिनट पहले';
  }

  @override
  String timeHrAgo(int count) {
    return '$count घंटे पहले';
  }

  @override
  String get timeDayAgo => '1 दिन पहले';

  @override
  String timeDaysAgo(int count) {
    return '$count दिन पहले';
  }

  @override
  String get statusActive => 'सक्रिय';

  @override
  String get statusVerified => 'सत्यापित';

  @override
  String get statusResolved => 'समाधानित';

  @override
  String get noActiveAlerts => 'कोई सक्रिय अलर्ट नहीं';

  @override
  String get noActiveAlertsDescription =>
      'वर्तमान में सड़क नेटवर्क को प्रभावित करने वाली कोई सत्यापित घटना नहीं है।';

  @override
  String get youAreAllClear => 'सड़क मार्ग पूरी तरह साफ़ है';

  @override
  String get profileTitle => 'प्रोफ़ाइल';

  @override
  String get profileCommunityActivity => 'आपकी सामुदायिक गतिविधि';

  @override
  String get yourActivity => 'आपकी गतिविधि';

  @override
  String get yourContribution => 'समुदाय में आपका योगदान';

  @override
  String get reportsCountLabel => 'रिपोर्ट';

  @override
  String get activeCountLabel => 'सक्रिय';

  @override
  String get reputationLabel => 'प्रतिष्ठा';

  @override
  String get achievementsLabel => 'उपलब्धियाँ';

  @override
  String get communityMilestones => 'आपके सामुदायिक मील के पत्थर';

  @override
  String get badgeFirstReport => 'पहली रिपोर्ट';

  @override
  String get badgeRoadGuardian => 'सड़क रक्षक';

  @override
  String get badgeCommunityHelper => 'समुदाय सहायक';

  @override
  String get authorityTools => 'अधिकार क्षेत्र उपकरण';

  @override
  String get authorityToolsSubtitle =>
      'अधिकृत उपयोगकर्ताओं के लिए उपलब्ध उपकरण';

  @override
  String get moderateIncidentReports => 'घटना रिपोर्टों का संचालन';

  @override
  String get moderateReportsSubtitle =>
      'लंबित रिपोर्टों की समीक्षा, अनुमोदन या अस्वीकार करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get manageAppPreferences => 'अपनी ऐप प्राथमिकताएं प्रबंधित करें';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get manageNotificationPreferences =>
      'सूचना प्राथमिकताएं प्रबंधित करें';

  @override
  String get language => 'भाषा';

  @override
  String get about => 'ऐप के बारे में';

  @override
  String get aboutAppVersion => 'मार्ग सारथी v4.0';

  @override
  String get footerNashik => 'मार्ग सारथी • नाशिक';

  @override
  String get unableToLoadProfile => 'प्रोफ़ाइल लोड करने में असमर्थ';

  @override
  String get unableToLoadProfileMessage =>
      'हम आपकी प्रोफ़ाइल जानकारी लोड नहीं कर सके।';

  @override
  String get authorityAccount => 'प्राधिकारी खाता';

  @override
  String get communityMember => 'समुदाय सदस्य';

  @override
  String get logout => 'लॉग आउट';

  @override
  String logoutFailed(String error) {
    return 'लॉग आउट विफल रहा\n$error';
  }

  @override
  String get incidentModerationTitle => 'घटना संचालन';

  @override
  String get incidentModerationSubtitle =>
      'सामुदायिक रिपोर्टों की समीक्षा करें';

  @override
  String get pendingReports => 'लंबित रिपोर्टें';

  @override
  String get pendingReportsSubtitle => 'प्राधिकारी समीक्षा की प्रतीक्षा में';

  @override
  String get activeIncidents => 'सक्रिय घटनाएं';

  @override
  String get activeIncidentsSubtitle =>
      'वर्तमान में मार्ग मार्गदर्शन को प्रभावित कर रही हैं';

  @override
  String get noPendingReports => 'कोई लंबित रिपोर्ट नहीं है';

  @override
  String get noPendingReportsSubtitle =>
      'नई सामुदायिक रिपोर्टें यहाँ दिखाई देंगी।';

  @override
  String get noActiveIncidents => 'कोई सक्रिय घटना नहीं';

  @override
  String get noActiveIncidentsSubtitle =>
      'सभी सत्यापित घटनाओं का समाधान हो चुका है।';

  @override
  String get pendingReportsUnavailable => 'लंबित रिपोर्टें अनुपलब्ध हैं';

  @override
  String get activeIncidentsUnavailable => 'सक्रिय घटनाएं अनुपलब्ध हैं';

  @override
  String get osmWay => 'OSM वे आईडी';

  @override
  String get notAssigned => 'निर्धारित नहीं';

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get approve => 'स्वीकृत करें';

  @override
  String get resolveIncident => 'घटना समाप्त घोषित करें';

  @override
  String get approveIncidentTitle => 'घटना स्वीकृत करें?';

  @override
  String approveIncidentMessage(String title) {
    return 'क्या आप \"$title\" को स्वीकृत कर इसे रूटिंग सिस्टम के लिए सक्रिय करना चाहते हैं?';
  }

  @override
  String get incidentApprovedMessage => 'घटना रिपोर्ट स्वीकृत कर दी गई।';

  @override
  String approvalFailedMessage(String error) {
    return 'स्वीकृति विफल रही: $error';
  }

  @override
  String get rejectIncidentTitle => 'घटना अस्वीकार करें?';

  @override
  String rejectIncidentMessage(String title) {
    return 'क्या आप \"$title\" को अस्वीकार करना चाहते हैं? यह रिपोर्ट रूटिंग के लिए सक्रिय नहीं होगी।';
  }

  @override
  String get incidentRejectedMessage => 'घटना रिपोर्ट अस्वीकार कर दी गई।';

  @override
  String rejectionFailedMessage(String error) {
    return 'अस्वीकृति विफल रही: $error';
  }

  @override
  String get resolveIncidentTitle => 'घटना का समाधान करें?';

  @override
  String resolveIncidentMessage(String title) {
    return 'क्या आप \"$title\" को पूर्ण चिह्नित कर सक्रिय रूटिंग से सड़क प्रतिबंध हटाना चाहते हैं?';
  }

  @override
  String get incidentResolvedMessage =>
      'घटना का समाधान किया गया और सड़क प्रतिबंध हटा दिया गया।';

  @override
  String resolutionFailedMessage(String error) {
    return 'समाधान विफल रहा: $error';
  }

  @override
  String get smartNavigationSubtitle => 'समुदाय संचालित स्मार्ट नेविगेशन';

  @override
  String get loginTaglineDescription =>
      'सटीक सड़क जानकारी और सामुदायिक अलर्ट के साथ समझदारी से यात्रा करें।';

  @override
  String get liveTraffic => 'लाइव ट्रैफ़िक';

  @override
  String get smartRoutes => 'स्मार्ट रूट्स';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get signInSubtitle =>
      'अपने वैयक्तिकृत मानचित्र अनुभव के लिए साइन इन करें।';

  @override
  String get continueWithGoogle => 'Google के साथ आगे बढ़ें';

  @override
  String get secureSignInGoogle => 'Google के साथ सुरक्षित साइन-इन';

  @override
  String get termsNotice =>
      'आगे बढ़कर, आप ऐप का जिम्मेदारी से उपयोग करने के लिए सहमत होते हैं।';

  @override
  String get stayInformed => 'अपडेट रहें';

  @override
  String get notificationSettings => 'सूचना सेटिंग्स';

  @override
  String get pushNotifications => 'पुश नोटिफिकेशन्स';

  @override
  String get pushNotificationsDescription => 'महत्वपूर्ण सूचनाएँ प्राप्त करें';

  @override
  String get notificationTypes => 'सूचनाओं के प्रकार';

  @override
  String get nearbyRoadAlerts => 'आस-पास सड़क अलर्ट';

  @override
  String get nearbyRoadAlertsDescription =>
      'पास की सड़क घटनाओं के बारे में सूचित करें';

  @override
  String get routeUpdates => 'मार्ग अपडेट';

  @override
  String get routeUpdatesDescription =>
      'मार्ग में बदलाव के बारे में सूचित करें';

  @override
  String get communityReportsNotification => 'सामुदायिक रिपोर्ट';

  @override
  String get communityReportsNotificationDescription =>
      'सामुदायिक रिपोर्ट से संबंधित सूचनाएँ प्राप्त करें';

  @override
  String get notificationSessionNotice =>
      'ये सेटिंग्स वर्तमान सत्र के लिए लागू हैं';

  @override
  String get notificationFooter => 'आपकी सूचना प्राथमिकताएँ यहाँ दिखाई देंगी';

  @override
  String get choosePreferredLanguage => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get currentLanguage => 'वर्तमान भाषा';

  @override
  String get availableLanguages => 'उपलब्ध भाषाएँ';

  @override
  String saveLanguage(String language) {
    return 'भाषा सहेजें';
  }

  @override
  String languageSelectedSnackbar(String language) {
    return 'चुनी गई भाषा: $language';
  }

  @override
  String get languageFutureNotice =>
      'भविष्य के अपडेट में अन्य भारतीय क्षेत्रीय भाषाएँ उपलब्ध कराई जाएंगी।';

  @override
  String get languageEnglish => 'English (अंग्रेज़ी)';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String appVersionBuild(String version, String build) {
    return 'संस्करण $version • बिल्ड $build';
  }

  @override
  String get aboutTheProject => 'परियोजना के बारे में';

  @override
  String get hlpName => 'HLP - हिब्रो लैब प्रोडक्शंस';

  @override
  String get aboutProjectDescription =>
      'मार्ग सारथी एक समुदाय-संचालित नेविगेशन प्लेटफॉर्म है जिसे समुदाय की रिपोर्टों और आधुनिक मैपिंग तकनीकों का उपयोग करके वास्तविक समय की सड़क स्थितियों, सड़क बंदी, यातायात की घटनाओं और बुद्धिमत्तापूर्ण मार्ग मार्गदर्शन प्रदान करने के लिए डिज़ाइन किया गया है।';

  @override
  String get developmentTeam => 'विकास टीम';

  @override
  String get roleProjectGuide => 'प्रोजेक्ट मार्गदर्शक';

  @override
  String get roleLeadDeveloper => 'मुख्य डेवलपर';

  @override
  String get roleDocumentation => 'प्रोजेक्ट प्रलेखन';

  @override
  String get roleResearchValidation => 'अनुसंधान एवं फील्ड सत्यापन';

  @override
  String get technologyStack => 'प्रौद्योगिकी स्टैक';

  @override
  String get techFramework => 'फ़्रेमवर्क';

  @override
  String get techBackend => 'बैकएंड';

  @override
  String get techMaps => 'मानचित्र';

  @override
  String get techRouting => 'रूटिंग';

  @override
  String get techLanguage => 'प्रोग्रामिंग भाषा';

  @override
  String get featureReporting => 'घटना रिपोर्टिंग';

  @override
  String get featureTrafficAlerts => 'रीयल-टाइम ट्रैफ़िक अलर्ट';

  @override
  String get featureRoadClosure => 'सड़क बंदी का पता लगाना';

  @override
  String get featureSmartRouting => 'स्मार्ट रूटिंग';

  @override
  String get featureCommunityVerification => 'सामुदायिक सत्यापन';

  @override
  String get featureUserProfiles => 'उपयोगकर्ता प्रोफ़ाइल और सांख्यिकी';

  @override
  String get projectInformation => 'प्रोजेक्ट जानकारी';

  @override
  String get statusLabel => 'स्थिति';

  @override
  String get statusActiveDevelopment => 'सक्रिय विकास';

  @override
  String get publisherLabel => 'प्रकाशक';

  @override
  String get licenseLabel => 'लाइसेंस';

  @override
  String get licenseEducational => 'शैक्षणिक एवं अनुसंधान परियोजना';

  @override
  String get support => 'सहायता एवं समर्थन';

  @override
  String get reportBug => 'त्रुटि (बग) रिपोर्ट करें';

  @override
  String get contactDeveloper => 'डेवलपर से संपर्क करें';

  @override
  String get reportBugDialogTitle => 'बग की रिपोर्ट करें';

  @override
  String get reportBugDialogContent =>
      'कृपया समस्या का विवरण दें ताकि हम इसे ठीक कर सकें';

  @override
  String get unableOpenEmail => 'ईमेल खोलने में असमर्थ';

  @override
  String get hlpDescription =>
      'मार्ग सारथी HLP - हिब्रो लैब प्रोडक्शंस द्वारा विकसित और अनुरक्षित एक उत्पाद है।';

  @override
  String get developerContact => 'डेवलपर संपर्क';

  @override
  String get copyrightNotice => '© 2026 HLP - हिब्रो लैब प्रोडक्शंस';

  @override
  String get allRightsReserved => 'सर्वाधिकार सुरक्षित।';

  @override
  String get notificationGeneralName => 'मार्ग सारथी';

  @override
  String get notificationGeneralDescription =>
      'नेविगेशन, मार्ग और सड़क अलर्ट सूचनाएं।';

  @override
  String get notificationTestBody => 'नोटिफिकेशन सफलतापूर्वक कार्य कर रहे हैं!';

  @override
  String get notificationJourneyStartedTitle => 'यात्रा शुरू हुई';

  @override
  String get notificationJourneyStartedBody => 'नेविगेशन शुरू हो गया है।';

  @override
  String get notificationJourneyCompletedTitle => 'यात्रा पूर्ण हुई';

  @override
  String get notificationJourneyCompletedBody =>
      'आप अपने गंतव्य पर पहुँच गए हैं।';

  @override
  String get notificationRouteUpdatedTitle => 'मार्ग अपडेट किया गया';

  @override
  String get notificationRouteUpdatedBody =>
      'सड़क पर घटना के कारण आपका मार्ग अपडेट कर दिया गया है।';

  @override
  String get noUserLoggedIn => 'कोई उपयोगकर्ता लॉग इन नहीं है';

  @override
  String welcomeUser(String email) {
    return 'स्वागत है\n\n$email';
  }

  @override
  String get singleActiveAlert => '1 सक्रिय अलर्ट';

  @override
  String multipleActiveAlerts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count सक्रिय अलर्ट',
      one: '1 सक्रिय अलर्ट',
      zero: 'कोई सक्रिय अलर्ट नहीं',
    );
    return '$_temp0';
  }

  @override
  String get somethingWentWrongAlerts => 'अलर्ट लोड करते समय कुछ गलत हो गया';

  @override
  String get arrivedAtDestinationSnackbar => 'आप अपने गंतव्य पर पहुँच गए हैं';

  @override
  String get communityReporterFallback => 'समुदाय सदस्य';

  @override
  String get navigationAvailableSoon => 'नेविगेशन सुविधा जल्द ही उपलब्ध होगी';

  @override
  String get thanksForConfirming =>
      'पुष्टि करने के लिए धन्यवाद। यह जानकारी अन्य यात्रियों की मदद करेगी।';

  @override
  String get continueOnCurrentRoute => 'वर्तमान मार्ग पर जारी रखें';

  @override
  String get statReports => 'रिपोर्ट';

  @override
  String get statActive => 'सक्रिय';

  @override
  String get statReputation => 'प्रतिष्ठा';

  @override
  String get statAchievements => 'उपलब्धियाँ';

  @override
  String get appTitleWithCity => 'मार्ग सारथी • नासिक';

  @override
  String get couldNotLoadProfileInfo => 'प्रोफ़ाइल जानकारी लोड नहीं की जा सकी';

  @override
  String get achievementFirstReport => 'पहली रिपोर्ट';

  @override
  String get achievementRoadGuardian => 'सड़क प्रहरी';

  @override
  String get achievementCommunityHelper => 'समुदाय सहायक';

  @override
  String get unableToOpenEmail => 'ईमेल ऐप खोलने में असमर्थ';

  @override
  String get reportBugContent =>
      'कृपया समस्या के बारे में अधिक जानकारी दें, ताकि हम उसे ठीक कर सकें।\nधन्यवाद।';

  @override
  String get coreFeatures => 'मुख्य विशेषताएँ';

  @override
  String get featureIncidentReporting => 'घटना रिपोर्टिंग';

  @override
  String get featureSmartNavigation => 'स्मार्ट नेविगेशन';

  @override
  String versionBuildSummary(Object appVersion, Object buildNumber) {
    return 'संस्करण और बिल्ड की जानकारी';
  }

  @override
  String languageChangedSnackbar(Object language) {
    return 'भाषा $language में बदल दी गई है';
  }

  @override
  String saveLanguageButton(Object language) {
    return '$language सहेजें';
  }

  @override
  String get languageAppliesInstantly => 'भाषा तुरंत लागू होती है';

  @override
  String get notificationPreferencesFootnote =>
      'अधिसूचना प्राथमिकताएँ केवल इस सत्र के लिए लागू होती हैं।\nबाद में इन्हें स्थायी बनाया जाएगा।';

  @override
  String get notificationSettingsSummary =>
      'इस पेज से अपनी अधिसूचना प्राथमिकताएँ नियंत्रित करें।\nपरिवर्तन वर्तमान सत्र में लागू होते हैं।';
}
