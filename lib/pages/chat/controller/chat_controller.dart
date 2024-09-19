import 'dart:developer';
import 'package:chat_app/pages/chat/model/message.dart';
import 'package:chat_app/services/firebase/firebase_service.dart';
import 'package:chat_app/services/local_storage/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxString reciverId = ''.obs;
  RxString senderUsername = ''.obs;
  RxString revicerDeviceToken = ''.obs;
  LocalStorage localStorage = LocalStorage();
  Future<void> sendMessage(String message) async {
    final DateTime timestamp = DateTime.now();
    Message newMessage = Message(
      message: message,
      senderId: await localStorage.read('userId'),
      receiverId: reciverId.value,
      timestamp: timestamp,
    );

    List<String> ids = [await localStorage.read('userId'), reciverId.value];
    ids.sort();
    String chatRoomId = ids.join('_');
    FirebaseAuthService firebaseAuthService = FirebaseAuthService();
    await firebaseAuthService.sendMessage(
        chatRoomId, newMessage, reciverId.value);
  }

  Stream<QuerySnapshot> getMessage(String userId) {
    log("User Id $userId");
    List<String> ids = [userId, reciverId.value];
    ids.sort();
    String chatRoomId = ids.join('_');

    FirebaseAuthService firebaseAuthService = FirebaseAuthService();
    return firebaseAuthService.receiveMessage(chatRoomId);
  }
}
