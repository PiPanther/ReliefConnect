import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/models/campaign.dart';
import 'package:frs/providers/Campaigns/campaign_provider.dart';
import 'package:frs/screens/payment_screen.dart';
import 'package:frs/services/campaigns/campaign_gate.dart';

class CampaignHomepage extends ConsumerWidget {
  const CampaignHomepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                style: const ButtonStyle(
                    elevation: WidgetStatePropertyAll(2.0),
                    backgroundColor: WidgetStatePropertyAll(Colors.pink)),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CampaignGate()));
                },
                label: Text(
                  'Start your own campaign',
                  style: TextStyling()
                      .styleh3
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          StreamBuilder<List<Campaign>>(
            stream: ref.watch(campaignListProvider),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No campaigns available.'));
              } else {
                final campaigns = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: campaigns.length,
                    itemBuilder: (context, index) {
                      final campaign = campaigns[index];
                      return CardWidget(campaign: campaign);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.campaign,
  });

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kpink, style: BorderStyle.solid)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    campaign.thumbnail,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.firmName,
                      style: TextStyling().styleh2.copyWith(
                          color: kpink,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(campaign.ownerName,
                        style: TextStyling().stylep1.copyWith(
                            color: kblack, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: kpink,
                            ),
                            Text(
                              campaign.address,
                              style: TextStyling().stylep1.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.nest_cam_wired_stand_rounded,
                              size: 12,
                              color: kpink,
                            ),
                            Text(
                              campaign.gst,
                              style: TextStyling().stylep1.copyWith(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PayymentScreen(campaign: campaign);
                      },
                    ),
                  );
                },
                icon: Image.asset(
                  color: kpink,
                  "lib/assets/icons/donate.png",
                  height: 32,
                )),
          ],
        ),
      ),
    );
  }
}
