import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';

class ChatPage extends StatefulWidget {
  final docs;

  const ChatPage({Key key, this.docs}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String groupChatId;
  String userID;

  TextEditingController textEditingController = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getGroupChatId();
    super.initState();
  }

  getGroupChatId() async {
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;
    userID = currentFB.uid;

    // userID = sharedPreferences.getString('Username');

    String anotherUserId = widget.docs.id;

    if (userID.compareTo(anotherUserId) > 0) {
      groupChatId = '$userID - $anotherUserId';
    } else {
      groupChatId = '$anotherUserId - $userID';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkpurple,
        title: Row(

          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.docs['ProfilePic']),
            ),
            SizedBox(width: 50,),
            RichText(
                text: TextSpan(
                    children: [
                      TextSpan(text:  widget.docs['Username'],
                        style: kAppBarTitleTextStyle, )
                    ]
                )
            ),
          ],
        ),

      ),
      body: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/images/wolf-512.ico"),
            fit: BoxFit.contain,
            ),),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .doc(groupChatId)
              .collection(groupChatId)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Column(
                children: <Widget>[
                  Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemBuilder: (listContext, index) =>
                            buildItem(snapshot.data.docs[index]),
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                      )),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: textEditingController,

                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {sendMsg(); textEditingController.clear();}
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Center(
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ));
            }
          },
        ),
      ),
    );
  }

  sendMsg() {
    String msg = textEditingController.text.trim();

    /// Upload images to firebase and returns a URL
    //if (msg?.isEmpty ?? false) {
    //print('thisiscalled $msg');
    //print('username = $userID');
    var ref = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.set(ref, {
        "senderId": userID,
        "anotherUserId": widget.docs.id,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
        "senttime": DateTime.now(),
        'content': msg,
        "type": 'text',
      });
    });

    scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
  } //else {
  // print('Please enter some text to send');
  //}


  buildItem(doc) {
    return Padding(
      padding: EdgeInsets.only(
          top: 8.0,
          left: ((doc['senderId'] == userID) ? 64 : 0),
          right: ((doc['senderId'] == userID) ? 0 : 64)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: ((doc['senderId'] == userID)
                ? Colors.grey
                : AppColors.primarypurple),
            borderRadius: BorderRadius.circular(8.0)),
        child: (doc['type'] == 'text')
            ? Text('${doc['content']}')
            : Image.network(doc['content']),
      ),
    );
  }
}