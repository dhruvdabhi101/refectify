/// This file contains the main function and the MyApp class which is the root widget of the app.
/// It also imports all the necessary packages and files, initializes Firebase and Flutter Local Notifications,
/// and sets the app's theme based on the user's preference.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:refectify/firebase_options.dart';
import 'package:refectify/pages/auth/auth.dart';
import 'package:refectify/pages/components/notepage.dart';
import 'package:refectify/pages/editing.dart';
import 'package:refectify/pages/home.dart';
import 'package:refectify/pages/onboarding.dart';
import 'package:refectify/pages/settings.dart';
import 'package:provider/provider.dart';
import 'package:refectify/theme_notifier.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  const initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  // final initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    // iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData getTheme(BuildContext context, bool isdark) {
    if (isdark) {
      return ThemeData(
        useMaterial3: true,
        primaryColor: const Color.fromARGB(255, 50, 49, 49),
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.white, fontSize: 14),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 18),
          bodyLarge: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.grey,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          surfaceTintColor: Colors.black,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[900],
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54),
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        primaryColor: Colors.grey[200],
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.black, fontSize: 14),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 18),
          bodyLarge: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 28.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[100],
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.grey,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black54,
        ),
      );
    }
    // return ThemeData();
  }

  setTheme(ThemeProvider themeProvider) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isDark = sharedPreferences.getBool('isDark') ?? true;
    themeProvider.setTheme(isDark);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    setTheme(themeProvider);
    final themeData = themeProvider.isDarkTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: getTheme(context, themeData),
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/home': (context) => const Home(),
        '/noteCreate': (context) => const EditorPage(),
        '/settings': (context) => const SettingsPage(),
        '/noteHome': (context) => const NotePage(),
      },
    );
  }
}
