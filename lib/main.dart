import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:refectify/firebase_options.dart';
import 'package:refectify/pages/auth/auth.dart';
import 'package:refectify/pages/editing.dart';
import 'package:refectify/pages/home.dart';
import 'package:refectify/pages/onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

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
          bodyLarge: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28.0),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[900],
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/home': (context) => const Home(),
        '/noteCreate': (context) => const EditorPage(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
