import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/screens/homescreen.dart';
import 'package:frs/services/authentication/auth_servicec.dart';

class SignInPage2 extends ConsumerWidget {
  const SignInPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Center(
            child: isSmallScreen
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _Logo(),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Row(
                      children: const [
                        Expanded(child: _Logo()),
                      ],
                    ),
                  )));
  }
}

class _Logo extends ConsumerWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    final googleSignInService = ref.read(googleSignInProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FilledButton.icon(
            onPressed: () async {
              User? user = await googleSignInService.signInWithGoogle();

              if (user != null) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Homescreen()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Error Signing In"),
                ));
              }
            },
            label: const Text('Sign In with Google')),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Flutter!",
            textAlign: TextAlign.center,
            style: isSmallScreen
                ? Theme.of(context).textTheme.bodyLarge
                : Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black),
          ),
        )
      ],
    );
  }
}
