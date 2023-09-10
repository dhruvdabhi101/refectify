import 'package:flutter/material.dart';
import 'package:refectify/pages/editing.dart';
import 'package:refectify/pages/home.dart';
import 'package:refectify/pages/onboarding.dart';

void main() {
  runApp(const MyApp());
}

bool initScreen = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[800],
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.grey[300], fontSize: 18),
          bodyLarge: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28.0),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[900],
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: initScreen ? '/onboarding' : '/home',
      routes: {
        '/onboarding': (context) => OnboardingPage(),
        '/home': (context) => HomePage(),
        '/noteCreate': (context) => EditorPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
