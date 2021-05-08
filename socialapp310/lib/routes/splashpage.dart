import 'package:flutter/material.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/routes/walkthrough.dart';
import 'dart:async';
import 'package:socialapp310/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp310/routes/welcome.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('_seen') ?? false);
    //print(_seen);
    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Welcome()));
    } else {
      await prefs.setBool('_seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new WalkThrough()));
    }
  }
  void initState() {
    super.initState();

    Timer(Duration(seconds: 4), () => checkFirstSeen()); //TODO:ADD CONTEXT TO ONBOARDING SCREENS

  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: AppColors.darkpurple),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logo_woof.png'),
                        radius: 90,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text( "Woof",
                        style: TextStyle(
                          //fontFamily: 'OpenSansCondensed-LightItalic',
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFffffff),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightgrey),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),

                    Column(
                      children: [
                        Text( "All your pals under one roof!",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkgreyblack,
                          ),
                        ),
                        Text( "Stay Connected",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.peachpink,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}