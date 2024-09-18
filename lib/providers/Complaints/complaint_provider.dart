import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/models/complaint_model.dart';
import 'package:image_picker/image_picker.dart';

final complaintServiceProvider =
    Provider<ComplaintService>((ref) => ComplaintService());

class ComplaintService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _user = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;

  Future<List<String>> pickAndUploadMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images =
        await picker.pickMultiImage(imageQuality: 25, limit: 2);
    if (images != null) {
      return await uploadMultipleImages(images);
    }

    return [];
  }

  Future<List<String>> uploadMultipleImages(List<XFile> images) async {
    List<String> imageUrls = [];

    for (XFile image in images) {
      try {
        final reference = storage
            .ref()
            .child('campaign_images')
            .child(_user!.uid)
            .child(image.name);
        await reference.putFile(File(image.path));
        String imageUrl = await reference.getDownloadURL();
        imageUrls.add(imageUrl);
        print(imageUrls);
      } catch (e) {
        print("Upload failed : Images List ${e.toString()}");
      }
    }

    return imageUrls;
  }

  Future<void> registerComplaint(ComplaintModel complain) async {
    try {
      final activeComplaint = _firebaseFirestore
          .collection('complaints')
          .doc('active')
          .collection(complain.user_id)
          .doc(complain.user_id);
      await activeComplaint.set(complain.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resolveComplaint(String complaintId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is signed in.");
    }

    final userId = user.uid;

    try {
      // Reference to the specific complaint in the active subcollection
      final complaintRef = _firebaseFirestore
          .collection('complaints')
          .doc('active')
          .collection(userId)
          .doc(complaintId);

      // Get the complaint document data
      final complaintSnapshot = await complaintRef.get();
      if (!complaintSnapshot.exists) {
        throw Exception("Complaint does not exist.");
      }

      ComplaintModel model = ComplaintModel.fromMap(complaintSnapshot.data()!);

      if (!complaintSnapshot.exists) {
        throw Exception("Complaint does not exist.");
      }

      final resolvedComplaint = ComplaintModel(
        user_id: model.user_id,
        complaint_id: model.complaint_id,
        lattitude: model.lattitude,
        longitude: model.longitude,
        imgs: model.imgs,
        emergencyType: model.emergencyType,
        description: model.description,
        createdAt: model.createdAt,
        active: false,
      );

      // Move the complaint to the resolved subcollection
      final resolvedComplaintsRef = _firebaseFirestore
          .collection('complaints')
          .doc('resolved')
          .collection(userId)
          .doc(userId);

      await resolvedComplaintsRef.set({
        ...resolvedComplaint.toMap(),
        'resolvedAt': FieldValue.serverTimestamp(),
        'status': 'resolved',
      });

      // Remove the complaint from the active subcollection
      await complaintRef.delete();
      print('Success');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Stream of active complaints as a list of ComplaintModel
  Stream<List<ComplaintModel>> getActiveComplaints() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is signed in.");
    }

    try {
      final userId = user.uid;

      // Reference to the user's active complaints subcollection
      final activeComplaintsRef = _firebaseFirestore
          .collection('complaints')
          .doc('active')
          .collection(userId);

      // Return a stream of active complaints as List<ComplaintModel>
      return activeComplaintsRef.snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => ComplaintModel.fromMap(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Stream of resolved complaints as a list of ComplaintModel
  Stream<List<ComplaintModel>> getResolvedComplaints() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is signed in.");
    }

    try {
      final userId = user.uid;

      // Reference to the user's resolved complaints subcollection
      final resolvedComplaintsRef = _firebaseFirestore
          .collection('complaints')
          .doc('resolved')
          .collection(userId);

      return resolvedComplaintsRef.snapshots().map((querySnapshot) {
        // Debug log to check if documents are being retrieved
        print('Fetched ${querySnapshot.docs.length} resolved complaints.');

        return querySnapshot.docs
            .map((doc) => ComplaintModel.fromMap(doc.data()))
            .toList();
      });
    } catch (e) {
      // Log exception details
      print('Error fetching resolved complaints: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> deleteComplaint(String complaintId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is signed in.");
    }

    final userId = user.uid;

    try {
      // Reference to the specific complaint in the active subcollection
      final complaintRef = _firebaseFirestore
          .collection('complaints')
          .doc('active')
          .collection(userId)
          .doc(complaintId);

      // Check if the complaint exists
      final complaintSnapshot = await complaintRef.get();
      if (!complaintSnapshot.exists) {
        throw Exception("Complaint does not exist.");
      }

      // Delete the complaint from the active subcollection
      await complaintRef.delete();
      print('Complaint deleted successfully.');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
