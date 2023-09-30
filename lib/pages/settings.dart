import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refectify/theme_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';
  String selectedRegion = 'US';
  int notesAddedLastWeek = 10; // Replace with actual data
  int notesAddedYesterday = 3; // Replace with actual data
  int notesAddedLastMonth = 30; // Replace with actual data

  // Firebase authentication and database logic can be integrated here.

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // After signing out, navigate to the login page or another screen.
    if (!mounted) return;
    Navigator.popAndPushNamed(context, '/auth');
  }

  Future<void> _exportNotes() async {
    // Implement the logic to export notes here.
    // You can use packages like pdf, csv, or others to export notes in different formats
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'App Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text('Dark Mode',
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: Switch(
                value: themeProvider.isDarkTheme,
                onChanged: (bool value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            ListTile(
              title: Text('Notifications',
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    notificationsEnabled = value;
                    // Implement notification settings here.
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Language',
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: DropdownButton<String>(
                style: Theme.of(context).textTheme.bodyMedium,
                value: selectedLanguage,
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                items: ['English', 'Spanish', 'French'].map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language,
                        style: Theme.of(context).textTheme.bodyMedium),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (null != newValue) {
                    setState(() {
                      selectedLanguage = newValue;
                      // Implement language change logic here.
                    });
                  }
                },
              ),
            ),
            ListTile(
              title:
                  Text('Region', style: Theme.of(context).textTheme.bodyMedium),
              trailing: DropdownButton<String>(
                value: selectedRegion,
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                items: ['US', 'UK', 'Canada'].map((String region) {
                  return DropdownMenuItem<String>(
                    value: region,
                    child: Text(region,
                        style: Theme.of(context).textTheme.bodyMedium),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (null != newValue) {
                    setState(() {
                      selectedRegion = newValue;
                      // Implement region change logic here.
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Note Statistics',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            ListTile(
              title: Text('Notes Added Last Week',
                  style: Theme.of(context).textTheme.bodyMedium),
              subtitle: Text('$notesAddedLastWeek notes',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              title: Text('Notes Added Yesterday',
                  style: Theme.of(context).textTheme.bodyMedium),
              subtitle: Text('$notesAddedYesterday notes',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              title: Text('Notes Added Last Month',
                  style: Theme.of(context).textTheme.bodyMedium),
              subtitle: Text('$notesAddedLastMonth notes',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exportNotes,
              child: const Text('Export Notes'),
            ),
            const Spacer(),
            ListTile(
              title:
                  Text('Logout', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () async {
                await _signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
