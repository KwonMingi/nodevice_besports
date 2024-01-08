import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:go_router/go_router.dart';
//import 'package:nodevice/constants/static_status.dart';

// import 'package:nodevice/ui/widgets/loading_dialog.dart';
import 'package:nodevice/utils/show_snackbar.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends AsyncNotifier<void> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  // final _secureStorage = const FlutterSecureStorage();
  bool _autoLoginChecked = false;

  final SnackbarManager snackbarManager = SnackbarManager();

  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get firstNameController => _firstNameController;
  bool get autoLoginChecked => _autoLoginChecked;
  set setAutoLoginChecked(bool value) => _autoLoginChecked = value;

  // final SecureStorageManager _storageManager = SecureStorageManager();
  final snackbar = SnackbarManager();

  @override
  FutureOr<void> build() {}

  // Future<void> saveAutoLogin() async {
  //   final String lastName = _lastNameController.text;
  //   final String firstName = _firstNameController.text;
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('autoLogin', _autoLoginChecked);

  //   if (_autoLoginChecked) {
  //     await _secureStorage.write(key: 'lastName', value: lastName);
  //     await _secureStorage.write(key: 'firstName', value: firstName);
  //   } else {
  //     await _secureStorage.delete(key: 'lastName');
  //     await _secureStorage.delete(key: 'firstName');
  //   }
  // }

  Future<void> createAccount(BuildContext context) async {
    try {
      final String lastName = _lastNameController.text.trim();
      final String firstName = _firstNameController.text.trim();

      // Check for empty fields and password match
      if (lastName.isEmpty || firstName.isEmpty) {
        snackbar.showSnackbar("Please fill in all fields");
        return;
      }

      // Create user with email and password
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: lastName, password: firstName);

      // Check if the user is successfully created
      // if (userCredential.user != null) {
      //   showLoadingDialog(context); // 계정 생성 후 로딩 다이얼로그 표시
      //   try {
      //     await userCredential.user!.sendEmailVerification(); // 이메일 인증 보내기
      //     snackbar.showSnackbar(
      //         "Account created successfully. Please check your email to verify your account."); // 계정 생성 성공 메시지
      //   } catch (e) {
      //     snackbar.showSnackbar(
      //         "Failed to send email verification. Please try again."); // 이메일 인증 실패 메시지
      //   } finally {
      //     Navigator.of(context).pop(); // 항상 로딩 다이얼로그 닫기
      //   }
      // } else {
      //   snackbar.showSnackbar(
      //       "Account creation failed. Please try again."); // 계정 생성 실패 메시지
      // }
    // } on FirebaseAuthException catch (error) {
    //   String errorMessage = "An error occurred";
    //   switch (error.code) {
    //     case "weak-password":
    //       errorMessage = "The password provided is too weak.";
    //       break;
    //     case "email-already-in-use":
    //       errorMessage = "An account already exists for that email.";
    //       break;
    //     case "invalid-email":
    //       errorMessage = "The email address is badly formatted.";
    //       break;
    //     default:
    //       errorMessage = "An unknown error occurred";
    //   }
    //   snackbar.showSnackbar(errorMessage);
    } catch (e) {
      snackbar.showSnackbar("An error occurred: ${e.toString()}");
    }
  }
}
