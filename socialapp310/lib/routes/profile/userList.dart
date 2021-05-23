import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';

class userList extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final User user; //TODO: get the user who's profile page and following list we are using ? defined user class
  final int followersCount;
  final int followingCount;
  final int selectedTab; // 0 - Followers / 1 - Following
  final String currenUserId;
  final Function updateFollowersCount;
  final Function updateFollowingCount;

  const userList({
    Key key,
    this.analytics,
    this.observer,
    this.user,
    this.followersCount,
    this.followingCount,
    this.selectedTab,
    this.currenUserId,
    this.updateFollowersCount,
    this.updateFollowingCount}): super (key: key);

  @override
  _userListState createState() => _userListState();
}

class _userListState extends State<userList>{
  List<User> _userFollowers = [];
  List<User> _userFollowing = [];
  bool _isLoading = false;
  List<bool> _userFollowersState = [];
  List<bool> _userFollowingState = [];
  int _followingCount;
  int _followersCount;



  void initState() {

    super.initState();
    _setCurrentScreen();
    setState(() {
      _followersCount = widget.followersCount;
      _followingCount = widget.followingCount;
    });
    _setupAll();

  }

  _setupAll() async {
    setState(() {
      _isLoading = true;
    });
    await _setupFollowers();
    await _setupFollowing();
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
                Text(widget.user.name),
                UserBadges(user: widget.user, size: 15),
              ],
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  text:
                  '${NumberFormat.compact().format(_followersCount)} Followers',
                ),
                Tab(
                  text:
                  '${NumberFormat.compact().format(_followingCount)} Following',
                ),
              ],
            )),
        body: !_isLoading
            ? TabBarView(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _isLoading = true;
                });
                await _setupFollowers();
                setState(() {
                  _isLoading = false;
                });
              },
              child: ListView.builder(
                itemCount: _userFollowers.length,
                itemBuilder: (BuildContext context, int index) {
                  User follower = _userFollowers[index];
                  return _buildFollower(follower, index);
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _isLoading = true;
                });
                await _setupFollowing();
                setState(() {
                  _isLoading = false;
                });
              },
              child: ListView.builder(
                itemCount: _userFollowing.length,
                itemBuilder: (BuildContext context, int index) {
                  User follower = _userFollowing[index];
                  return _buildFollowing(follower, index);
                },
              ),
            ),
          ],
        )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

}
