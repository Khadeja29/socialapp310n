import 'package:flutter/material.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/routes/notifications/notifications.dart';
import 'package:socialapp310/routes/inbox.dart';


class HomeFeed extends StatefulWidget {
  @override
  _TestPostState createState() => _TestPostState();
}

//to connect to main use Function '/someroutename': (context) => HomeFeed(),
class _TestPostState extends State {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex =
          index; //TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, '/homefeed');
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, '/search');
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
                  MaterialPageRoute(builder: (context) => Inbox()));
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