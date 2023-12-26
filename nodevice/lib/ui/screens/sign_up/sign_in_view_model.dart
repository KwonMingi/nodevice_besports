import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:nodevice/constants/static_status.dart';
import 'package:nodevice/ui/screens/homeScreen/home_screen.dart';
import 'package:nodevice/ui/widgets/loading_dialog.dart';
import 'package:nodevice/utils/show_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInViewModel extends AsyncNotifier<void> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _repassController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();
  bool _autoLoginChecked = false;

  TextEditingController get emailController => _emailController;
  TextEditingController get passController => _passController;
  TextEditingController get repassController => _repassController;
  bool get autoLoginChecked => _autoLoginChecked;
  set setAutoLoginChecked(bool value) => _autoLoginChecked = value;

  @override
  FutureOr<void> build() {}

  Future<void> saveAutoLogin() async {
    final String email = _emailController.text;
    final String password = _passController.text;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoLogin', _autoLoginChecked);

    if (_autoLoginChecked) {
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'password', value: password);
    } else {
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'password');
    }
  }

  void loadAutoLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    _autoLoginChecked = prefs.getBool('autoLogin') ?? false;
    if (_autoLoginChecked) {
      final email = await _secureStorage.read(key: 'email');
      final password = await _secureStorage.read(key: 'password');
      if (email != null && password != null) {
        _emailController.text = email;
        _passController.text = password;
        emailSignIn(context); // Perform auto-login
      }
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showSnackbar(context, 'Password reset email sent.');
      } catch (e) {
        showSnackbar(context, 'Error: Unable to send reset email.');
      }
    } else {
      showSnackbar(context, 'Please enter your email address.');
    }
  }

  Future<void> createAccount(BuildContext context) async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passController.text.trim();
      final String confirmPassword = _repassController.text.trim();

      // Check for empty fields and password match
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        showSnackbar(context, "Please fill in all fields");
        return;
      }
      if (password != confirmPassword) {
        showSnackbar(context, "Passwords do not match");
        return;
      }

      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Check if the user is successfully created
      if (userCredential.user != null) {
        showLoadingDialog(context); // 계정 생성 후 로딩 다이얼로그 표시
        try {
          await userCredential.user!.sendEmailVerification(); // 이메일 인증 보내기
          showSnackbar(context,
              "Account created successfully. Please check your email to verify your account."); // 계정 생성 성공 메시지
        } catch (e) {
          showSnackbar(context,
              "Failed to send email verification. Please try again."); // 이메일 인증 실패 메시지
        } finally {
          Navigator.of(context).pop(); // 항상 로딩 다이얼로그 닫기
        }
      } else {
        showSnackbar(context,
            "Account creation failed. Please try again."); // 계정 생성 실패 메시지
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = "An error occurred";
      switch (error.code) {
        case "weak-password":
          errorMessage = "The password provided is too weak.";
          break;
        case "email-already-in-use":
          errorMessage = "An account already exists for that email.";
          break;
        case "invalid-email":
          errorMessage = "The email address is badly formatted.";
          break;
        default:
          errorMessage = "An unknown error occurred";
      }
      showSnackbar(context, errorMessage);
    } catch (e) {
      showSnackbar(context, "An error occurred: ${e.toString()}");
    }
  }

  Future<void> emailSignIn(BuildContext context) async {
    showLoadingDialog(context);
    try {
      final String email = _emailController.text.trim();
      final String password = _passController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        showSnackbar(context, "Email and password cannot be empty");
        return;
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // GoRouter 인스턴스를 사용하여 홈 화면으로 이동

        User user = userCredential.user!;
        UID.uid = user.uid;
        if (!user.emailVerified) {
          showSnackbar(context, "Please verify your email address");
          return; // 인증되지 않은 경우 함수를 종료
        }
        GoRouter.of(context).go('/home');
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage = "An error occurred";
      switch (error.code) {
        case "invalid-email":
          errorMessage = "The email address is badly formatted.";
          break;
        case "user-disabled":
          errorMessage = "This user has been disabled.";
          break;
        case "user-not-found":
          errorMessage = "User not found.";
          break;
        case "wrong-password":
          errorMessage = "Incorrect password.";
          break;
        default:
          errorMessage = "An unknown error occurred";
      }
      showSnackbar(context, errorMessage);
    } catch (e) {
      showSnackbar(context, "An error occurred: ${e.toString()}");
    } finally {
      Navigator.of(context).pop();
    }
  }
}
