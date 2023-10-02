import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refectify/main.dart';
import 'package:refectify/theme_notifier.dart';
import 'package:refectify/pages/components/pdftool.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String freqVal = 'Never';
  String selectedLanguage = 'English';
  String selectedRegion = 'US';
  int notesAddedLastWeek = 10;
  int notesAddedYesterday = 3;
  int notesAddedLastMonth = 30;

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.popAndPushNamed(context, '/auth');
  }

  Future<void> makeNotification(DateTime dateTime) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'reminderNotifications', 'Reminder Notifications',
            channelDescription: 'time to add your notes');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder from Refectify',
      'Its time to add your notes in Refectify',
      notificationDetails,
    );
  }

  Future<void> scheduleNotification(DateTime dateTime) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    if ('Never' == freqVal) {
      return;
    } else {
      await makeNotification(dateTime);
      if ('Twice' == freqVal) {
        await makeNotification(dateTime.add(const Duration(hours: 12)));
      }
      if ('Thrice' == freqVal) {
        await makeNotification(dateTime.add(const Duration(hours: 8)));
        await makeNotification(dateTime.add(const Duration(hours: 16)));
      }
    }
  }

  Future<void> exportNotes() async {
    const pdfText = 'sample text';
    PDFTools.generateCenteredText(pdfText);
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
              title: Text('Notifications(Daily)',
                  style: Theme.of(context).textTheme.bodyMedium),
              trailing: DropdownButton<String>(
                style: Theme.of(context).textTheme.bodyMedium,
                value: freqVal,
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                items: ['Never', 'Once', 'Twice', 'Thrice'].map((String freq) {
                  return DropdownMenuItem<String>(
                    value: freq,
                    child: Text(freq,
                        style: Theme.of(context).textTheme.bodyMedium),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (null != newValue) {
                    setState(() {
                      freqVal = newValue;
                    });
                    scheduleNotification(DateTime.now());
                  }
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
              onPressed: exportNotes,
              child: const Text('Export Notes'),
            ),
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
