import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/models/user1.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/utils/color.dart';






class FollowReq extends StatefulWidget {
  FollowReq({Key key, this.analytics, this.observer, this.UID, this.Username, this.UserProfileImg}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String UID;
  final String Username;
  final String UserProfileImg;
  @override
  _FollowReqState createState() => _FollowReqState();


}

class _FollowReqState extends State<FollowReq> {
  List<User1> _userRequests = [];
  Future<DocumentSnapshot> _listFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listFuture = getRequests();
  }

  Future<DocumentSnapshot> getRequests() async{
    var snapshot = await followrequestRef
                .doc(widget.UID)
                .collection("requests")
                .get();
    DocumentSnapshot docsnap;
    for(var doc in snapshot.docs)
    {
      docsnap = await usersRef
                .doc(doc.id)
                .get();
      User1 user = User1(
          UID: docsnap.id,
          username: docsnap['Username'],
          email: docsnap['Email'],
          fullName: docsnap['FullName'],
          isPrivate: docsnap['IsPrivate'],
          isDeactivated: docsnap['isDeactivated'],
          bio: docsnap['Bio'],
          ProfilePic: docsnap['ProfilePic']);
      _userRequests.add(user);
    }
    return docsnap;
  }
  _buildRequest(User1 user, int index) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.grey,
              backgroundImage: user.ProfilePic.isEmpty
                  ? AssetImage('assets/Dog/cutegolden.jpg')
                  : NetworkImage(user.ProfilePic),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "@${user.username}",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.darkpurple,
                          fontWeight: FontWeight.bold,
                        )
                    ),
                    Text("${user.email}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                        ))
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () async {//accept request
                          //add follower and following
                          //follow for current user and following for the user that requested
                          await followrequestRef
                          .doc(widget.UID)
                          .collection("requests")
                          .doc(user.UID)
                          .delete();

                          followersRef
                          .doc(widget.UID)
                          .collection("userFollowers")
                          .doc(user.UID)
                          .set({});

                          followingRef
                          .doc(user.UID)
                          .collection("userFollowing")
                          .doc(widget.UID)
                          .set({});

                          setState(() {
                            _userRequests.removeAt(index );
                          });
                          },
                        child: Icon(Icons.check, color: Colors.green,size: 30,)),
                    GestureDetector(
                        onTap: () async {//reject request
                          await followrequestRef
                              .doc(widget.UID)
                              .collection("requests")
                              .doc(user.UID)
                              .delete();
                          setState(() {
                            _userRequests.removeAt(index );
                          });
                        },
                        child: Icon(Icons.cancel_outlined, color: Colors.red,size: 30,),
                    )
                  ],
                ),

              ],
            ),
            onTap: () => {//todo push to the user's profile
             }
        ),
        Divider(height: 2, thickness: 2,)
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        backgroundColor: AppColors.darkpurple,
        toolbarHeight: 60,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  ProfileScreen(analytics: AppBase.analytics,
                      observer: AppBase.observer,),
            ), (route) => false);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.UserProfileImg),
            ),
            SizedBox(width: 10,),
            Text("@${widget.Username}",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),
            )
          ],
        ),
        actions: [
          //TODO: Accept all and reject all button?
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            tileColor: Colors.white,
            leading: Text("Follow Requests: ", style: TextStyle(fontSize: 25),)
          ),
          SizedBox(height: 5,),
          FutureBuilder(
            future: _listFuture,
            builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if(snapshot.connectionState == ConnectionState.done)
              {

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _userRequests.length,
                  itemBuilder: (BuildContext context, int index) {
                    User1 following = _userRequests[index];
                    return _buildRequest(following, index);
                  },
                );
              }
              else {
                return (Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.primarypurple))));

              }
            },
          ),
        ],
      ),
    );
  }
}
