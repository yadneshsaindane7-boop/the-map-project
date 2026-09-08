import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/services/notification_service.dart';
import 'core/services/supabase_service.dart';

import 'features/auth/pages/login_page.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/navigation/pages/shell_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();
  await NotificationService.instance.initialize();

  runApp(
    const ProviderScope(
      child: TheMapProject(),
    ),
  );
}

class TheMapProject extends ConsumerStatefulWidget {
  const TheMapProject({super.key});

  @override
  ConsumerState<TheMapProject> createState() =>
      _TheMapProjectState();
}

class _TheMapProjectState
    extends ConsumerState<TheMapProject> {
  @override
  void initState() {
    super.initState();

    Supabase.instance.client.auth.onAuthStateChange.listen(
      (event) async {
        if (event.session != null) {
          await ref
              .read(authServiceProvider)
              .syncLoggedInUser();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      home: StreamBuilder<AuthState>(
        stream: Supabase
            .instance
            .client
            .auth
            .onAuthStateChange,
        builder: (context, snapshot) {
          final session = Supabase
              .instance
              .client
              .auth
              .currentSession;

          if (session != null) {
            return const ShellPage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}