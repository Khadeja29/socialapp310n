import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/routes/profile/PostScreen.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

final usersRef = FirebaseFirestore.instance.collection('user');



class ActivityFeed extends StatefulWidget {
  const ActivityFeed({Key key, this.analytics, this.observer,}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  List<ActivityFeedItem> _feedItems = [];
  String userProf, userName;
  FBauth.User currentUser =  FBauth.FirebaseAuth.instance.currentUser;
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Notifications Page');
    _setLogEvent();
    print("SCS : Notifications Page succeeded");
  }

  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Notifications_page_success',
        parameters: <String, dynamic>{
          'name': 'Notifications Page',
        }
    );
  }
  @override

  Future _listFuture1;
  void initState() {
    super.initState();
    _listFuture1 = getActivityFeed();
    _setCurrentScreen();

  }

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex =
          index; //TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, '/homefeed');
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, '/search');
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacementNamed(context, '/uploadpic');
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/notifications');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, '/profile');
      } //TODO: if index 3 push notif page, if index 4 push profile page
    });
  }

   getPic(String userId ) async {
    var result = await usersRef
        .doc(userId)
        .get();
    return result.get("ProfilePic");

  }
   getUsername(String userId) async {
    var result = await usersRef
        .doc(userId)
        .get();
    if (result.exists) {
      return result.get("Username");
    }
    else{return "InvalidUser";}
  }

  getActivityFeed()  async {
    QuerySnapshot snapshot = await activityFeedRef
        .doc(currentUser.uid)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .get();
    List<ActivityFeedItem> feedItems = [];
      bool UserExists;
      for (var doc in snapshot.docs) {
        userName = await  getUsername(doc['userId']);
      if(userName != "InvalidUser"){
        userProf = await getPic(doc['userId']);
        Map<String, dynamic> map = doc.data();
        ActivityFeedItem feedItem=  ActivityFeedItem(
          userId: doc['userId'],
          type: doc['type'],
          postId: doc['PostID'],
          feedId: doc.id,
          commentData: map.containsKey('commentData') ? doc['commentData']: "",
          timestamp: doc['timestamp'],
          userProfileImg: userProf,
          username: userName,
        );
        feedItems.add(feedItem);
        print(feedItems.length);
      }
      else {
        //delete notif here
        activityFeedRef.doc(currentUser.uid)
            .collection('feedItems').doc(doc.id).delete();
        print("User does not exist.");
      }

    }
    //sleep(const Duration(seconds: 10));
    setState(() {
      _feedItems = feedItems;
    });
    return  feedItems;
  }
  AppBar header(context, {bool isAppTitle = false, String titleText, removeBackButton = false}) {
    return AppBar(
      title: Text(
        isAppTitle ? "FlutterShare" : "$titleText",
        style: TextStyle(
          color: Colors.white,
          fontFamily: isAppTitle ? "Signatra" : "",
          fontSize: isAppTitle ? 22.0 : 22.0,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      backgroundColor: AppColors.darkpurple,
    );
  }

  configureMediaPreview(context, ActivityFeedItem feedItem) {
    //this is to show the post
    if (feedItem.type == "like" || feedItem.type == 'comment') {
      mediaPreview = Container(
        height: 50.0,
        width: 50.0,
        child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(feedItem.mediaUrl),
                ),
              ),
            )),
      );
    } else {
      mediaPreview = Text('');
    }
    if (feedItem.type == 'like') {
      activityItemText = "liked your post";
    } else if (feedItem.type == 'follow') {
      activityItemText = "is following you";
    } else if (feedItem.type == 'comment') {
      activityItemText = 'commented: ${feedItem.commentData}';
    } else {
      activityItemText = "Error: Unknown type '${feedItem.type}'";
    }
  }


   Widget buildFeed(ActivityFeedItem feedItem , int index){

    String pic = feedItem.userProfileImg, usr = feedItem.username;
    configureMediaPreview(context, feedItem);


    return Dismissible(
      background: Container(color: Colors.purple[100],),
      key: Key(feedItem.feedId),
      onDismissed: (DismissDirection direction) async {
        await activityFeedRef.doc(currentUser.uid).collection("feedItems").doc(feedItem.feedId).delete();
        setState(() {
          _feedItems.removeAt(index);
        });
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
          color: Colors.white54,
          child: ListTile(
            tileColor: Colors.white,
            title: GestureDetector(
              onTap: () =>  {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) =>  ProfileScreen(analytics: AppBase.analytics, observer: AppBase.observer, UID: feedItem.userId, index: 1),
                ),)
              },
              child: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: usr.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' $activityItemText',
                      ),
                    ]),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(pic.toString()),
            ),
            subtitle: Text(
              timeago.format(feedItem.timestamp.toDate()),
              overflow: TextOverflow.ellipsis,
            ),
            trailing: mediaPreview,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(image : AssetImage('assets/images/logo_woof.png'),
        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.8), BlendMode.overlay)),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: header(context, titleText: "Activity Feed"),
        body: Container(
            child: FutureBuilder(
              future: _listFuture1,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return  Center(
                    child: SizedBox(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.primarypurple))),
                  );
                }
                return ListView.builder(
                  itemCount: _feedItems.length,
                  // ignore: missing_return
                  itemBuilder: (context, index)  {
                     return  buildFeed(_feedItems[index], index);
                    }
                );
              },
            )),
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          backgroundColor: AppColors.darkpurple,
          selectedItemColor: AppColors.peachpink,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_outlined),
                label: "Notifications"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Profile"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem{
  String username;
  String userId;
  String type; // 'like', 'follow', 'comment'
  String postId;
  String userProfileImg;
  String commentData;
  String mediaUrl;
  Timestamp timestamp;
  String feedId;

  ActivityFeedItem({
    this.username,
    this.feedId,
    this.userId,
    this.type,
    this.postId,
    this.userProfileImg,
    this.mediaUrl,
    this.commentData,
    this.timestamp,
  });
}

