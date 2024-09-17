import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/models/donation_taker.dart';
import 'package:frs/providers/Campaigns/campaign_provider.dart';
import 'package:frs/providers/Authentication/auth_servicec.dart';

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
    final upiController = TextEditingController();
    late String thumbnail;
    late List<String> images;

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
          TextFormField(
            autofillHints: Iterable.empty(),
            decoration: const InputDecoration(hintText: 'UPI Id'),
            controller: upiController,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    try {
                      thumbnail = await campaign.pickAndUploadThumbnail() ??
                          "https://st2.depositphotos.com/3904951/8925/v/450/depositphotos_89250312-stock-illustration-photo-picture-web-icon-in.jpg";
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
                      images = await campaign.pickAndUploadMultipleImages();
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
                DonationTaker donationTaker = DonationTaker(
                  id: user!.uid,
                    firmName: firmNameController.text.trim(),
                    upi: upiController.text.trim(),
                    firmAddress: addressController.text.trim(),
                    ownerName: firmNameController.text.trim(),
                    pan: panController.text.trim(),
                    donationAmount: 0,
                    donationsBy: [],
                    gst: gstController.text.trim(),
                    thumbnail: thumbnail,
                    imageUrls: images);
                print(donationTaker.imageUrls);
                print(donationTaker.thumbnail);
                await campaign.addCampaign(donationTaker);

                Navigator.pushReplacementNamed(context, '/campaignHomePage');
              },
              child: const Text('Submit details')),
        ],
      ),
    );
  }
}
