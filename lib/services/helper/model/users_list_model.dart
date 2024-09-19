import 'package:cloud_firestore/cloud_firestore.dart';

class UserList {
  final String email;
  final String mobileNumber;
  final String username;
  final String userId;
  final String deviceToken;
  final Timestamp createdAt;

  UserList({
    required this.email,
    required this.mobileNumber,
    required this.username,
    required this.userId,
    required this.deviceToken,
    required this.createdAt,
  });

  // Convert from Map to UserList
  factory UserList.fromMap(Map<String, dynamic> map) {
    return UserList(
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      username: map['username'],
      userId: map['userId'],
      deviceToken: map['deviceToken'],
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  // Convert UserList to Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'mobileNumber': mobileNumber,
      'username': username,
      'deviceToken': deviceToken,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}
