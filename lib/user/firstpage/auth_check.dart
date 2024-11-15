import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emib_hospital/user/firstpage/login.dart';
import 'package:emib_hospital/main.dart';
import 'package:emib_hospital/user/firstpage/auth_service.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final isLoggedIn = snapshot.data ?? false;

        if (isLoggedIn) {
          return FirebaseAuth.instance.currentUser != null
              ? MainScreen(userId: FirebaseAuth.instance.currentUser?.uid)
              : const LoginPage();
        }

        return const LoginPage();
      },
    );
  }
}
