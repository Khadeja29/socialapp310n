import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
//final usersReference = Firestore.instance.collection("users").

class Welcome extends StatefulWidget {
  const Welcome({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isSignedIn = false;

  controlSignIn(GoogleSignInAccount signInAccount) async {
      if(signInAccount != null){
        setState(() {
          isSignedIn = true;
          print("signed in");
        });
      }else{
        setState(() {
          isSignedIn = false;
          print("not signed in");

        });
      }
  }

  loginUser(){
    //await saveUserInfoToFireStore();
    gSignIn.signIn();
    //Navigator.of(context).pushNamedAndRemoveUntil(
      //  "/homefeed", (
        //Route<dynamic> route) => false);

  }
   logOutUser(){
    gSignIn.signOut();
   }

  //saveUserInfoToFireStore() async {
    //final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    //DocumentSnapshot documentSnapshot = await
  //}

  Future<void> _setCurrentScreen() async {
    print("before await");
    await widget.analytics.setCurrentScreen(screenName: 'Welcome Page');
    print("SCS : Welcome Page succeeded");
  }
  void initState() {
    super.initState();
    _setCurrentScreen();

    gSignIn.onCurrentUserChanged.listen((gSignInAccount){
        controlSignIn(gSignInAccount);
    }, onError: (gError){
      print("Error Message ");

    });


    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount){
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print("Error Message1 ");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.darkgreyblack,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
            //width: double.infinity,
            //height: MediaQuery.of(context).size.height/3,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Welcome to Woof", style: kHeadingTextStyle ,),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Image.asset('assets/images/welcoming.png',height: 270,
                      width: 370,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        height: 60.0,
                        width: 400.0,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),


                          child:   SignInButton(
                            Buttons.Google,
                            onPressed: () {
                                  loginUser();

                            },
                          ),
                        ),
                      ),
                      SizedBox(height:10),
                      Container(
                        height: 60.0,
                        width: 400.0,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),

                          child: OutlinedButton(

                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),

                              ),
                              backgroundColor: AppColors.lightgrey,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30),
                              child: Text(
                                  'Login',
                                  style:  TextStyle(
                                      color: AppColors.darkpurple,
                                      fontSize: 20.0,
                                      letterSpacing: -0.7,
                                      fontFamily: 'OpenSansCondensed-Light'
                                  )
                              ),
                            ),

                          ),
                        ),
                      ),
                      SizedBox(height:10),
                      Container(
                        height: 60.0,
                        width: 400.0,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),

                          child: OutlinedButton(

                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),

                              ),
                              backgroundColor: AppColors.darkpurple,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30),
                              child: Text(
                                  'Sign up',
                                  style:  TextStyle(
                                      color: AppColors.lightgrey,
                                      fontSize: 20.0,
                                      letterSpacing: -0.7,
                                      fontFamily: 'OpenSansCondensed-Light'
                                  )
                              ),
                            ),

                          ),
                        ),
                      ),

                    ],
                  )
                ],
              )

          )
      ),
    );
  }
}