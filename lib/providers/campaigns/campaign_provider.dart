import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/models/campaign.dart';
import 'package:frs/models/donation_taker.dart';
import 'package:frs/providers/Authentication/auth_servicec.dart';
import 'package:image_picker/image_picker.dart';

final fireStoreProvider = Provider((ref) => FirebaseFirestore.instance);

final campaignListProvider = Provider<Stream<List<Campaign>>>((ref) {
  final fireStore = ref.watch(fireStoreProvider);
  final user = ref.watch(currentUserProvider);
  return DonationRepository(fireStore, user).getCampaigns();
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
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
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

      final url = await reference.getDownloadURL();
      print(url);
      return url;
    } catch (e) {
      print("Error uploading thumbnail. ${e.toString()}");
      return null;
    }
  }

  Future<List<String>> pickAndUploadMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images =
        await picker.pickMultiImage(limit: 2, imageQuality: 25);
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

  Stream<List<Campaign>> getCampaigns() {
    try {
      return _firestore
          .collection('campaigns')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Campaign.fromMap(doc.data());
        }).toList();
      });
    } catch (e) {
      print("Error fetching campaigns");
      return Stream.value([]); // Returning an empty list in case of an error
    }
  }
}
