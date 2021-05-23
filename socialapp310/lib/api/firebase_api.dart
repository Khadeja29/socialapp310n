import 'package:socialapp310/models/message.dart';
import 'package:socialapp310/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp310/utils.dart';
import '../data.dart';
import 'package:socialapp310/users.dart';

class FirebaseApi {
  static Stream<List<User>> getUsers() => FirebaseFirestore.instance
      .collection('user')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(User.fromJson));

  static Future uploadMessage(String username, String message) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$username/messages');

    final newMessage = Message(
      imageUrlAvatar: myUrlAvatar,
      username: myUsername,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    await refUsers
        .doc(myUsername)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String username) =>
      FirebaseFirestore.instance
          .collection('chats/$username/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Future addRandomUsers(List<User> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(username: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }
}