import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Icon(
            Icons.map,
            size: 80,
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'The Map Project',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Version 1.0.0',
            ),
          ),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Developer'),
            subtitle: Text('Yadnesh Saindane'),
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Course'),
            subtitle: Text('SYBCA • SPPU'),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text('Technology'),
            subtitle: Text('Flutter • Supabase'),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Made with'),
            subtitle: Text('❤️ in India'),
          ),
        ],
      ),
    );
  }
}