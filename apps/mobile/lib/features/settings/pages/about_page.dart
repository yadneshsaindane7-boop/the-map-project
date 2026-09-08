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
            'For now, you can report bugs directly to the developer using the Contact Developer option.',
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

  Widget sectionTitle(
    BuildContext context,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        top: 8,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 120,
                height: 120,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'The Map Project',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              'Community Powered Smart Navigation',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 16),

            Chip(
              avatar: const Icon(Icons.verified),
              label: Text(
                'Version $appVersion ($buildNumber)',
              ),
            ),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Published by',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'HLP - Hibro Lab Productions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'The Map Project is a community-powered navigation platform designed to provide real-time road conditions, road closures, traffic incidents and intelligent route guidance using community reports and modern mapping technologies.',
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle(
              context,
              'Development Team',
            ),

            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(
                      Icons.school,
                    ),
                    title: Text(
                      'Prof - R. V. Daund',
                    ),
                    subtitle: Text(
                      'Project Guide',
                    ),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(
                      Icons.code,
                    ),
                    title: Text(
                      'Yadnesh Saindane',
                    ),
                    subtitle: Text(
                      'Lead Developer',
                    ),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(
                      Icons.description,
                    ),
                    title: Text(
                      'Namrata Wagh',
                    ),
                    subtitle: Text(
                      'Project Documentation',
                    ),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(
                      Icons.science,
                    ),
                    title: Text(
                      'Umesh Suryawanshi',
                    ),
                    subtitle: Text(
                      'Research & Field Validation',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle(
              context,
              'Technology Stack',
            ),

            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.flutter_dash),
                    title: Text('Framework'),
                    subtitle: Text('Flutter'),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.storage),
                    title: Text('Backend'),
                    subtitle: Text('Supabase'),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Maps'),
                    subtitle: Text(
                      'Flutter Map + OpenStreetMap',
                    ),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.route),
                    title: Text('Routing'),
                    subtitle: Text(
                      'Custom FastAPI + A* Nashik Road Graph',
                    ),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.code),
                    title: Text('Programming Language'),
                    subtitle: Text('Dart'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle(
              context,
              'Core Features',
            ),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        'Community Incident Reporting',
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        'Real-Time Traffic Alerts',
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        'Road Closure Detection',
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        'Smart Route Navigation',
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        'Community Verification',
                      ),
                    ),

                    ListTile(
                      leading: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      title: Text(
                        'User Profiles & Statistics',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle(
              context,
              'Project Information',
            ),

            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.public),
                    title: Text('Status'),
                    subtitle: Text(
                      'Active Development',
                    ),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.business),
                    title: Text('Publisher'),
                    subtitle: Text(
                      'HLP - Hibro Lab Productions',
                    ),
                  ),

                  Divider(height: 1),

                  ListTile(
                    leading: Icon(Icons.workspace_premium),
                    title: Text('License'),
                    subtitle: Text(
                      'Educational & Research Project',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            sectionTitle(
              context,
              'Support',
            ),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.bug_report),
                label: const Text(
                  'Report a Bug',
                ),
                onPressed: () {
                  _reportBug(context);
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.email),
                label: const Text(
                  'Contact Developer',
                ),
                onPressed: () {
                  _contactDeveloper(context);
                },
              ),
            ),

            const SizedBox(height: 24),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.corporate_fare,
                      size: 42,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'HLP - Hibro Lab Productions',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'The Map Project is a product developed and maintained by HLP - Hibro Lab Productions.',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    const Divider(),

                    const SizedBox(height: 12),

                    const Text(
                      'Developer Contact',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    SelectableText(
                      'yadneshsaindane7@gmail.com',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: Colors.blue,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              '© 2026 HLP - Hibro Lab Productions',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              'The Map Project\nVersion $appVersion ($buildNumber)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 6),

            const Text(
              'All Rights Reserved.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}