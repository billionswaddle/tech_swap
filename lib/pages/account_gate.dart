import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';
import '../pages/profile_page.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder listens to Firebase in real-time.
    // As soon as a user signs up or logs in, this builder runs again automatically.
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. While Firebase is checking the connection...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          );
        }

        // 2. If the user is logged in, show the ProfilePage.
        if (snapshot.hasData && snapshot.data != null) {
          return const ProfilePage();
        }

        // 3. If NOT logged in, show the LoginPage.
        // When they finish Login or Signup, the stream above will update
        // and switch the view to ProfilePage automatically.
        return const LoginPage();
      },
    );
  }
}