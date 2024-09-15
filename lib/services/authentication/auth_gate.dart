import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/screens/homescreen.dart';
import 'package:frs/screens/login_screen.dart';
import 'package:frs/services/authentication/auth_servicec.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(data: (user) {
      if (user != null) {
        return const Homescreen();
      } else {
        return const SignInPage2();
      }
    }, error: (error, stacktrace) {
      return Text(error.toString());
    }, loading: () {
      return const CircularProgressIndicator();
    });
  }
}
