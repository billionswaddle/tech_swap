import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';
import '../pages/profile_page.dart';

bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

class AccountGate {
  static Future<void> requireLogin(
      BuildContext context, {
        required VoidCallback onAuthenticated,
      }) async {
    if (isLoggedIn) {
      onAuthenticated();
      return;
    }

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );

    if (result == true) {
      onAuthenticated();
    }
  }

  // Updated to wait for result and redirect to Profile
  static Future<void> openAccount(BuildContext context) async {
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );

      // If login or signup was successful, navigate to ProfilePage
      if (result == true && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
      }
    }
  }
}
