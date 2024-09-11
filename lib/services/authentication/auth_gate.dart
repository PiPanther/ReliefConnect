import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frs/screens/homescreen.dart';
import 'package:frs/screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data!.displayName);
            return const Homescreen();
          } else if (ConnectionState.waiting == snapshot.connectionState) {
            return const Center(child: Text("Please wait..."));
          } else {
            return const SignInPage2();
          }
        },
      ),
    );
  }
}
