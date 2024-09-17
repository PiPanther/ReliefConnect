import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

final currentUserProvider = Provider<User?>((ref) {
  final asyncUser = FirebaseAuth.instance.currentUser;
  return asyncUser;
});

// Provider to track the current user and authentication state
final authStateProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.userChanges();
});

final googleSignInProvider = Provider((ref) => GoogleSignInService());

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _logger = Logger();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.i('Google sign-in canceled');
        return null;
      }
      _logger.i('Google sign-in successful, fetching auth details');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      _logger.i('Auth details fetched');

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      _logger.i('Credential created');

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _logger.i('Firebase sign-in successful');
      return userCredential.user;
    } catch (e) {
      _logger.e('Error signing in with Google', error: e);
      rethrow; // Rethrow the exception for the caller to handle
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print("sign out successful");
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
