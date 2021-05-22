import 'package:socialapp310/models/user.dart';
import 'package:socialapp310/utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final int userId;
  final String imageUrlAvatar;
  final String username;
  final String message;
  final DateTime createdAt;

  const Message({
    this.userId,
     this.imageUrlAvatar,
    this.username,
     this.message,
    this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
    userId: json['userId'],
    imageUrlAvatar: json['imageUrlAvatar'],
    username: json['username'],
    message: json['message'],
    createdAt: Utils.toDateTime(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'imageUrlAvatar': imageUrlAvatar,
    'username': username,
    'message': message,
    'createdAt': Utils.fromDateTimeToJson(createdAt),
  };
}


