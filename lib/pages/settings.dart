import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import 'package:refectify/main.dart';
import 'package:refectify/pages/components/backup.dart';
import 'package:refectify/pages/components/note.dart';
import 'package:refectify/pages/components/note_manager.dart';
import 'package:refectify/theme_notifier.dart';
import 'package:refectify/pages/components/pdftool.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String freqVal = 'Never';
  bool isDark = true;
  int notesAddedLastWeek = 0;
  int notesAddedYesterday = 0;
  int notesAddedLastMonth = 0;

  @override
  void initState() {
    super.initState();
    setPreferences();
    getStatics();
  }

  void setPreferences() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    setState(() {
      freqVal = sharedPreferences.getString('freqVal') ?? 'Never';
      isDark = sharedPreferences.getBool('isDark') ?? true;
    });
  }

  changeTheme(bool isDark) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setBool('isDark', isDark);
  }

  _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.popAndPushNamed(context, '/auth');
  }

  getStatics() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    NoteManager noteManager = NoteManager(sharedPreferences);
    List<Note> notes = noteManager.getNotes();
    setState(() {
      for (Note note in notes) {
        if (note.creationDate
            .isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
          notesAddedLastWeek++;
        }
        if (note.creationDate
            .isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
          notesAddedYesterday++;
        }
        if (note.creationDate
            .isAfter(DateTime.now().subtract(const Duration(days: 30)))) {
          notesAddedLastMonth++;
        }
      }
    });
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('freqVal', freqVal);
  }

  shareNotes() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    NoteManager noteManager = NoteManager(sharedPreferences);
    List<Note> notes = noteManager.getNotes();
    String pdfText = '';
    for (Note note in notes) {
      String noteContent = quill.Document.fromJson(jsonDecode(note.content))
          .toPlainText();
      pdfText += '${note.title}\n${note.creationDate}\n$noteContent\n\n';
    }
    PDFTools.generateCenteredText(pdfText);
  }

  backupNotes() async {
    bool res = await BackupData.backup();
    if(res){
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup Successful'),
        ),
      );
    }
    else{
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup Failed'),
        ),
      );
    }
  }

  restoreNotes() async {
    BackupData.restore();
  }

  getChildren() {
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (isLoggedIn) {
      return [
        ElevatedButton(
          onPressed: backupNotes,
          child: const Text('Export Notes'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: restoreNotes,
          child: const Text('Import Notes'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _signOut,
          child: const Text('Sign Out'),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          child: const Text('Login For more Features'),
          onPressed: ()  {
            Navigator.popAndPushNamed(context, '/auth');
          },
        ),
      ];
    }
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
                  changeTheme(value);
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
            Column(
              children: getChildren(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: shareNotes,
              child: const Text('Share as pdf'),
            ),
          ],
        ),
      ),
    );
  }
}
