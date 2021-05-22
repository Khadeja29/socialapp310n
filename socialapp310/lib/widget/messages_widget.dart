import 'package:socialapp310/api/firebase_api.dart';
import 'package:socialapp310/models/message.dart';
import 'package:socialapp310/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/data.dart';



class MessagesWidget extends StatelessWidget {
  final String username;

  const MessagesWidget({
    @required this.username,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
    stream: FirebaseApi.getMessages(username),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
        default:
          if (snapshot.hasError) {
            return buildText('Something Went Wrong Try later');
          } else {
            final messages = snapshot.data;

            return messages.isEmpty
                ? buildText('Say Hi..')
                : ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return MessageWidget(
                  message: message,
                  isMe: message.username == myUsername,
                );
              },
            );
          }
      }
    },
  );

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24),
    ),
  );
}