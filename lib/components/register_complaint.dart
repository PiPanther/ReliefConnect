import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/enums.dart';
import 'package:frs/constants/pallette.dart';
import 'package:frs/models/complaint_model.dart';
import 'package:frs/providers/Authentication/auth_servicec.dart';
import 'package:frs/providers/Complaints/complaint_provider.dart';
import 'package:frs/providers/EmergencyType/emergency_type_provider.dart';
import 'package:frs/providers/Location/location_provider.dart';

class ComplaintRegistrationScreen extends ConsumerWidget {
  ComplaintRegistrationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationProvider = ref.watch(locationPrvider);
    final userProvider = ref.watch(currentUserProvider);
    final complaintService = ref.watch(complaintServiceProvider);
    final user = userProvider!.uid;
    final selectedEmergencyType = ref.watch(selectedEmergencyTypeProvider);

    late List<String>? images = [];

    TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: kblue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    subtitle: Text(
                      user,
                      style: TextStyling().stylep1,
                    ),
                    title: Text(
                      "Complaint Id",
                      style: TextStyling().stylep1,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Type : ",
                      style:
                          TextStyling().styleh3.copyWith(color: Colors.black),
                    ),
                    subtitle: DropdownButton<EmergencyType>(
                      onTap: () {
                        print(ref
                            .read(selectedEmergencyTypeProvider.notifier)
                            .state
                            .toString()
                            .toString()
                            .split('.')
                            .last);
                      },
                      style: TextStyling().stylep1,
                      icon: const Icon(Icons.arrow_downward_rounded),
                      value: selectedEmergencyType,
                      onChanged: (EmergencyType? newValue) {
                        if (newValue != null) {
                          ref
                              .read(selectedEmergencyTypeProvider.notifier)
                              .state = newValue;
                        }
                      },
                      items: EmergencyType.values.map((EmergencyType type) {
                        return DropdownMenuItem<EmergencyType>(
                          value: type,
                          child: Text(type
                              .toString()
                              .split('.')
                              .last), // Display enum value without enum type
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(kblue)),
                      onPressed: () async {
                        images = await complaintService
                            .pickAndUploadMultipleImages();
                        print(images);
                      },
                      child: Text(
                        'Upload Supporting Images',
                        style: TextStyling().styleh3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ListTile(
                    subtitle: Text(
                      DateTime.now().toLocal().toString(),
                      style: TextStyling().stylep1,
                    ),
                    title: Text(
                      "Time Stamp",
                      style: TextStyling().stylep1,
                    ),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      counterText: '',
                    ),
                    keyboardType: TextInputType.name,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(kpink)),
                    onPressed: () async {
                      print("Getting location");
                      Map<String, double>? location =
                          await locationProvider.getCurrentLocation();
                      print("Getting location");
                      EmergencyType emergency = ref
                          .read(selectedEmergencyTypeProvider.notifier)
                          .state;
                      ComplaintModel model = ComplaintModel(
                          user_id: user,
                          complaint_id: user,
                          lattitude: location['latitude']!,
                          longitude: location['longitude']!,
                          imgs: images!,
                          emergencyType: emergency,
                          description: descriptionController.text.toString(),
                          createdAt: DateTime.now(),
                          active: true);

                      try {
                        await complaintService.registerComplaint(model);
                        debugPrint("Success");
                        Navigator.pop(context);
                      } catch (e) {
                        debugPrint(
                            "Unable to register a complain ${e.toString()}");
                      }
                    },
                    child: Text(
                      'Register Complaint',
                      style: TextStyling().styleh3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
