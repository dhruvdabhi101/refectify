/// A page that displays either the onboarding page or the home page based on the user's authentication state.
/// 
/// If the user is authenticated, the home page is displayed. Otherwise, the onboarding page is displayed.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:refectify/pages/home.dart';
import 'package:refectify/pages/onboarding.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return const OnboardingPage();
          }
        },
      ),
    );
  }
}
