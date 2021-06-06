import 'package:animator/animator.dart';
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
    print(widget.UID);
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
      print(doc.id);
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
        GestureDetector(
          child: Card(
            color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
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
          ),
          onTap: () => {},
        ),
        Divider(height: 2, thickness: 2,)
      ],
    );
  }

  _buildRequestNew(User1 user, int index) {
    final animatorKey = AnimatorKey<double>();

    return Animator<double>(
      tween: Tween<double>(begin: 65, end: 0),
      cycles: 1,
      animatorKey: animatorKey,
      triggerOnInit: false,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInBack,
      builder: (context, animatorState, child ) => Container(

        height: animatorState.value,
        child: Column(
          children: [
            Expanded(
              flex: 66,
              child: GestureDetector(
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  color:  Colors.white,

                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: AppColors.darkpurple ,
                      width: 1,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 5,),
                               CircleAvatar(
                                backgroundImage: NetworkImage(user.ProfilePic),
                                radius: 25,
                              ) ,
                              SizedBox(width: 8,),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Expanded(
                                      flex:1,
                                      child: Text(
                                          "@${user.username}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.darkpurple,
                                            fontWeight: FontWeight.bold,
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 3,),
                                    Expanded(
                                      child: Text("${user.email}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.normal,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                                alignment : Alignment.centerRight,
                                padding: const EdgeInsets.all(0.0),
                                icon: ImageIcon(AssetImage("assets/images/times-solid.png"),color: Colors.red,),
                                splashColor: AppColors.peachpink ,
                                splashRadius: 0.1,
                                onPressed: () async
                                {

                                  animatorKey.triggerAnimation();

                                  await followrequestRef
                                      .doc(widget.UID)
                                      .collection("requests")
                                      .doc(user.UID)
                                      .delete();


                                },
                            ),

                            IconButton(
                              padding: const EdgeInsets.all(0.0),
                              alignment : Alignment.center,
                              icon: ImageIcon(AssetImage("assets/images/check-solid(1).png"),color: Colors.green,),
                              splashColor: AppColors.peachpink ,
                              splashRadius: 0.1,
                              onPressed: () async {
                                animatorKey.triggerAnimation();

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


                                },
                            ),


                          ],
                        )

                      ],
                    ),
                  ),
                ),
                onTap: () => {},
              ),
            ),
            Expanded(flex:5,  child: Divider(height: 5, thickness: 5, color: Colors.transparent,))
          ],
        ),
      ),
    );
  }
  @override

    Widget build(BuildContext context) {
      return Container(
          decoration: BoxDecoration(
                gradient: LinearGradient(
                  // 10% of the width, so there are ten blinds.
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.white,
                    Colors.white,

                  ], // red to yellow
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
            title: Center(child: Text("Follow Requests", style: TextStyle(fontSize: 25),)),
            actions: [
              //TODO: Accept all and reject all button?
            ],
          ),
          body:
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Card(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.white,
                  shadowColor: AppColors.peachpink,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: AppColors.darkpurple  ,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(widget.UserProfileImg),
                        ),
                        SizedBox(width: 10,),
                        Text("@${widget.Username}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                FutureBuilder(
                  future: _listFuture,
                  builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if(snapshot.connectionState == ConnectionState.done)
                    {
                      print("here");
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.vertical,
                        itemCount: _userRequests.length,
                        itemBuilder: (BuildContext context, int index) {
                          User1 following = _userRequests[index];
                          return _buildRequestNew(following, index);
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
          ),

        ),
      );
  }
}
