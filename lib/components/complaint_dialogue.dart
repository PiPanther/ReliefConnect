import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/models/complaint_model.dart';
import 'package:frs/providers/Complaints/complaint_provider.dart';

class ComplaintDialog extends ConsumerWidget {
  final ComplaintModel complaint;
  final bool temp;

  const ComplaintDialog({Key? key, required this.complaint, required this.temp})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintProvider = ref.read(complaintServiceProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kblue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Complaint ID
              Text(
                'Complaint ID: ${complaint.complaint_id}',
                style: TextStyle(fontWeight: FontWeight.bold, color: kpink),
              ),
              const SizedBox(height: 10),

              // Location (Latitude and Longitude)

              Text('Latitude: ${complaint.lattitude.toStringAsFixed(6)}'),
              Text('Longitude: ${complaint.longitude.toStringAsFixed(6)}'),
              const SizedBox(height: 10),

              // List of images (URLs)

              const SizedBox(height: 10),

              // Emergency Type
              Text(
                'Emergency Type: ${complaint.emergencyType}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Is Active (Complaint status)
              Row(
                children: [
                  const Text('Active Status:'),
                  const SizedBox(width: 8),
                  Icon(
                    complaint.active ? Icons.check_circle : Icons.cancel,
                    color: complaint.active ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Temp Value (Boolean)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: complaint.imgs.length,
                  itemBuilder: (context, index) {
                    print(complaint.imgs[index]);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        complaint.imgs[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(2.0),
                      backgroundColor: WidgetStatePropertyAll(Colors.pink)),
                  onPressed: () async {
                    await complaintProvider.deleteComplaint(complaint.user_id);
                    Navigator.pop(context);
                  },
                  label: Text(
                    'Delete Complaint',
                    style: TextStyling()
                        .styleh3
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: const ButtonStyle(
                      elevation: WidgetStatePropertyAll(2.0),
                      backgroundColor: WidgetStatePropertyAll<Color>(kblue)),
                  onPressed: () async {
                    await complaintProvider.resolveComplaint(complaint.user_id);
                    Navigator.pop(context);
                  },
                  label: Text(
                    'Resolve Complaint',
                    style: TextStyling()
                        .styleh3
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
