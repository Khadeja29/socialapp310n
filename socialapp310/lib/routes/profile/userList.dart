import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/models/user1.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';

class userList extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final int navBarIndex;
  final String userID;
  final String userName;
  final int followersCount;
  final int followingCount;
  int selectedTab; // 0 - Followers / 1 - Following
  final String currentUserId;
  final Function updateFollowersCount;
  final Function updateFollowingCount;

  userList({
    Key key,
    this.analytics,
    this.observer,
    this.navBarIndex,
    this.userID,
    this.userName,
    this.followersCount,
    this.followingCount,
    this.selectedTab,
    this.updateFollowersCount,
    this.updateFollowingCount,
    this.currentUserId,}): super (key: key);

  @override
  _userListState createState() => _userListState();
}

class _userListState extends State<userList>{
  List<User1> _userFollowers = [];
  List<User1> _userFollowing = [];
  bool _isLoading = false;
  List<bool> _userFollowersState = [];
  List<bool> _userFollowingState = [];
  int _followingCount;
  int _followersCount;
  Future<DocumentSnapshot> _listFuture1;
  Future<DocumentSnapshot> _listFuture2;

  Future<DocumentSnapshot> getFollowers() async {
    List<User1> userFollowers = [];
    List<bool> userFollowersState = [];
    DocumentSnapshot docsnap;
    QuerySnapshot snapshot = await followersRef
        .doc(widget.userID)
        .collection('userFollowers')
        .get();
    for(var doc in snapshot.docs) {
      docsnap =
      await usersRef
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

      userFollowers.add(user);
      userFollowersState.add(true);

    }

    setState(() {
      _followersCount = snapshot.docs.length;
      _userFollowersState = userFollowersState;
      _userFollowers = userFollowers;
    });

    return docsnap;
  }
  Future<DocumentSnapshot> getFollowing() async {
    List<User1> userFollowing = [];
    List<bool> userFollowingState = [];
    DocumentSnapshot docsnap;
    QuerySnapshot snapshot = await followingRef
        .doc(widget.userID)
        .collection('userFollowing')
        .get();
    for(var doc in snapshot.docs) {

      docsnap =
      await usersRef
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
      userFollowing.add(user);
      userFollowingState.add(true);
    }

    setState(() {

      _followingCount = snapshot.docs.length;
      _userFollowingState = userFollowingState;
      _userFollowing = userFollowing;
    });
    return docsnap;
  }

  _buildFollowingButton(User1 user, int index) {
    return FlatButton(
      color: _userFollowingState[index] ? Colors.transparent : Colors.deepOrange[400],
      onPressed: () async {
        if (_userFollowingState[index] == true) {
          followersRef
              .doc(user.UID)
              .collection('userFollowers')
              .doc(widget.currentUserId)
              .get()
              .then((doc) {
            if (doc.exists) {
              doc.reference.delete();
            }
          });
          // remove following
          followingRef
              .doc(widget.currentUserId)
              .collection('userFollowing')
              .doc(user.UID)
              .get()
              .then((doc) {
            if (doc.exists) {
              doc.reference.delete();
            }
          });
          activityFeedRef
              .doc(user.UID)
              .collection('feedItems')
              .doc(widget.currentUserId)
              .get()
              .then((doc) {
            if (doc.exists) {
              doc.reference.delete();
            }
          });
          setState(() {
            _userFollowingState[index] = false;
            _followingCount--;
          });
          widget.updateFollowingCount(_followingCount);
        } else {
          // follow User
          followersRef
              .doc(user.UID)
              .collection('userFollowers')
              .doc(widget.currentUserId)
              .set({});
          // Put THAT user on YOUR following collection (update your following collection)
          followingRef
              .doc(widget.currentUserId)
              .collection('userFollowing')
              .doc(user.UID)
              .set({});
          String username = await UserFxns.getUserName();
          String userProfileImg = await UserFxns.getProfilePic();
          var timestamp = DateTime.now();
          // add activity feed item for that user to notify about new follower (us)
          //
          activityFeedRef
              .doc(user.UID)
              .collection('feedItems')
              .doc(widget.currentUserId)
              .set({
            "commentData" : "",
            "PostID": "NoPost",
            "type": "follow",
            "ownerId": user.UID,
            //"username": username,
            "userId": widget.currentUserId,
            //"userProfileImg": userProfileImg,
            "timestamp": timestamp,

          });

          setState(() {
            _userFollowingState[index] = true;
            _followingCount++;
          });
          widget.updateFollowingCount(_followingCount);
        }
      },
      child: Text(
        _userFollowingState[index] ? 'Unfollow' : 'Follow',
        style: TextStyle(
            color: _userFollowingState[index]
                ? Theme.of(context).accentColor
                : Colors.white),
      ),
    );
  }
  _buildFollowing(User1 user, int index) {
    return ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.grey,
          backgroundImage: user.ProfilePic.isEmpty
              ? AssetImage('assets/Dog/cutegolden.jpg')
              : NetworkImage(user.ProfilePic),
        ),
        title: Row(
          children: [
            Text(user.fullName,
              style: TextStyle(
                color: AppColors.darkpurple,
              ),),

          ],
        ),
        subtitle: Text(user.email),
        trailing: widget.userID == widget.currentUserId
            ? _buildFollowingButton(user, index)
            : SizedBox.shrink(),
        onTap: () => {
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                ProfileScreen(analytics: AppBase.analytics,
                    observer: AppBase.observer,
                    UID: user.UID,
                    index: widget.navBarIndex),
          ),)
        }
    );
  }


  _removeFollowerDialog(User1 user, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: user.ProfilePic.isEmpty
                      ? AssetImage('assets/Dog/cutegolden.jpg')
                      : NetworkImage(user.ProfilePic),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Remove Follower?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Woof won\'t tell ${user.username} they were removed from your followers.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.darkpurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            children: <Widget>[
              Divider(),
              SimpleDialogOption(
                child: Center(
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        color: AppColors.darkpurple,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                onPressed: ()
                {
                  followersRef
                      .doc(widget.currentUserId)
                      .collection('userFollowers')
                      .doc(user.UID)
                      .get()
                      .then((doc) {
                    if (doc.exists) {
                      doc.reference.delete();
                    }
                  });
                  // remove following
                  followingRef
                      .doc(user.UID)
                      .collection('userFollowing')
                      .doc(widget.currentUserId)
                      .get()
                      .then((doc) {
                    if (doc.exists) {
                      doc.reference.delete();
                    }
                  });
                  setState(() {
                    _userFollowersState.removeAt(index);
                    _userFollowers.removeAt(index);
                    _followersCount--;
                    widget.updateFollowersCount(_followersCount);
                  });
                  Navigator.pop(context);
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.darkpurple,
                    ),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
  _buildFollowerButton(User1 user, int index) {
    return FlatButton(
      onPressed: () {
        _removeFollowerDialog(user, index);
      },
      child: Text('Remove'),
    );
  }
  _buildFollower(User1 user, int index) {
    return ListTile(
        leading: CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.grey,
          backgroundImage: user.ProfilePic.isEmpty
              ? AssetImage('assets/Dog/cutegolden.jpg')
              : NetworkImage(user.ProfilePic),
        ),
        title: Row(
          children: [
            Text(user.username),
          ],
        ),
        subtitle: Text(user.email),
        trailing: widget.userID == widget.currentUserId
            ? _buildFollowerButton(user, index)
            : SizedBox.shrink(),
        onTap: () => {
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                ProfileScreen(analytics: AppBase.analytics,
                    observer: AppBase.observer,
                    UID: user.UID,
                    index: widget.navBarIndex),
          ),)
        }
    );
  }

  void initState() {

    super.initState();

    _listFuture1 = getFollowing();
    _listFuture2 = getFollowers();
    setState(() {
      _followersCount = widget.followersCount;
      _followingCount = widget.followingCount;
    });


  }


  _setupAll() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
  }

  //analytics
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'UserList Page');
    _setLogEvent();
    print("SCS : UserList Page succeeded");
  }
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Users_List_Success',
        parameters: <String, dynamic>{
          'name': 'Users List Page',
        }
    );
  }

  //MAIN BUILDER WIDGET
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      initialIndex: widget.selectedTab,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.darkpurple,
            title: Row(
              children: [
                Text(widget.userName)
              ],
            ),
            bottom: TabBar(
              onTap: (int x) {setState(() {

                _userFollowers = _userFollowers;
                _userFollowing = _userFollowing;
              });},
              tabs: [
                Tab(
                  text:
                  '${_followersCount} Followers',
                ),
                Tab(
                  text:
                  '${_followingCount} Following',
                ),
              ],
            )),
        body: true
            ? TabBarView(
          children: <Widget>[
            FutureBuilder(
              future: _listFuture2,
              builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if(snapshot.connectionState == ConnectionState.done)
                {

                  return ListView.builder(
                    itemCount: _userFollowers.length,
                    itemBuilder: (BuildContext context, int index) {

                      widget.selectedTab = 0;
                      User1 following = _userFollowers[index];
                      return _buildFollower(following, index);
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

            FutureBuilder(
              future: _listFuture1,
              builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if(snapshot.connectionState == ConnectionState.done)
                {
                  return ListView.builder(
                    itemCount: _userFollowing.length,
                    itemBuilder: (BuildContext context, int index) {

                      User1 following = _userFollowing[index];
                      return _buildFollowing(following, index);
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
        )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

}