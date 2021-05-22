import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:flutter/material.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
import 'package:socialapp310/routes/welcome.dart';


import 'package:socialapp310/utils/color.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String postOrientation = "grid";
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

    FBauth.User currentFB =  FBauth.FirebaseAuth.instance.currentUser;
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('user');
    return usersCollection
        .doc(currentFB.uid)
        .get();
  }
  void initState() {

    super.initState();
    _setCurrentScreen();

  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  buildProfileButton() {
    return Text("profile button");
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: getUserInfo(),
      builder: (context, snapshot) {
        Map<String, dynamic> data = snapshot.data.data();
        if (!snapshot.hasData) {
          return (Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      AppColors.primarypurple))));
        }
        else{
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Hero(
                        tag: '${data["ProfilePic"]}',
                        child:   CircleAvatar(
                          radius: 55.0,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(data["ProfilePic"]),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen(
                            ImageUrlPost: data["ProfilePic"],
                          );
                        }));
                      },
                    ), //TODO:fix the error when image clicked
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildCountColumn("posts", 0),
                              buildCountColumn("followers", 0),
                              buildCountColumn("following", 0),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildProfileButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text(
                    data["FullName"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkpurple,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text("@${data["Username"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 7.0),
                  child: Text(
                    data["Bio"],
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

      },
    );
  }

  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }


  buildTogglePostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed: () => setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == 'grid'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == 'list'
              ? Theme.of(context).primaryColor
              : Colors.grey,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: AppColors.primarypurple,
        title: Center(
            child: Text('Profile')),
    ),
      body: ListView(
        children: <Widget>[
          buildProfileHeader(),
          Divider(),
          buildTogglePostOrientation(),
          Divider(
            height: 0.0,
          ),
        ],
      ),
      // DRAWER
      endDrawer: Drawer(
        child: FutureBuilder(
          future: getUserInfo(),
          builder: (context, snapshot) {
            Map<String, dynamic> data = snapshot.data.data();
            if (!snapshot.hasData) {
              return (Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          AppColors.primarypurple))));
            }
            else{
              return ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text( data["FullName"]),
                    accountEmail: Text(data["Email"]),//TODO: add email to the firestore database
                    currentAccountPicture: GestureDetector(
                      child: Hero(
                        tag: '${data["ProfilePic"]}1',
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(data["ProfilePic"]),
                          radius: 90,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreenLink(
                            ImageUrlPost: data["ProfilePic"],);
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
              );
            }
            },

        ),
      ),
    );
  }

}




