import 'package:flutter/cupertino.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/models/message.dart';
import 'package:socialapp310/routes/chat_screen.dart';

class Inbox extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightgrey,
      appBar: AppBar(
        elevation: 8,

        backgroundColor: AppColors.darkpurple,
        centerTitle: true,
        title: Text(
          "Inbox",
          style: kAppBarTitleTextStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: (){},
          )
        ],
      ),
      body: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index){
            final Message  chat = chats[index];
            return GestureDetector(
              onTap: () => Navigator.push(context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    user : chat.sender,
                  ),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: chat.unread ? BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                            width: 2,
                            color: AppColors.primarypurple,
                          ),
                          //shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.peachpink.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ]
                      ) :
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
                        radius: 35,
                        backgroundImage: AssetImage(chat.sender.imageUrlAvatar),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: EdgeInsets.only(left:20, ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(chat.sender.username,
                                  style: InboxName
                              ),
                              Text(chat.time,
                                  style: TimeStamp)
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(chat.text,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow:TextOverflow.ellipsis,
                              maxLines: 2,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}