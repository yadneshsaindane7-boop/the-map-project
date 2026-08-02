import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  Future<void> _logout(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signOut();

      if (!context.mounted) {
        return;
      }

      Navigator.of(context).pushNamedAndRemoveUntil(
        '/',
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Logout failed\n$e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => _logout(context),
      style: FilledButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          55,
        ),
        backgroundColor: Colors.red,
      ),
      icon: const Icon(Icons.logout),
      label: const Text(
        'Logout',
      ),
    );
  }
}