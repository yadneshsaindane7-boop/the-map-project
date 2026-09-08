import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 650;

            final topSpacing = isCompact
                ? 24.0
                : (constraints.maxHeight * 0.12).clamp(32.0, 100.0);

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  24,
                ),
                child: Column(
                  children: [
                    SizedBox(height: topSpacing),

                    // App branding
                    Container(
                      width: isCompact ? 82 : 92,
                      height: isCompact ? 82 : 92,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(
                              alpha: 0.14,
                            ),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.map_rounded,
                        size: isCompact ? 48 : 54,
                        color: colorScheme.primary,
                      ),
                    ),

                    SizedBox(
                      height: isCompact ? 18 : 22,
                    ),

                    Text(
                      'The Map Project',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Real-time Road Intelligence',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 320,
                      ),
                      child: Text(
                        'Navigate smarter with live road information '
                        'and community-powered alerts.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: isCompact ? 24 : 34,
                    ),

                    // Feature highlights
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          _FeatureItem(
                            icon: Icons.traffic_outlined,
                            label: 'Live Traffic',
                          ),
                          _FeatureDivider(
                            color: colorScheme.outlineVariant,
                          ),
                          _FeatureItem(
                            icon: Icons.alt_route_rounded,
                            label: 'Smart Routes',
                          ),
                          _FeatureDivider(
                            color: colorScheme.outlineVariant,
                          ),
                          _FeatureItem(
                            icon: Icons.groups_outlined,
                            label: 'Community',
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: isCompact ? 28 : 42,
                    ),

                    // Sign-in section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Get started',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign in to access your personalized map experience.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Material(
                      elevation: 3,
                      shadowColor: Colors.black26,
                      borderRadius: BorderRadius.circular(16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 58,
                          width: double.infinity,
                          child: AuthButton(
                            onPressed: () async {
                              await ref
                                  .read(authServiceProvider)
                                  .signInWithGoogle();
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Secure sign-in with Google',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'By continuing, you agree to use the app responsibly.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 22,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureDivider extends StatelessWidget {
  const _FeatureDivider({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: color,
    );
  }
}