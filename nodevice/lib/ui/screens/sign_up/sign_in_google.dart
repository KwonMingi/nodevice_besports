import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthManager {
  final FlutterSecureStorage storage;
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  AuthManager({
    required this.storage,
    required this.googleSignIn,
    required this.firebaseAuth,
  });

  Future<void> checkAndSignInWithGoogle() async {
    bool hasLoggedIn = await getLoginStatus();
    if (hasLoggedIn) {
      await signInWithGoogle();
    }
  }

  Future<bool> getLoginStatus() async {
    String? loggedIn = await storage.read(key: 'googleLoggedIn');
    return loggedIn == 'true';
  }

  Future<void> setLoginStatus(bool status) async {
    await storage.write(
        key: 'googleLoggedIn', value: status ? 'true' : 'false');
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return Future.error('Google Sign-In cancelled');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    await setLoginStatus(true);
    return userCredential;
  }
}
