import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/models/user.dart';
import 'package:socialapp310/models/message.dart';


class ChatScreen extends StatefulWidget{
  final User user;
  ChatScreen({this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{



  _chatbubble( Message message , bool isMe, bool isSameUser){
    if (isMe){
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: AppColors.primarypurple,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.peachpink.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ]
              ),
              child:
              Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                ),),
            ),
          ),
          !isSameUser ?
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(message.time,
                  style: TimeStamp),
              SizedBox(width: 10),
              Container(
                decoration:
                BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.peachpink.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(message.sender.imageUrlAvatar),
                ),
              ),


            ],
          )
              :
          Container(child: null,),
        ],
      );
    }
    else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.peachpink.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ]
              ),
              child:
              Text(
                message.text,
              ),
            ),
          ),
          !isSameUser ?
          Row(
            children: <Widget>[
              Container(
                decoration:
                BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.peachpink.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage(message.sender.imageUrlAvatar),
                ),
              ),
              SizedBox(width: 10),
              Text(message.time,
                  style: TimeStamp),
            ],
          )
              :
          Container(child: null,),
        ],
      );
    }
  }

  _sendMessageArea(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
        //  IconButton(
        //      icon: Icon(Icons.photo),
         //     iconSize: 25,
         //     color: AppColors.primarypurple,
          //    onPressed: (){

            //  }),
          Expanded(
            child: TextField(

              decoration: InputDecoration.collapsed(hintText: "Woof..."),
              textCapitalization: TextCapitalization.sentences,

            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: AppColors.primarypurple,
              onPressed: (){

              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int prevUserId;
    return Scaffold(
      backgroundColor: AppColors.lightgrey,
      appBar: AppBar(
        backgroundColor: AppColors.primarypurple,
        title: RichText(
            text: TextSpan(
                children: [
                  TextSpan(text:  widget.user.username,
                      style: kAppBarTitleTextStyle)
                ]
            )
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: (){
              Navigator.pop(context);
            }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: ( BuildContext context, int index){
                final Message message = messages[index];
                final bool isMe = message.sender.userId == profuser.userId;
                final bool isSameUser = prevUserId ==  message.sender.userId;
                prevUserId = message.sender.userId;
                return _chatbubble(message, isMe, isSameUser);
              },
            ),
          ),

          _sendMessageArea(),

        ],
      ),
    );
  }
}