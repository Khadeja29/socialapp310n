import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/models/notifications.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';
import 'package:socialapp310/routes/notifications/activity_app_bar.dart';
import 'package:socialapp310/routes/notifications/activity_tile.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/utils/dimension.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';
import 'package:socialapp310/routes/uploadpic/uploadpic.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedIndex = 3; //notif page initial index is 3
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Notif Page');
    _setLogEvent();
    print("SCS : Notif Page succeeded");
  }
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Notif_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Notif Page',
        }
    );
  }
  void initState() {
    super.initState();
    _setCurrentScreen();
  }

  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;
      if(index == 0) {
        Navigator.of(context).pushReplacementNamed('/homefeed');
      }

      //TODO: if index 0 push homepage, if index 1 push search page, if index 2 push create page,
      //TODO: if index 3 nothing happens, if index 4 push profile page

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
    Size _screen = MediaQuery.of(context).size;
    return Scaffold(
          appBar: ActivityAppBar(height: 65),
          body: Container(
          // height: _screen.height,
          // width: _screen.width,
          // color: Theme.of(context).primaryColorDark,
          child: ListView.builder(
          itemCount: notifs.length,
          itemBuilder: (context, index) => ActivityTile(
            activity: notifs[index],
            // press: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) =>SingleProduct(id: products[index].productId),
            //     )),
            ),
          ),
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
