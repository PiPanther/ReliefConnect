import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final currentUserProvider = Provider<User?>((ref) {
  final asyncUser = FirebaseAuth.instance.currentUser;
  return asyncUser;
});

// Provider to track the current user and authentication state
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final googleSignInProvider = Provider((ref) => GoogleSignInService());

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in canceled');
        return null;
      }
      print('Google sign-in successful, fetching auth details');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('Auth details fetched');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('Credential created');

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      print('Firebase sign-in successful');
      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
