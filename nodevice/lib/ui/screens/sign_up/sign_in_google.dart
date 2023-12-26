import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  // Google 로그인 프로세스 시작
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // 구글 사용자가 선택되지 않은 경우 (예: 취소 버튼 클릭)
  if (googleUser == null) return Future.error('Google Sign-In cancelled');

  // Google 인증 세부 정보 획득
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Google 인증 세부 정보를 사용하여 Firebase 사용자 생성
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Firebase 사용자 인증 및 반환
  return FirebaseAuth.instance.signInWithCredential(credential);
}
