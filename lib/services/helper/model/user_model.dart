import 'package:cloud_firestore/cloud_firestore.dart'; // Import this for Firestore's Timestamp

class UserDetails {
  CreatedAt createdAt;
  String mobileNumber;
  String email;
  String username;
  String userId;
  String deviceToken;

  UserDetails(
      {required this.createdAt,
      required this.mobileNumber,
      required this.email,
      required this.username,
      required this.userId,
      required this.deviceToken});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    // Check if the createdAt field is a Firestore Timestamp
    var createdAtTimestamp = json['createdAt'] as Timestamp;

    return UserDetails(
        createdAt: CreatedAt(
          seconds: createdAtTimestamp.seconds,
          nanoseconds: createdAtTimestamp.nanoseconds,
        ),
        mobileNumber: json["mobileNumber"],
        email: json["email"],
        username: json["username"],
        deviceToken: json["deviceToken"],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toJson(),
        "mobileNumber": mobileNumber,
        "deviceToken": deviceToken,
        "email": email,
        "username": username,
        "userId": userId
      };
}

class CreatedAt {
  int seconds;
  int nanoseconds;

  CreatedAt({
    required this.seconds,
    required this.nanoseconds,
  });

  factory CreatedAt.fromJson(Map<String, dynamic> json) => CreatedAt(
        seconds: json["seconds"],
        nanoseconds: json["nanoseconds"],
      );

  Map<String, dynamic> toJson() => {
        "seconds": seconds,
        "nanoseconds": nanoseconds,
      };
}
