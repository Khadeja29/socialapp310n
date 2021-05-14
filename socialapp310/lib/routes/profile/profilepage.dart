import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/models/user.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
import 'package:socialapp310/routes/profile/appBar.dart';
import 'package:socialapp310/routes/profile/my_flutter_app_icons.dart';
import 'package:socialapp310/routes/profile/profilewidget.dart';

import 'package:socialapp310/utils/color.dart';

import 'editprofile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  int _pageIndex = 0;

  String _name = profuser.fullname;
  String _username =profuser.username;
  int _postnum = profuser.userPost.length;
  int _followers = profuser.followers.length;
  int _following = profuser.followings.length;
  TabController _controller;
  String _biodata =profuser.bio;

  int _selectedIndex = 4;
  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;//TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
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


  @override
  void initState() {
    
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      //print(_controller.index);
    });
  }


  @override
  Widget build(BuildContext context) {
    var _screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: InstaAppBar(
        height: 345,
        isProfileScreen: true,
        backgroundColor: AppColors.darkpurple,
        center: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.alternate_email_outlined,
              color: Colors.white,
            ),
            Text(
              _username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.article_outlined,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushNamed(context, "/editprofile")
        ),
        profileStats: profileStats(screen: _screen, color: Colors.white, post: _postnum, followers: _followers, following: _following, context: context),
        bio: bio(name: _name, biodata:_biodata),
        tabbar: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: AppColors.peachpink,
          indicatorColor: AppColors.peachpink,
          tabs: [
            Tab(icon: Icon(Icons.grid_on)),
            Tab(icon: Icon(Icons.location_on_outlined)),
            Tab(icon: Icon(MyFlutterApp.pen_alt)),
          ],
          controller: _controller,
        ),
      ),
      body: TabBarView(
        children: [
          //TAB1: Media DISPLAY
          mediagrid_display(),
          //TAB2: locations DISPLAY
          ListView.builder(
              itemCount: profuser.locations.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildTripCard(context, index)),
          //TAB3: POSTS DISPLAY
          ListView(
            children: posts.map((post) => PostCard(post: post)).toList(),
          ),


        ],
        controller: _controller,
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined), label: "Notifications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,

        onTap: _onItemTapped,
      ),
    );
  }
}

Widget mediagrid_display () {
  return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              itemCount: posts.length,
              itemBuilder: (contex, index) {
                return Container(
                  padding:  EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image(
                      fit: BoxFit.cover,
                      image:
                      AssetImage(posts.elementAt(index).ImageUrlPost),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (index) => StaggeredTile.count(1 , 1 ),
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
          ],
        ),
      );
}
  Widget buildTripCard(BuildContext context, int index) {
    final loc = profuser.locations[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, size: 18, color: AppColors.darkpurple,),
                  SizedBox(width: 5,),
                  Text(loc.loc_name, style: new TextStyle(fontSize: 18.0),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text('Subscribed'),
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.peachpink,
                      onPrimary: Colors.white,
                      shadowColor: Colors.grey,
                      elevation: 5,
                    ),
                    onPressed: () {
                      print('Pressed');
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
