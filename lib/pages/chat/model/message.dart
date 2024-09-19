import 'package:flutter/foundation.dart' show immutable;

@immutable
class Message {
  final String message;

  final String senderId;
  final String receiverId;
  final DateTime timestamp;

  const Message({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] as String,
      senderId: map['sender_id'] as String,
      receiverId: map['receiver_id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] as int,
      ),
    );
  }
}
