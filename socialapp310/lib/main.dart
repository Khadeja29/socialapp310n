import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/routes/finishsignupgoogle.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';
import 'package:socialapp310/routes/finishsignup.dart';
import 'package:socialapp310/routes/profile/editprofile.dart';
import 'package:socialapp310/routes/search/search.dart';
import 'package:socialapp310/routes/notifications/notifications.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/routes/signup.dart';
import 'package:socialapp310/routes/splashpage.dart';
import 'package:socialapp310/routes/login.dart';

import 'package:socialapp310/routes/profile/userList.dart';

import 'package:socialapp310/routes/unknownwelcome.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';
import 'package:socialapp310/routes/uploadpic/uploadpic.dart';

import 'package:socialapp310/routes/walkthrough.dart';
import 'package:socialapp310/routes/welcome.dart';
import 'package:socialapp310/routes/uploadpic/Mappage.dart';
import 'package:socialapp310/routes/welcomeNoFirebase.dart';
import 'package:socialapp310/routes/searchlocation/searchlocation.dart';
import 'package:socialapp310/routes/profile/PostScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot){
        print(snapshot.connectionState);
        if(snapshot.hasError)
        {
          print("cannot connect to firebase" + snapshot.error);
          return MaterialApp(
              home: WelcomeViewNoFB()
          );
        }
        else if(snapshot.connectionState == ConnectionState.done){
          return AppBase();
        }
        return MaterialApp(
            home: WelcomeViewNoFB()
        );
      },
    );

  }
}

class AppBase extends StatelessWidget {
  const AppBase({
    Key key,
  }) : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      home: SplashScreen(analytics: analytics, observer: observer,),
      routes: {
        '/searchlocation': (context) => SearchLocation(analytics: analytics, observer: observer,),
        '/welcome': (context) => Welcome(analytics: analytics, observer: observer,),
        '/login': (context) => Login(analytics: analytics, observer: observer,),
        '/signup': (context) => SignUp(analytics: analytics, observer: observer,),
        '/walkthrough' :(context) => WalkThrough(analytics: analytics, observer: observer,),
        '/signupfinish': (context) => FinishSignupPage(analytics: analytics, observer: observer,),
        '/notifications': (context) => ActivityScreen(analytics: analytics, observer: observer,),
        '/homefeed': (context) => HomeFeed(analytics: analytics, observer: observer,),
        '/profile': (context) => ProfileScreen(analytics: analytics, observer: observer,),
        '/search' : (context) => Search(analytics: analytics, observer: observer,),
        '/editprofile' : (context) => EditProfilePage(analytics: analytics, observer: observer,),
        '/signupfinishgoogle' : (context) => FinishSignupPageGoogle(analytics: analytics, observer: observer,),
        '/userList' : (context) => userList(analytics: analytics, observer: observer,),
        '/uploadpic' : (context) => Uploadpic(analytics: analytics, observer: observer,),
        '/creatpost' :  (context) => CreatePost(analytics: analytics, observer: observer,),
        //'/postscreen' : (context) => PostScreen(analytics: analytics, observer: observer,),
      },
    );
  }
}