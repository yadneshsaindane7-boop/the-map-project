import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String appVersion = '2.0.0';
  static const String buildNumber = '2';

  Future<void> _contactDeveloper(BuildContext context) async {
    final Uri email = Uri(
      scheme: 'mailto',
      path: 'yadneshsaindane7@gmail.com',
      query:
          'subject=The Map Project&body=Hello HLP Team,%0A%0AI would like to contact you regarding The Map Project.%0A',
    );

    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to open email application.',
            ),
          ),
        );
      }
    }
  }

  void _reportBug(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Report a Bug'),
          content: const Text(
            'Bug reporting portal will be available in a future update.\n\n'
            'For now, you can report bugs directly to the developer '
            'using the Contact Developer option.',
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
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
            // App identity
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
                    'The Map Project',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Community Powered Smart Navigation',
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
                          'Version $appVersion • Build $buildNumber',
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

            // About the project
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
                            'About the Project',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'HLP - Hibro Lab Productions',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'The Map Project is a community-powered navigation '
                      'platform designed to provide real-time road '
                      'conditions, road closures, traffic incidents and '
                      'intelligent route guidance using community reports '
                      'and modern mapping technologies.',
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
              'Development Team',
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
                    subtitle: 'Project Guide',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.code_rounded,
                    title: 'Yadnesh Saindane',
                    subtitle: 'Lead Developer',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.description_rounded,
                    title: 'Namrata Wagh',
                    subtitle: 'Project Documentation',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.science_rounded,
                    title: 'Umesh Suryawanshi',
                    subtitle: 'Research & Field Validation',
                    showDivider: false,
                  ),
                ],
              ),
            ),

            _sectionHeader(
              context,
              'Technology Stack',
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
                    title: 'Framework',
                    subtitle: 'Flutter',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.storage_rounded,
                    title: 'Backend',
                    subtitle: 'Supabase',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.map_rounded,
                    title: 'Maps',
                    subtitle: 'Flutter Map + OpenStreetMap',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.route_rounded,
                    title: 'Routing',
                    subtitle: 'Custom FastAPI + A* Nashik Road Graph',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.code_rounded,
                    title: 'Programming Language',
                    subtitle: 'Dart',
                    showDivider: false,
                  ),
                ],
              ),
            ),

            _sectionHeader(
              context,
              'Core Features',
              Icons.auto_awesome_rounded,
            ),

            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              child: Column(
                children: [
                  _featureTile(
                    context,
                    'Community Incident Reporting',
                    Icons.report_problem_outlined,
                  ),
                  _featureTile(
                    context,
                    'Real-Time Traffic Alerts',
                    Icons.traffic_outlined,
                  ),
                  _featureTile(
                    context,
                    'Road Closure Detection',
                    Icons.block_rounded,
                  ),
                  _featureTile(
                    context,
                    'Smart Route Navigation',
                    Icons.alt_route_rounded,
                  ),
                  _featureTile(
                    context,
                    'Community Verification',
                    Icons.verified_user_outlined,
                  ),
                  _featureTile(
                    context,
                    'User Profiles & Statistics',
                    Icons.person_outline_rounded,
                  ),
                ],
              ),
            ),

            _sectionHeader(
              context,
              'Project Information',
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
                    title: 'Status',
                    subtitle: 'Active Development',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.business_rounded,
                    title: 'Publisher',
                    subtitle: 'HLP - Hibro Lab Productions',
                  ),
                  _infoTile(
                    context,
                    icon: Icons.workspace_premium_rounded,
                    title: 'License',
                    subtitle: 'Educational & Research Project',
                    showDivider: false,
                  ),
                ],
              ),
            ),

            _sectionHeader(
              context,
              'Support',
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
                        label: const Text('Report a Bug'),
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
                        label: const Text('Contact Developer'),
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

            // HLP
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
                      'The Map Project is a product developed and '
                      'maintained by HLP - Hibro Lab Productions.',
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
                      'Developer Contact',
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
                    'The Map Project • Version $appVersion ($buildNumber)',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'All Rights Reserved.',
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