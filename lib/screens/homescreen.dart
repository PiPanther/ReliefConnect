import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/providers/campaigns/campaign_provider.dart';
import 'package:frs/services/authentication/auth_servicec.dart';
import 'package:frs/services/campaigns/campaign_gate.dart';

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(authStateProvider);

    return asyncUser.when(
      data: (user) => _buildScaffold(context, ref, user),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref, User? user) {
    final campaignList = ref.read(campaignListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(user?.displayName ?? 'Welcome'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await ref.read(googleSignInProvider).signOut();
                Navigator.pushNamed(context, '/loginScreen');

                // Navigate to login screen or show a success message
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error signing out: $e')),
                );
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton.icon(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CampaignGate()));
              },
              label: Text('Start your own campaign'),
            ),
          ),
          TextButton(
              onPressed: () async {
                campaignList.when(
                    data: (data) => print(data.first.ownerName),
                    error: (error, stackTrace) {},
                    loading: () => const CircularProgressIndicator());
              },
              child: Text("Get campaigns list")),
        ],
      ),
    );
  }
}
