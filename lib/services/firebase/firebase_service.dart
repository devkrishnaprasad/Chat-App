import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/pages/login/login_page.dart';
import 'package:chat_app/services/helper/controller/helper_controller.dart';
import 'package:chat_app/services/helper/model/user_model.dart';
import 'package:chat_app/services/local_storage/local_storage.dart';
import 'package:chat_app/utils/nav_bar.dart';
import 'package:chat_app/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  HelperController helperController = Get.find();
  LocalStorage localStorage = LocalStorage();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Save FCM token in Firestore after user signs up or logs in
  Future<void> saveDeviceToken(String userId) async {
    String? token = await firebaseMessaging.getToken();
    if (token != null) {
      await users.doc(userId).update({'deviceToken': token});
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password,
      String username, String country, String mobileNumber) async {
    try {
      helperController.isAutLoading.value = true;
      await _auth.setLanguageCode('en');
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        await users.doc(user.uid).set({
          'userId': user.uid,
          'email': email,
          'username': username,
          'mobileNumber': mobileNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });
        log("User Added");

        // Save FCM token
        await saveDeviceToken(user.uid);
      }

      Get.to(const LoginPage());
      return user;
    } catch (e) {
      showToast(message: 'Error: ${e.toString()}');
    } finally {
      helperController.isAutLoading.value = false;
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      helperController.isAutLoading.value = true;
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await users.doc(user.uid).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          UserDetails userDetails = UserDetails.fromJson(userData);
          helperController.userDetails.add(userDetails);

          await localStorage.write(
              'username', helperController.userDetails[0].username);
          await localStorage.write('userId', user.uid);
          helperController.userId.value = user.uid;
          await saveDeviceToken(user.uid);

          helperController.getAllUsersList();
          Get.to(const NavigationWidget());
        }
      }
      return user;
    } catch (e) {
      showToast(message: 'Error: ${e.toString()}');
    } finally {
      helperController.isAutLoading.value = false;
    }
    return null;
  }

  Future<void> sendMessage(
      String chatRoomId, message, String receiverId) async {
    try {
      await FirebaseFirestore.instance
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());

      DocumentSnapshot userDoc = await users.doc(receiverId).get();
      String? deviceToken = userDoc['deviceToken'];

      if (deviceToken != null) {
        await sendPushNotification(deviceToken, message.message);
      }
    } catch (e) {
      log('Error sending message or notification: $e');
    }
  }

  // Function to send push notification via FCM HTTP API
  Future<void> sendPushNotification(String token, String messageText) async {
    final String serviceAccountJsonString =
        await rootBundle.loadString('assets/service_account.json');

    final Map<String, dynamic> serviceAccountJson =
        json.decode(serviceAccountJsonString);
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    final Map<String, dynamic> notificationPayload = {
      "message": {
        "token": token,
        "notification": {
          "body": messageText,
          "title": "New message from ${await localStorage.read('username')}"
        }
      }
    };
    inspect(credentials);

    try {
      var response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/chat-app-test-a303f/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${credentials.accessToken.data}',
        },
        body: jsonEncode(notificationPayload),
      );

      log('The response ${response.body}');
    } catch (e) {
      log('Error sending push notification: $e');
    }
  }

  Stream<QuerySnapshot> receiveMessage(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> signOutUser() async {
    try {
      await _auth.signOut();

      await localStorage.clearAllData();

      helperController.userDetails.clear();

      showToast(message: 'Signed out successfully.');

      Get.offAll(() => const LoginPage());
    } catch (e) {
      log("Error signing out: $e");
      showToast(message: 'An error occurred while signing out.');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsersCurrent() async {
    try {
      // Get the current user's UID
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently signed in.');
      }
      String currentUserId = currentUser.uid;

      // Query Firestore to get all users except the current one
      QuerySnapshot querySnapshot =
          await users.where('userId', isNotEqualTo: currentUserId).get();

      List<Map<String, dynamic>> userDetails = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return userDetails;
    } catch (e) {
      log('Error getting users: $e');
      showToast(message: 'An error occurred while fetching users.');
      return [];
    }
  }
}
