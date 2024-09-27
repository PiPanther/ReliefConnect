import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/components/complaint_dialogue.dart';
import 'package:frs/components/cpi.dart';
import 'package:frs/components/register_complaint.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/models/complaint_model.dart';
import 'package:frs/providers/Complaints/complaint_provider.dart';

class DonationsScreen extends ConsumerWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintService = ref.watch(complaintServiceProvider);
   
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                          builder: (context) => ComplaintRegistrationScreen()));
                },
                label: Text(
                  'Register Complaint',
                  style: TextStyling()
                      .styleh3
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const Text("Active"),
          StreamBuilder(
            stream: complaintService.getActiveComplaints(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CPI();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No Active complaints found"),
                );
              }

              final complaints = snapshot.data!;
              return EmergencyCardList(complaints);
            },
          ),
          const Text("Resolved"),
          StreamBuilder(
            stream: complaintService.getResolvedComplaints(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CPI();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(""),
                );
              }
              final complaints = snapshot.data!;
              return EmergencyCardList(complaints);
            },
          ),
        ],
      ),
    );
  }

  Expanded EmergencyCardList(List<ComplaintModel> complaints) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: complaints.length,
          itemBuilder: (context, index) {
            final complaint = complaints[index];
            return ListTile(
              title: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kpink, style: BorderStyle.solid)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              complaint.emergencyType.toString(),
                              style: TextStyling().styleh2.copyWith(
                                  color: kpink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Text(complaint.description,
                                style: TextStyling().stylep1.copyWith(
                                    color: kblack,
                                    fontWeight: FontWeight.bold)),
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
                                      complaint.createdAt.toLocal().toString(),
                                      style: TextStyling().stylep1.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
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
                                      complaint.active ? "Active" : "Resolved",
                                      style: TextStyling().stylep1.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton.outlined(
                      enableFeedback: true,
                      color: Colors.pink,
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(kpink)),
                      onPressed: () {
                        debugPrint(complaints.first.imgs.length.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ComplaintDialog(
                                    complaint: complaint, temp: true)));
                      },
                      icon: Text(
                        "View",
                        style:
                            TextStyling().stylep1.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
