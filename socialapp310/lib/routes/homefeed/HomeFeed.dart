import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
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

//to connect to main use Function '/someroutename': (context) => HomeFeed(),
class _TestPostState extends State<HomeFeed> {
  int _selectedIndex = 0;
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Home Page');
    print("SCS : Home Page succeeded");
  }
  void initState() {
    super.initState();
    _setCurrentScreen();
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
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Uploadpic()));
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
              // do something
            },
          )
        ],
      ),
      body: ListView(
        children: posts.map((post) => PostCard(post: post)).toList(),
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