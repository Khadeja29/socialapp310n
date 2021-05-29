import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;

class Settings extends StatefulWidget {
  const Settings({Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> deactivateUser() {
    // Call the user's CollectionReference to add a new user
    FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('user');
    return usersCollection
        .doc(currentFB.uid)
        .update({'IsDeactivated': true})
        .then((value) => CoolAlert.show(
            context: context,
            type: CoolAlertType.success,
            text: "Successfully deleted",
           //backgroundColor: AppColors.lightgrey,
            borderRadius: 40,
            confirmBtnColor: AppColors.darkpurple,
            onConfirmBtnTap: () {
              Navigator.pushReplacementNamed(context, '/welcome');
            }))
        .catchError((error) => print("Failed to deactivate user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    bool isSwitched = true;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: AppColors.darkpurple,
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/deleteaccount');
              },
              child: ListTile(
                title: Text('Delete Account',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.7,
                        fontFamily: 'OpenSansCondensed-Bold',
                        color: Colors.black)),
                leading: Icon(Icons.auto_delete_outlined),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            InkWell(
              child: ListTile(
                  title: Text('Deactivate Account',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.7,
                          fontFamily: 'OpenSansCondensed-Bold',
                          color: Colors.black)),
                  leading: Icon(Icons.admin_panel_settings_rounded),
                  trailing: OutlinedButton(
                    onPressed: () {
                      deactivateUser();
                    },
                    child: Text(
                      'Deactivate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: -0.7,
                        fontFamily: 'OpenSansCondensed-Bold',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primarypurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side:
                          BorderSide(width: 2, color: AppColors.primarypurple),
                    ),
                  )),
            ),
            Divider(
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homefeed');
              },
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
