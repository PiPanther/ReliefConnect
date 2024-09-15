import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/providers/campaigns/campaign_provider.dart';
import 'package:frs/services/authentication/auth_servicec.dart';

class CampaignRegistationScreen extends ConsumerWidget {
  const CampaignRegistationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final campaign = ref.watch(donationRepositoryProvider);
    final firmNameController = TextEditingController();
    final ownerNameController = TextEditingController();
    final addressController = TextEditingController();
    final panController = TextEditingController();
    final gstController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(user!.displayName!),
      ),
      body: Column(
        children: [
          TextFormField(
            autofillHints: Iterable.empty(),
            controller: firmNameController,
            decoration: const InputDecoration(hintText: 'Firm Name'),
          ),
          TextFormField(
            autofillHints: Iterable.empty(),
            controller: ownerNameController,
            decoration: const InputDecoration(hintText: 'Owner Name'),
          ),
          TextFormField(
            autofillHints: Iterable.empty(),
            controller: addressController,
            decoration: const InputDecoration(hintText: 'Address'),
          ),
          TextFormField(
            autofillHints: Iterable.empty(),
            decoration: const InputDecoration(hintText: 'PAN'),
            controller: panController,
          ),
          TextFormField(
            autofillHints: Iterable.empty(),
            decoration: const InputDecoration(hintText: 'GST'),
            controller: gstController,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await campaign.pickAndUploadThumbnail();
                      print("Success !");
                    } catch (e) {
                      print("Error: $e");
                      rethrow;
                    }
                  },
                  child: Text("Upload Thumbnail")),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await campaign.pickAndUploadMultipleImages();
                      print('Success!');
                    } catch (e) {
                      print("Error : ${e.toString()}");
                      rethrow;
                    }
                  },
                  child: Text("Upload Images")),
            ],
          ),
          TextButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/campaignHomePage');
              },
              child: const Text('Submit details')),
        ],
      ),
    );
  }
}
