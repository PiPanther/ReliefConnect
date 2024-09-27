import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frs/constants/toasts.dart';
import 'package:frs/models/post_model.dart';
import 'package:image_picker/image_picker.dart';

final postProvider = ChangeNotifierProvider((ref) => PostsProvider());

class PostsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _user = FirebaseAuth.instance.currentUser;

  Future<String?> pickAndUploadThumbnail(ImageSource imgsource) async {
    final XFile? image =
        await _picker.pickImage(source: imgsource, imageQuality: 25);
    if (image != null) {
      String? thumbnailUrl = await uploadThumbnail(image);
      return thumbnailUrl;
    }
    return null;
  }

  Future<String?> uploadThumbnail(XFile file) async {
    try {
      final reference =
          _storage.ref().child('user_posts').child(_user!.uid).child(file.name);
      await reference.putFile(File(file.path));

      final url = await reference.getDownloadURL();
      print(url);
      return url;
    } catch (e) {
      print("Error uploading thumbnail. ${e.toString()}");
      return null;
    }
  }

  // add new post
  Future<void> addPost(PostModel post) async {
    try {
      await _firestore.collection('posts').add(post.toMap());
      print("post added");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<List<PostModel>> fetchPosts() {
    return _firestore.collection('posts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
    });
  }

  Stream<List<PostModel>> fetchUserPost(String userId) {
    try {
      return _firestore
          .collection('posts')
          .where('id', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data()))
            .toList();
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deletePost(String pid) async {
    try {
      // Query the Firestore collection 'posts' where pid matches the post id
      var querySnapshot = await _firestore
          .collection('posts')
          .where('pid', isEqualTo: pid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Loop through the documents and delete them (though ideally, there should be only one)
        for (var doc in querySnapshot.docs) {
          await _firestore.collection('posts').doc(doc.id).delete();
        }

        // Show success toast message
        Toasts().success("Post Deleted Successfully!");
        print('Post deleted successfully');
      } else {
        // If no post is found
        Toasts().success("Error, Post not found!");
        print('No post found with pid: $pid');
      }
    } catch (e) {
      // Handle any errors
      Toasts().error("Error, Please try again!");
      print('Error deleting post: $e');
    }
  }
}
