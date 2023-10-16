import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:refectify/pages/components/note.dart';
import 'package:refectify/pages/components/note_manager.dart';
import 'package:refectify/pages/settings.dart';
import 'package:refectify/pages/editing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reuseable_widgets/note_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int idx = 0;
  static const List<Widget> pages = <Widget>[
    HomePage(),
    // EditorPage(),
    EditorPage(),
    SettingsPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.create), label: "Create Note"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: idx,
        onTap: (value) => {
          setState(() {
            idx = value;
          })
        },
      ),
      body: IndexedStack(
        index: idx,
        children: pages,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];
  String getStateOfDay() {
    int hour = DateTime.now().hour;
    if (12 > hour && hour > 4) {
      return "Morning";
    } else if (16 > hour && hour > 12) {
      return "Afternoon";
    } else if (20 > hour && hour > 16) {
      return "Evening";
    } else {
      return "Night";
    }
  }
  @override
  void initState() {
    super.initState();
    getNotes();
  }
  
  getNotes() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    NoteManager noteManager = NoteManager(sharedPreferences);
    notes = noteManager.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black87,
                          blurRadius: 10.0,
                          blurStyle: BlurStyle.outer),
                    ],
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  height: 100.0,
                  width: 330.0,
                  child: Text(
                    "Good ${getStateOfDay()}, ${FirebaseAuth.instance.currentUser!.displayName}!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return NoteCard(notes[index]);
                },
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
