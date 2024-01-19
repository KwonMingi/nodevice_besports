import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  final FlutterSecureStorage storage;
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;

  AuthManager({
    required this.storage,
    required this.googleSignIn,
    required this.firebaseAuth,
  });
  Future<void> saveGoogleLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('googleLoggedIn', isLoggedIn);
  }

  // 앱 시작 시 Google 로그인 상태 확인 및 자동 로그인 처리
  Future<void> checkAndAutoLoginWithGoogle(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    bool isGoogleLoggedIn = prefs.getBool('googleLoggedIn') ?? false;

    if (isGoogleLoggedIn) {
      // Google 로그인 프로세스 진행
      await signInWithGoogle(context);
    }
  }

  Future<void> checkAndSignInWithGoogle(BuildContext context) async {
    bool hasLoggedIn = await getLoginStatus();
    if (hasLoggedIn) {
      await signInWithGoogle(context);
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

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
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
