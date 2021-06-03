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



class ChatSearch extends StatefulWidget {
  @override
  _ChatSearchState createState() => _ChatSearchState();
}

class _ChatSearchState extends State<ChatSearch> {

  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool check = false;
  String uname;
  // Map<String, dynamic> data = snapshotData.docs[index].data();
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Widget searchedData(){
      return ListView.builder(
          itemCount: snapshotData.docs.length,
          itemBuilder: (BuildContext context, int index){

            Map<String, dynamic> data = snapshotData.docs[index].data();
            //if(data == null) return CircularProgressIndicator();
            uname = data['Username'];
           // print('HELLOOO $data');
            return GestureDetector(
              onTap: (){
                transition: Transition.downToUp;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatPage(docs: snapshotData.docs[index])));
              },
              child: ListTile(
                tileColor: AppColors.peachpink,
                minVerticalPadding: 5,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(data['ProfilePic']),
                ),

                title: Text(uname, style: TextStyle(color: AppColors.darkpurple, fontSize: 15),),
              ),
            );
          }
      );
    }
    return Scaffold(
        backgroundColor: AppColors.lightgrey,
        floatingActionButton:
        FloatingActionButton(child: Icon(Icons.clear),
        onPressed: (){
          setState(() {
            check = false;
          });
        },
          backgroundColor: AppColors.darkpurple,

        ),
        appBar: AppBar(
          backgroundColor: AppColors.darkpurple,
          actions: [
            GetBuilder<DataController>(
                init: DataController(),
                builder: (val){
                  return IconButton(
                      icon: Icon(Icons.search),
                      onPressed: (){
                        val.queryData(searchController.text).then((value){
                          snapshotData = value;
                          setState(() {
                            check = true;
                          });
                        });
                      });
                })
          ],
          title: TextFormField(
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Search The Pack!',


            ),
            controller: searchController,
          ),
        ),
        body: check ? searchedData() : Container(
          child: Center(
            child: Text('Howling!',
              style: TextStyle(color: AppColors.darkpurple,fontSize: 20), ),
          ),
        )


    );
  }


}