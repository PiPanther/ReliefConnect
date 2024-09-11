import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/services/authentication/auth_servicec.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(user!.displayName!),
        actions: [
          IconButton(
              onPressed: () async {
                await ref.read(googleSignInProvider).signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
