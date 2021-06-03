import 'package:socialapp310/models/user.dart';
import 'package:socialapp310/models/user.dart';


class Message {
  final User sender;
  final String time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}


