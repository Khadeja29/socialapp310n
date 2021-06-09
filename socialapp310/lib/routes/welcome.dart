import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Welcome Page');
    _setLogEvent();
    print("SCS : Welcome Page succeeded");
  }
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Welcome_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Welcome Page',
        }
    );
  }
  void initState() {
    super.initState();
    _setCurrentScreen();
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Welcome to Woof", style: kHeadingTextStyle ,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset('assets/images/welcoming.png',height: 370,
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
                        SizedBox(height:20),
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
                        SizedBox(height:20),
                        GoogleSignInButton(),
                      ],
                    )
                  ],
                ),
              )

          )
      ),
    );
  }
}

class Authentication {

  static Future<User> signInWithGoogle({BuildContext context}) async {//TODO: take inputs for user info.
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
      ],);

    final GoogleSignInAccount googleSignInAccount =
    await googleSignIn.signIn();
    print(googleSignInAccount);
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        print("here1");
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);
        print("here2");
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
      //TODO: add information to firestore.
    }

    return user;
  }
  static Future<User> signOutWithGoogle({BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.disconnect();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 500),
          backgroundColor: Colors.grey,
          content: Text(
            "Logging Out",
            style: TextStyle(color: Colors.deepPurpleAccent, letterSpacing: 0.5),
          ),
        ),
      );
    }
  }
}

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 400.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: _isSigningIn
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        )
            : OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: () async {
            setState(() {
              _isSigningIn = true;
            });

            User user =
            await Authentication.signInWithGoogle(context: context);

            setState(() {
              _isSigningIn = false;
            });

          if (user != null) {
            //TODO: take user id and check if it exists in firestore
            //TODO: if doesnt exist take to page to fill out info
            //TODO: if does exist push to home page
            bool exists = await UserFxns.UserExistsinFireStore(user.uid);
            if(exists)
            {Navigator.of(context).pushReplacementNamed('/homefeed');}
            else {Navigator.of(context).pushNamedAndRemoveUntil('/signupfinishgoogle', (route) => false);}
          }

            setState(() {
              _isSigningIn = false;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/images/googlelogo.png"),
                height: 20.0,
                width: 20,
                  fit:BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.darkpurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}