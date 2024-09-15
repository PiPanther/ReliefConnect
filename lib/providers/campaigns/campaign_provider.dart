import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/models/campaign.dart';
import 'package:frs/models/donation_taker.dart';
import 'package:image_picker/image_picker.dart';

final fireStoreProvider = Provider((ref) => FirebaseFirestore.instance);

final campaignListProvider = FutureProvider<List<Campaign>>((ref) async {
  final firestore = ref.read(fireStoreProvider);
  final currentUser = FirebaseAuth.instance.currentUser;
  final campaigns = DonationRepository(firestore, currentUser);
  return campaigns.getCampaigns();
});

final donationRepositoryProvider = Provider((ref) {
  final firestore = ref.read(fireStoreProvider);
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    return DonationRepository(firestore, currentUser);
  } else {
    throw Exception('User not logged in');
  }
});

class DonationRepository {
  final FirebaseFirestore _firestore;
  final _user = FirebaseAuth.instance.currentUser;
  final storage = FirebaseStorage.instance;

  DonationRepository(this._firestore, _user);

  Future<String?> pickAndUploadThumbnail() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? thumbnailUrl = await uploadThumbnail(image);
      return thumbnailUrl;
    }
    return null;
  }

  Future<String?> uploadThumbnail(XFile file) async {
    try {
      final reference = storage
          .ref()
          .child('campaigns_thumbnails')
          .child(_user!.uid)
          .child(file.name);
      await reference.putFile(File(file.path));
      return await reference.getDownloadURL();
    } catch (e) {
      print("Error uploading thumbnail. ${e.toString()}");
      return null;
    }
  }

  Future<List<String>> pickAndUploadMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
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
      } catch (e) {
        print("Upload failed : Images List ${e.toString()}");
      }
    }

    return imageUrls;
  }

  Future<void> addCampaign(DonationTaker donationTaker) async {
    try {
      await _firestore
          .collection('campaigns')
          .doc(_user!.uid)
          .set(donationTaker.toMap());
      print('Donation added successfully!');
    } catch (e) {
      print('Error adding campaign!');
    }
  }

  Future<void> updateCampaign(DonationTaker donationTaker) async {
    try {
      await _firestore
          .collection('donations')
          .doc(_user!.uid)
          .update(donationTaker.toMap());
      print('Donation updated successfully');
    } catch (e) {
      print('Error updating donation: $e');
    }
  }

  Future<void> deleteCampaign() async {
    try {
      await _firestore.collection('donations').doc(_user!.uid).delete();
      print('Donation deleted successfully');
    } catch (e) {
      print('Error deleting donation: $e');
    }
  }

  Future<bool> doesUserDocumentExist() async {
    try {
      final docSnapshot =
          await _firestore.collection('campaigns').doc(_user!.uid).get();
      print("Document already exists");
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }

  Future<List<Campaign>> getCampaigns() async {
    try {
      final querySnapshot = await _firestore.collection('campaigns').get();
      List<Campaign> campaigns = querySnapshot.docs.map((doc) {
        return Campaign.fromMap(doc.data());
      }).toList();
      return campaigns;
    } catch (e) {
      print("Error fetching campaigns");
      return [];
    }
  }
}
