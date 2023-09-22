import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:refectify/pages/editing.dart';
import '../reuseable_widgets/note_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int idx = 0;
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // After signing out, navigate to the login page or another screen.
    Navigator.popAndPushNamed(context, '/auth');
  }

  static const List<Widget> pages = <Widget>[
    HomePage(),
    // EditorPage(),
    HomePage(),
    HomePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.black54,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _signOut(context);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          color: Colors.black54,
                          blurRadius: 10.0,
                          blurStyle: BlurStyle.outer),
                    ],
                    color: Colors.grey[900],
                  ),
                  height: 100.0,
                  width: 330.0,
                  child: Text(
                    "Good Evening, ${FirebaseAuth.instance.currentUser!.displayName}!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView(
                children: const [
                  NoteCard(),
                  NoteCard(),
                  NoteCard(),
                  NoteCard(),
                  NoteCard(),
                  NoteCard(),
                  NoteCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
