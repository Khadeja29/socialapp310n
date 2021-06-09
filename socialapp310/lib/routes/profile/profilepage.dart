import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:flutter/material.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/models/location.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
import 'package:socialapp310/routes/profile/userList.dart';
import 'package:socialapp310/routes/subscribelocation/subscribelocation.dart';
import 'package:socialapp310/routes/welcome.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/models/Post1.dart';
import 'package:socialapp310/routes/profile/PostScreen.dart';
import 'package:socialapp310/routes/profile/FollowRequest.dart';

final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final usersRef = FirebaseFirestore.instance.collection('user');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');
final getpostRef = FirebaseFirestore.instance.collection('Post');
final favoriteRef = FirebaseFirestore.instance.collection('Favorites');
final followrequestRef = FirebaseFirestore.instance.collection('FollowRequests');
final subLocationRef = FirebaseFirestore.instance.collection('subbedLocations');

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.analytics, this.observer, this.UID, this.index}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final String UID;
  final int index;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  //Variables
  String postOrientation = "grid";
  int _selectedIndex = 4;
  List<Post1> _PostsToBuild = [];
  List<LocationModel> _locations= [];
  List<bool> _subbed_locations =[];
  String UID;
  User currentUser = FirebaseAuth.instance.currentUser;
  String username;
  bool isFollowing = false;
  int followerCount;
  int followingCount;
  int PostCount;
  bool _isPrivate = true;
  bool waiting = true;
  bool isLoading = true;
  bool _Requested = false;
  //Analytics
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Profile_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Profile Page',
        }
    );
  }

  Future<DocumentSnapshot> _listFuture;

  //init State
  void initState() {

    super.initState();


    _setupall();

  }

  _setupall() async {
    if(widget.UID != null)
    {
      UID = widget.UID;
    }
    else {
      UID = currentUser.uid;
    }
    setState(() {

      isLoading = true;
    });
    _setCurrentScreen();

    getFollowers();
    getFollowing();
    GetPosts();
    GetLocations();
    _listFuture = getUserInfo();
    await checkIfFollowing();
    setState(() {

      isLoading = false;
      waiting = false;
    });

  }
  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(UID)
        .collection('userFollowers')
        .doc(currentUser.uid)
        .get();
    var ProfileUser;
    bool isPrivate;
    bool Requested = false;
    if(UID != currentUser.uid) {
      ProfileUser = await usersRef.doc(UID).get();
      isPrivate = ProfileUser.data()["IsPrivate"];
    }
    else {
      isPrivate = false;
    }

    setState(() {

      isFollowing = doc.exists;
      _isPrivate = isPrivate;

      print(_isPrivate);
    });
    if(isPrivate)
    {
      await followrequestRef
          .doc(UID)
          .collection('requests')
          .doc(currentUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          print("here");
          Requested = true;
        }});
    }
    setState(() {
      print("Requested is $Requested");
      _Requested = Requested;
    });
  }
  GetPosts() async {
    setState(() {
      //isLoading = true;
    });
    List<Post1> PostsToBuild = [];
    QuerySnapshot snapshot = await getpostRef
        .where("PostUser" , isEqualTo: UID)
        .orderBy("createdAt", descending: true)
        .get();
    for( var doc in snapshot.docs){
      Map<String, dynamic> map = doc.data();
      Post1 post = Post1(
        caption: doc["Caption"],
        imageURL: doc["Image"],
        likes: doc["Likes"],
        createdAt: doc["createdAt"],
        isPrivate: doc["IsPrivate"],
        location: doc["Location"],
        UserID: doc["PostUser"],
        PostID: doc.id,
        LikesMap : doc['LikesMap'],
        locationName: map.containsKey('Locationname') ? doc['Locationname']: "temp",
      );

      PostsToBuild.add(post);
    }
    setState(() {
      PostCount = snapshot.docs.length;
      _PostsToBuild = PostsToBuild;
      //isLoading = false;
    });

  }
  GetLocations() async {
    List<LocationModel> locations= [];
    List<bool> subbed_locations =[];
    QuerySnapshot snapshot = await subLocationRef
                            .where("UserId" , isEqualTo: widget.UID == null? currentUser.uid : widget.UID)
                            .get();
    for( var doc in snapshot.docs) {
      Map<String, dynamic> map = doc.data();
      LocationModel loc = LocationModel(
          loc_name: doc['address'],
          loc_id: doc['LocationId']
      );
      locations.add(loc);
      subbed_locations.add(true);
    }
    setState(() {
      _locations = locations;
      _subbed_locations = subbed_locations;
    });
  }
  int currentindex() {
    if(widget.index != null)
    {return widget.index;}
    else {return 4;}
  }
  getFollowers() async {

    QuerySnapshot snapshot = await followersRef
        .doc(UID)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;

    });
  }
  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(UID)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;

    });
  }
  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
      followerCount--;
    });
    // remove follower
    followersRef
        .doc(widget.UID)
        .collection('userFollowers')
        .doc(currentUser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove following
    followingRef
        .doc(currentUser.uid)
        .collection('userFollowing')
        .doc(widget.UID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    activityFeedRef
        .doc(widget.UID)
        .collection('feedItems')
        .doc(currentUser.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

  }
  handleFollowUser() async {
    setState(() {
      isFollowing = true;
      followerCount++;
    });
    // Make auth user follower of THAT user (update THEIR followers collection)
    followersRef
        .doc(widget.UID)
        .collection('userFollowers')
        .doc(currentUser.uid)
        .set({});
    // Put THAT user on YOUR following collection (update your following collection)
    followingRef
        .doc(currentUser.uid)
        .collection('userFollowing')
        .doc(widget.UID)
        .set({});
    // add activity feed item for that user to notify about new follower (us)

    //String username = await UserFxns.getUserName();
    //String userProfileImg = await UserFxns.getProfilePic();
    var timestamp = DateTime.now();
    activityFeedRef
        .doc(widget.UID)
        .collection('feedItems')
        .doc(currentUser.uid)
        .set({//todo think about adding post id(as an empty value) or not
      "PostID": "NoPost",
      "type": "follow",
      "ownerId": widget.UID,
      //"username": username,//todo: pass username from previous page
      "userId": currentUser.uid,
      "commentData": "",
      //"userProfileImg": userProfileImg,
      "timestamp": timestamp,
    });

  }
  handleFollowRequest() async {
    bool Requested;
    if(!_Requested)
    {
      //Request follow
      await followrequestRef
          .doc(UID)
          .collection('requests')
          .doc(currentUser.uid)
          .set({});
      Requested = true;
    }
    else if(_Requested){
      //cancel follow

      await followrequestRef
          .doc(UID)
          .collection('requests')
          .doc(currentUser.uid)
          .get()
          .then((doc) {
        if (doc.exists) {

          doc.reference.delete();
        }
      });
      Requested = false;
    }
    setState(() {
      _Requested = Requested;
    });
  }
  //BottomNavBar
  void _onItemTapped(int index) {
    setState(() {

      _selectedIndex = index;//TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, '/homefeed');
      }
      else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, '/search');
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacementNamed(context,'/uploadpic');}
      else if (_selectedIndex == 3) {
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

  //Get user functions //TODO:replicated use from UserFnx try to remove
  @override
  Future<DocumentSnapshot> getUserInfo() {
    FBauth.User currentFB =  FBauth.FirebaseAuth.instance.currentUser;

    //final args = ModalRoute.of(context).settings.arguments as PassingUID;
    //UID = args.UID;
    if(widget.UID != null)
    {
      UID = widget.UID;
    }
    else {
      UID = currentUser.uid;
    }
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('user');
    return usersCollection
        .doc(UID)
        .get();
  }

  //Displaying count of posts, followers and following
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

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 200.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: isFollowing ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : AppColors.peachpink,
            border: Border.all(
              color: isFollowing ? Colors.grey : AppColors.peachpink,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
  //Follow/unfollow button and Edit Profile Buttton
  buildProfileButton() {
    // viewing your own profile - should show edit profile button

    bool isProfileOwner = (currentUser.uid == UID);
    if(waiting)
    {
      return Text("");
    }
    if (isProfileOwner) {
      return buildButton(
        text: "Edit Profile",
        function: () {
          Navigator.pushNamed(context, "/editprofile");
        },
      );
    } else if (isFollowing) {
      return buildButton(
        text: "Unfollow",
        function: (){handleUnfollowUser();},

      );
    } else if (!isFollowing && !_isPrivate) {
      return buildButton(
        text: "Follow",
        function: (){handleFollowUser();},

      );
    }
    else if(!isFollowing && _isPrivate && !_Requested)
    {return buildButton(
      text: "Request Follow",
      function: (){handleFollowRequest();},//TODO: request follow system

    );
    }
    else if(!isFollowing && _isPrivate && _Requested)
    {
      return buildButton(
        text: "Follow already Requested.",
        function: (){handleFollowRequest();},//TODO: request follow system
      );
    }
  }

  //Main Header Widget: Avatar,following,follower,Post count,Bio,Username,Name
  buildProfileHeader() {
    return FutureBuilder(
      future: _listFuture,
      builder: (context, snapshot) {

        if (!(snapshot.connectionState == ConnectionState.done)) {
          return (Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      AppColors.primarypurple))));
        }
        else{
          Map<String, dynamic> data = snapshot.data.data();
          return !waiting ? Padding(
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
                          return DetailScreenLink(
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
                              buildCountColumn("posts", PostCount),

                              GestureDetector(
                                  onTap: () => {
                                    Navigator.push(context, MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>  userList(

                                        analytics: AppBase.analytics,
                                        observer: AppBase.observer,
                                        userID: widget.UID == null ? currentUser.uid : widget.UID,
                                        userName: data['Username'],
                                        navBarIndex: currentindex(),
                                        currentUserId: currentUser.uid,
                                        followersCount: followerCount,
                                        followingCount: followingCount, selectedTab: 0,
                                        updateFollowersCount: (count) {
                                          setState(() => followerCount = count);
                                        },
                                        updateFollowingCount: (count) {
                                          setState(() => followingCount = count);
                                        },


                                      ),
                                    ),)
                                  },
                                  child: buildCountColumn("followers", followerCount)
                              ),
                              GestureDetector(
                                  onTap: () => {
                                    Navigator.push(context, MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>  userList(
                                        analytics: AppBase.analytics,
                                        observer: AppBase.observer,
                                        userID: widget.UID == null ? currentUser.uid : widget.UID,
                                        userName: data['Username'],
                                        navBarIndex: currentindex(),
                                        currentUserId: currentUser.uid,
                                        followersCount: followerCount,
                                        followingCount: followingCount,
                                        selectedTab: 1,
                                        updateFollowersCount: (count) {
                                          setState(() => followerCount = count);
                                        },
                                        updateFollowingCount: (count) {
                                          setState(() => followingCount = count);
                                        },
                                      ),
                                    ),)
                                  },
                                  child: buildCountColumn("following", followingCount)
                              ),
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
          ) : Text("");
        }

      },
    );
  }

  //Tab Bar View
  setPostOrientation(String postOrientation) {
    setState(() {
      this.postOrientation = postOrientation;
    });
  }
  buildTogglePostOrientation() {
    if(waiting)
    {
      return Text("");
    }
    return (!_isPrivate || isFollowing) ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  <Widget>[
        IconButton(
          onPressed: () => setPostOrientation("grid"),
          icon: Icon(Icons.grid_on),
          color: postOrientation == 'grid'
              ? AppColors.peachpink
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setPostOrientation("locations"),
          icon: Icon(Icons.add_location),
          color: postOrientation == 'locations'
              ? AppColors.peachpink
              : Colors.grey,
        ),
        IconButton(
          onPressed: () => setPostOrientation("list"),
          icon: Icon(Icons.list),
          color: postOrientation == 'list'
              ? AppColors.peachpink
              : Colors.grey,
        ),
      ] ,
    ): Image(image: AssetImage("assets/images/Private.png"),);
  }

  buildTripCard(BuildContext context, int index) {
    final loc = _locations[index].loc_name;
    final loc_id = _locations[index].loc_id;
    final subbed = _subbed_locations[index];
    return new Container(
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute<void>(
            builder:(BuildContext context) =>
                SubcribeLocation(analytics: AppBase.analytics, observer: AppBase.observer, place_id: loc_id, address: loc ),
          ),).then((value) => GetLocations());
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, size: 18, color: AppColors.darkpurple,),
                    SizedBox(width: 5,),
                    Flexible(child: Container(child: Text("$loc", style: new TextStyle(fontSize: 18.0), overflow: TextOverflow.ellipsis,))),//todo fix this
                  ],
                ),
                Visibility(
                  visible: widget.UID == null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        child: subbed ? Text('Subscribed') : Text("Unsubscribed"),
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.peachpink,
                          onPrimary: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 5,
                        ),
                        onPressed: () async{
                          if(_subbed_locations[index])
                          {
                            //unsub logic
                            await subLocationRef.where("UserId" ,isEqualTo: currentUser.uid)
                                .where("LocationId", isEqualTo: _locations[index].loc_id )
                                .get().then((value) => value.docs.first.reference.delete()) ;
                          }
                          else {
                            //sub logic
                            await subLocationRef.add({
                              "LocationId" : _locations[index].loc_id,
                              "address" : _locations[index].loc_name,
                              "UserId" : currentUser.uid
                            });
                          }
                          setState(() {
                            _subbed_locations[index] = !_subbed_locations[index];
                          });
                          //todo:add logic to remove/add loc from database
                          //add logic so that if current user and other user it does different things
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  buildProfilePosts()  {
    if (isLoading) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  AppColors.primarypurple)),
        ),
      );
    }
    else if(_isPrivate && !isFollowing){
      return Text(" ");
    }
    else if (_PostsToBuild.isEmpty && postOrientation!="locations") {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50,),
            Image(
              image: AssetImage("assets/images/images.png"),
            ),
          ],
        ),
      );
    }
    else if (postOrientation == "grid") {
      List<GridTile> gridTiles = [];
      int currindex = currentindex();
      _PostsToBuild.forEach((post) {
        gridTiles.add(GridTile(child: PostTile(post,currindex)));
      });

      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTiles,
      );
    }
    else if (postOrientation == "list") {
      return Column(
        children: _PostsToBuild.map((post) => PostCard(post: post)).toList(),
      );
    }
    else if (postOrientation == "locations") {

      return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _locations.length,
          itemBuilder: (BuildContext context, int index) =>
              buildTripCard(context, index)
      );
    }

  }

  //Main Page function
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.darkpurple,
          title:  Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Text('Profile'),
          )
      ),

      body: ListView(
        children: <Widget>[
          //Header Widget Called
          buildProfileHeader(),
          Divider(),
          //Tab Bar view widget
          buildTogglePostOrientation(),
          Divider(
            height: 0.0,
          ),
          buildProfilePosts(),
        ],
      ),
      // DRAWER
      endDrawer: widget.UID == null ? Drawer(
        child: FutureBuilder(
          future: _listFuture,
          builder: (context, snapshot) {

            if (!(snapshot.connectionState == ConnectionState.done)) {
              return (Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          AppColors.primarypurple))));
            }
            else{
              Map<String, dynamic> data = snapshot.data.data();
              return ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text( data["FullName"]),
                    accountEmail: Text(data["Email"]),//TODO: add email to the firestore database
                    currentAccountPicture: GestureDetector(
                      child: Hero(
                        tag: '${data["ProfilePic"]} ',
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
                    onTap: () {
                      Navigator.pushNamed(context, '/favourites');
                    },
                    child: ListTile(
                      title: Text('Favourites'),
                      leading: Icon(Icons.bookmark),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //TODO create page to accept requests
                      //We can pass userid and username and profile pic
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FollowReq(
                            analytics: AppBase.analytics,
                            observer: AppBase.observer,
                            UID: currentUser.uid,
                            Username: data["Username"],
                            UserProfileImg: data["ProfilePic"],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Follow Requests'),
                      leading: Icon(Icons.person),
                    ),
                  ) ,
                  Divider(),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, "/settings"),
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
      ) : null,
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
        currentIndex: currentindex(),
        onTap: _onItemTapped,
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  final Post1 post;
  final int index;

  PostTile(this.post,this.index);

  showPost(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostScreen(
          postId: post.PostID,
          userId: post.UserID,
          index: index,

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPost(context),
      child: Container(
        padding:  EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Image(
            fit: BoxFit.cover,
            image:
            NetworkImage(post.imageURL),
          ),
        ),
      ),
    );
  }
}
