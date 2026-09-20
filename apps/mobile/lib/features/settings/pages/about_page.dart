import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String appVersion = '4.0.0';
  static const String buildNumber = '4';

  Future<void> _contactDeveloper(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final Uri email = Uri(
      scheme: 'mailto',
      path: 'yadneshsaindane7@gmail.com',
      query:
          'subject=Maarg Saarthi&body=Hello HLP Team,%0A%0AI would like to contact you regarding Maarg Saarthi.%0A',
    );

    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.unableToOpenEmail),
          ),
        );
      }
    }
  }

  void _reportBug(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.reportBug),
          content: Text(
            l10n.reportBugContent,
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 18,
        bottom: 10,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 21,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 9),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool showDivider = true,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 3,
          ),
          leading: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 70,
            color: theme.dividerColor,
          ),
      ],
    );
  }

  Widget _featureTile(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            size: 19,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          14,
          16,
          28,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Image.asset(
                        'assets/images/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.appTagline,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 17,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.appVersionBuild(
                            appVersion,
                            buildNumber,
                          ),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.map_rounded,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.aboutTheProject,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Maarg Saarthi',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      l10n.aboutProjectDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _sectionHeader(
              context,
              l10n.developmentTeam,
              Icons.groups_rounded,
            ),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Column(
                children: [
                  _infoTile(
                    context,
                    icon: Icons.school_rounded,
                    title: 'Prof - R. V. Daund',
                    subtitle: l10n.roleProjectGuide,
                  ),
                  _infoTile(
                    context,
                    icon: Icons.code_rounded,
                    title: 'Yadnesh Saindane',
                    subtitle: l10n.roleLeadDeveloper,
                  ),
                  _infoTile(
                    context,
                    icon: Icons.description_rounded,
                    title: 'Namrata Wagh',
                    subtitle: l10n.roleDocumentation,
                  ),
                  _infoTile(
                    context,
                    icon: Icons.science_rounded,
                    title: 'Umesh Suryawanshi',
                    subtitle: l10n.roleResearchValidation,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            _sectionHeader(
              context,
              l10n.technologyStack,
              Icons.layers_rounded,
            ),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Column(
                children: [
                  _infoTile(
                    context,
                    icon: Icons.flutter_dash,
                    title: l10n.techFramework,
                    subtitle: 'Flutter',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.storage_rounded,
                    title: l10n.techBackend,
                    subtitle: 'Supabase',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.map_rounded,
                    title: l10n.techMaps,
                    subtitle: 'Flutter Map + OpenStreetMap',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.route_rounded,
                    title: l10n.techRouting,
                    subtitle: 'Custom FastAPI + A* Nashik Road Graph',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.code_rounded,
                    title: l10n.techLanguage,
                    subtitle: 'Dart',
                    showDivider: false,
                  ),
                ],
              ),
            ),
            _sectionHeader(
              context,
              l10n.coreFeatures,
              Icons.auto_awesome_rounded,
            ),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Column(
                children: [
                  _featureTile(
                    context,
                    l10n.featureIncidentReporting,
                    Icons.report_problem_outlined,
                  ),
                  _featureTile(
                    context,
                    l10n.featureTrafficAlerts,
                    Icons.traffic_outlined,
                  ),
                  _featureTile(
                    context,
                    l10n.featureRoadClosure,
                    Icons.block_rounded,
                  ),
                  _featureTile(
                    context,
                    l10n.featureSmartNavigation,
                    Icons.alt_route_rounded,
                  ),
                  _featureTile(
                    context,
                    l10n.featureCommunityVerification,
                    Icons.verified_user_outlined,
                  ),
                  _featureTile(
                    context,
                    l10n.featureUserProfiles,
                    Icons.person_outline_rounded,
                  ),
                ],
              ),
            ),
            _sectionHeader(
              context,
              l10n.projectInformation,
              Icons.info_outline_rounded,
            ),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Column(
                children: [
                  _infoTile(
                    context,
                    icon: Icons.public_rounded,
                    title: l10n.statusLabel,
                    subtitle: l10n.statusActiveDevelopment,
                  ),
                  _infoTile(
                    context,
                    icon: Icons.business_rounded,
                    title: l10n.publisherLabel,
                    subtitle: 'HLP - Hibro Lab Productions',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.workspace_premium_rounded,
                    title: l10n.licenseLabel,
                    subtitle: l10n.licenseEducational,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            _sectionHeader(
              context,
              l10n.support,
              Icons.support_agent_rounded,
            ),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        icon: const Icon(
                          Icons.bug_report_outlined,
                        ),
                        label: Text(l10n.reportBug),
                        onPressed: () {
                          _reportBug(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        icon: const Icon(
                          Icons.email_outlined,
                        ),
                        label: Text(l10n.contactDeveloper),
                        onPressed: () {
                          _contactDeveloper(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.corporate_fare_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 11),
                    Text(
                      'HLP - Hibro Lab Productions',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      l10n.hlpDescription,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 13),
                    Divider(
                      color: theme.dividerColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.developerContact,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SelectableText(
                      'yadneshsaindane7@gmail.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: Column(
                children: [
                  Text(
                    '© 2026 HLP - Hibro Lab Productions',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.versionBuildSummary(
                      appVersion,
                      buildNumber,
                    ),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    l10n.allRightsReserved,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}