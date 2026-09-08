import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() =>
      _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguageCode = 'en';

  final List<_LanguageOption> _languages = const [
    _LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
    ),
    _LanguageOption(
      code: 'hi',
      name: 'Hindi',
      nativeName: 'हिन्दी',
    ),
    _LanguageOption(
      code: 'mr',
      name: 'Marathi',
      nativeName: 'मराठी',
    ),
    _LanguageOption(
      code: 'gu',
      name: 'Gujarati',
      nativeName: 'ગુજરાતી',
    ),
    _LanguageOption(
      code: 'bn',
      name: 'Bengali',
      nativeName: 'বাংলা',
    ),
    _LanguageOption(
      code: 'ta',
      name: 'Tamil',
      nativeName: 'தமிழ்',
    ),
    _LanguageOption(
      code: 'te',
      name: 'Telugu',
      nativeName: 'తెలుగు',
    ),
    _LanguageOption(
      code: 'kn',
      name: 'Kannada',
      nativeName: 'ಕನ್ನಡ',
    ),
    _LanguageOption(
      code: 'ml',
      name: 'Malayalam',
      nativeName: 'മലയാളം',
    ),
    _LanguageOption(
      code: 'pa',
      name: 'Punjabi',
      nativeName: 'ਪੰਜਾਬੀ',
    ),
  ];

  void _selectLanguage(String code) {
    setState(() {
      _selectedLanguageCode = code;
    });
  }

  void _saveLanguage() {
    final selected = _languages.firstWhere(
      (language) =>
          language.code == _selectedLanguageCode,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${selected.nativeName} selected.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedLanguage = _languages.firstWhere(
      (language) =>
          language.code == _selectedLanguageCode,
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Choose your preferred language',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          14,
          16,
          28,
        ),
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.translate_rounded,
                      color:
                          colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Language',
                          style: theme
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                            color: colorScheme
                                .onSurfaceVariant,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          selectedLanguage.nativeName,
                          style: theme
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Available Languages',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            child: RadioGroup<String>(
              groupValue: _selectedLanguageCode,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                _selectLanguage(value);
              },
              child: Column(
                children: [
                  for (int index = 0;
                      index < _languages.length;
                      index++) ...[
                    _LanguageTile(
                      language: _languages[index],
                    ),
                    if (index != _languages.length - 1)
                      const _LanguageDivider(),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          FilledButton.icon(
            onPressed: _saveLanguage,
            icon: const Icon(
              Icons.check_rounded,
            ),
            label: Text(
              'Save ${selectedLanguage.nativeName}',
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Language selection will be applied to the app in a future update.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
  });

  final _LanguageOption language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme
              .colorScheme
              .surfaceContainerHighest,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(
          Icons.language_rounded,
          size: 21,
          color: theme.colorScheme.primary,
        ),
      ),
      title: Text(
        language.nativeName,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        language.name,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Radio<String>(
        value: language.code,
      ),
    );
  }
}

class _LanguageDivider extends StatelessWidget {
  const _LanguageDivider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Divider(
      height: 1,
      indent: 68,
      endIndent: 16,
      color: theme.dividerColor,
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  final String code;
  final String name;
  final String nativeName;
}