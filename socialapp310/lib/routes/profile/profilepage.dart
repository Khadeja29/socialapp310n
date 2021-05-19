import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/models/user.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
import 'package:socialapp310/routes/profile/appBar.dart';
import 'package:socialapp310/routes/profile/my_flutter_app_icons.dart';
import 'package:socialapp310/routes/profile/profilewidget.dart';
import 'package:socialapp310/routes/welcome.dart';

import 'package:socialapp310/utils/color.dart';

import 'editprofile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
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
  String _biodata = profuser.bio;
  String _email = profuser.email;



  int _selectedIndex = 4;
  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;//TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
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
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Profile Page');
    _setLogEvent();
    print("SCS : Profile Page succeeded");
  }
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Profile_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Profile Page',
        }
    );
  }
  @override
  Future<DocumentSnapshot> getUserInfo() {
    // Call the user's CollectionReference to add a new user
    FBauth.User currentFB =  FBauth.FirebaseAuth.instance.currentUser;
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('user');
    return usersCollection
        .doc(currentFB.uid)
        .get();
  }
  void initState() {
    
    super.initState();
    _setCurrentScreen();

    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      //print(_controller.index);
    });
  }


  @override
  Widget build(BuildContext context) {
    var _screen = MediaQuery.of(context).size;
    
    return FutureBuilder<DocumentSnapshot>(
      future: getUserInfo(),
      builder:
      (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          print(data);
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
                    data["Username"],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                ],
              ),
              trailing: Builder(
                builder: (context) =>
                    IconButton(
                      icon: Icon(Icons.article_outlined),
                      color: Colors.white,
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations
                          .of(context)
                          .openAppDrawerTooltip,
                    ),
              ),

              profileStats: profileStats(screen: _screen,
                  color: Colors.white,
                  post: _postnum,
                  followers: _followers,
                  following: _following,
                  context: context),
              bio: bio(name: data["FullName"], biodata: data["Bio"]),
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
            endDrawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text( data["FullName"]),
                    accountEmail: Text(data["Email"]),//TODO: add email to the firestore database
                    currentAccountPicture: GestureDetector(
                      child: Hero(
                        tag: '${profuser.imageUrlAvatar}1',
                        child: CircleAvatar(
                          backgroundImage: AssetImage(profuser.imageUrlAvatar),
                          radius: 90,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen(
                            ImageUrlPost: profuser.imageUrlAvatar,);
                        }));
                      },
                    ),
                    decoration: new BoxDecoration(
                      color: AppColors.darkpurple,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/homefeed');
                    },
                    child: ListTile(
                      title: Text('Home Page'),
                      leading: Icon(Icons.home),
                    ),
                  ),

                  InkWell(
                    onTap: () => Navigator.pushNamed(context, "/editprofile"),
                    child: ListTile(
                      title: Text('Edit Profile'),
                      leading: Icon(Icons.edit_outlined),
                    ),
                  ),

                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Favourites'),
                      leading: Icon(Icons.bookmark),
                    ),
                  ),

                  Divider(),
                  InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Settings'),
                      leading: Icon(Icons.settings),
                    ),
                  ),


                  InkWell(
                    onTap: () {
                      Authentication.signOutWithGoogle(context: context);
                      FBauth.FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushReplacementNamed(context, '/welcome');
                      });
                    },
                    child: ListTile(
                      title: Text('Log out'),
                      leading: Icon(
                        Icons.transit_enterexit, color: Colors.grey,),
                    ),
                  ),

                ],
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
          );
        }
        return Text("loading");
    },);
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
