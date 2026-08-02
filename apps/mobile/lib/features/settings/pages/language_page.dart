import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: RadioGroup<String>(
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _selectedLanguage = value;
                });
              },
              child: Column(
                children: const [
                  RadioListTile<String>(
                    value: 'English',
                    title: Text('English'),
                  ),
                  RadioListTile<String>(
                    value: 'Marathi',
                    title: Text('Marathi'),
                  ),
                  RadioListTile<String>(
                    value: 'Hindi',
                    title: Text('Hindi'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  55,
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Language set to $_selectedLanguage (temporary)',
                    ),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}