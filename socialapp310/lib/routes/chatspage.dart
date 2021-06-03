import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/models/user.dart';
import 'package:socialapp310/routes/chatpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp310/services/DataController.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:get/get.dart';
import 'package:socialapp310/services/DataController.dart';
import 'package:socialapp310/routes/chatsearch.dart';

String Username =  FBauth.FirebaseAuth.instance.currentUser.uid;


class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {



  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build



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
            onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatSearch()));
            },
          )
        ],
      ),

        body:
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('user').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.builder(
                    itemBuilder: (listContext, index) =>
                        buildItem(snapshot.data.docs[index]),
                    itemCount: snapshot.data.docs.length,
                  );
                }

                return Container();
              },
            ),


    );
  }

  buildItem(doc) {
    //print('MINE :$Username');
   // print(doc.id);
    return (Username != doc['Username'])
        ? GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatPage(docs: doc)));
      },
      child: Visibility(
        visible:Username != doc.id,
        child: Card(
          color: AppColors.peachpink,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                     padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              width: 2,
                              color: AppColors.primarypurple,
                            ),
                            //shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ]
                        ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(doc['ProfilePic']),
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
                                Text(doc['Username'],
                                    style: InboxName
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),

                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        : Container();
  }
}