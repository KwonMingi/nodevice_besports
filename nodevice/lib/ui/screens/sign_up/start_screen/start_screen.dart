import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nodevice/constants/r_sizes.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_google.dart';
import 'package:nodevice/ui/screens/sign_up/sign_in_view_model.dart';
import 'package:nodevice/ui/widgets/log_in_widgets/log_in_custom_button.dart';
import 'package:nodevice/utils/show_snackbar.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.controller});
  final PageController controller;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final snackbar = SnackbarManager();
  late RSizes s;
  SignInViewModel model = SignInViewModel();
  final authManager = GoogleAuthManager(
    storage: const FlutterSecureStorage(),
    googleSignIn: GoogleSignIn(),
    firebaseAuth: FirebaseAuth.instance,
  );
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (mounted) {
        signInAutoByGoogle();
        model.loadAutoLogin(context);
      }
    });
  }

  void signInAutoByGoogle() async {
    String? loggedIn = await authManager.storage.read(key: 'googleLoggedIn');
    if (loggedIn == 'true') {
      authManager.signInWithGoogle();
    }
  }

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/start_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: s.rSize("height", 700)),
              CustomButton(
                text: '비스포츠 시작하기',
                onPressed: () {
                  signInAutoByGoogle();
                  widget.controller.animateToPage(1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                width: 312,
                height: 48,
                isActivate: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
