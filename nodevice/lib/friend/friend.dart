import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:nodevice/utils/show_snackbar.dart';

class FriendsViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final snackbar = SnackbarManager();
  List<String> friends = []; // 친구 목록

  // 친구 목록 로드
  Future<void> loadFriends(String userId) async {
    try {
      var snapshot = await firestore.collection('friends').doc(userId).get();
      if (snapshot.exists) {
        friends = List<String>.from(snapshot.data()!.keys);
        notifyListeners();
      }
    } catch (e) {
      // 오류 처리
      print(e);
    }
  }

  // 친구 요청 보내기
  Future<void> sendFriendRequest(String myUserId, String friendUserId) async {
    try {
      await firestore
          .collection('friend_requests')
          .doc(myUserId)
          .set({friendUserId: 'pending'}, SetOptions(merge: true));
    } catch (e) {
      // 오류 처리
      snackbar.showSnackbar("$e");
    }
  }

  // 친구 요청 수락
  Future<void> acceptFriendRequest(String myUserId, String friendUserId) async {
    try {
      await firestore
          .collection('friends')
          .doc(myUserId)
          .set({friendUserId: true}, SetOptions(merge: true));
      await firestore
          .collection('friends')
          .doc(friendUserId)
          .set({myUserId: true}, SetOptions(merge: true));

      await firestore
          .collection('friend_requests')
          .doc(myUserId)
          .update({friendUserId: FieldValue.delete()});
      await firestore
          .collection('friend_requests')
          .doc(friendUserId)
          .update({myUserId: FieldValue.delete()});

      loadFriends(myUserId); // 친구 목록 업데이트
    } catch (e) {
      // 오류 처리
      snackbar.showSnackbar("$e");
    }
  }

  // 친구 삭제
  Future<void> removeFriend(String myUserId, String friendUserId) async {
    try {
      await firestore
          .collection('friends')
          .doc(myUserId)
          .update({friendUserId: FieldValue.delete()});
      await firestore
          .collection('friends')
          .doc(friendUserId)
          .update({myUserId: FieldValue.delete()});

      loadFriends(myUserId); // 친구 목록 업데이트
    } catch (e) {
      // 오류 처리
      snackbar.showSnackbar("$e");
    }
  }
}
