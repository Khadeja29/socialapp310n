import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/routes/chatspage.dart';
import 'package:socialapp310/models/Post1.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/routes/welcome.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/routes/notifications/notifications.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';
import 'package:socialapp310/routes/uploadpic/uploadpic.dart';



class HomeFeed extends StatefulWidget {
  const HomeFeed({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _TestPostState createState() => _TestPostState();
}

class _TestPostState extends State<HomeFeed> {
  int _selectedIndex = 0;
  User currentUser = FirebaseAuth.instance.currentUser;
  List<Post1> _PostsToBuild = [];
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Home Page');
    _setLogEvent();
    print("SCS : Home Page succeeded");
  }
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Home_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Home Page',
        }
    );
  }
  void initState() {
    super.initState();
    _setCurrentScreen();
    buildHomefeed();

  }

  buildHomefeed () async {
    var result = await followingRef
        .doc(currentUser.uid)
        .collection("userFollowing")
        .get();
    print(currentUser.uid);
    List<Post1> PosttoBuild = [];
    for (var doc in result.docs)
    {

      var SinglePost = await getpostRef
          .where("PostUser" , isEqualTo: doc.id)
          .orderBy("createdAt", descending: true)
          .limit(1)
          .get();
      if(SinglePost.docs.isNotEmpty)
      {
        Post1 post = Post1(
            caption: SinglePost.docs[0]["Caption"],
            imageURL: SinglePost.docs[0]["Image"],
            likes: SinglePost.docs[0]["Likes"],
            createdAt: SinglePost.docs[0]["createdAt"],
            isPrivate: SinglePost.docs[0]["IsPrivate"],
            location: SinglePost.docs[0]["Location"],
            LikesMap : SinglePost.docs[0]['LikesMap'],
            UserID: SinglePost.docs[0]['PostUser'],
            PostID: SinglePost.docs[0].id,
            locationName: SinglePost.docs[0].data()['Locationname'] !=null ? SinglePost.docs[0]['Locationname']: "temp",
        );
        PosttoBuild.add(post);

      }
      PosttoBuild.sort((a,b)=> b.createdAt.compareTo(a.createdAt));



    }
    setState(() {
      _PostsToBuild = PosttoBuild;
    });
  }
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
        Navigator.pushReplacementNamed(context,'/uploadpic');
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/notifications');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, '/profile');
      } //TODO: if index 3 push notif page, if index 4 push profile page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightgrey,
      appBar: AppBar(
        backgroundColor: AppColors.darkpurple,
        centerTitle: true,
        title: Text(
          "Home",
          style: kAppBarTitleTextStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.chat_bubble_outline,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatsPage()));
              // do something
            },
          )
        ],
      ),
      body: ListView(
        children: _PostsToBuild.map((post) => PostCard(post: post)).toList(),
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}