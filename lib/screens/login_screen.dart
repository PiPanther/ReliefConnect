import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/screens/homescreen.dart';
import 'package:frs/providers/Authentication/auth_servicec.dart';
import 'package:frs/services/campaigns/campaign_gate.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final googleSignInService = ref.read(googleSignInProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 1.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height * 0.50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ReleifConnect",
                    style:
                        GoogleFonts.flamenco(color: Colors.white, fontSize: 32),
                  ),
                  Text(
                    "Disaster Assistance Service",
                    style:
                        GoogleFonts.flamenco(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: kblack,
            height: MediaQuery.of(context).size.height * 0.50,
            child: SizedBox(
              width: double.infinity,
              height: 20,
              child: TextButton.icon(
                style: const ButtonStyle(
                    elevation: WidgetStatePropertyAll(2.0),
                    backgroundColor: WidgetStatePropertyAll(Colors.pink)),
                onPressed: () async {
                  await googleSignInService.signInWithGoogle();
                  Navigator.pushReplacementNamed(context, '/homescreen');
                },
                label: Text(
                  'Login with Google',
                  style: TextStyling()
                      .styleh3
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
