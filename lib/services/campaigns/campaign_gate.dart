import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/providers/campaigns/campaign_provider.dart';
import 'package:frs/screens/campaign_homepage.dart';
import 'package:frs/screens/campaign_registation.dart';

class CampaignGate extends ConsumerWidget {
  const CampaignGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: ref.watch(donationRepositoryProvider).doesUserDocumentExist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            return const CampaignHomepage();
          }

          return const CampaignRegistationScreen();
        });
  }
}
