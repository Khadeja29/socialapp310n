import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/utils/dimension.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _message = '';
  bool valid = false;
  int attemptCount = 0;
  String email;
  String password;
  String password2;
  String username;
  String fullname;
  String DefaultProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/woof310-885a0.appspot.com/o/cutegolden.jpg?alt=media&token=4e466439-58b1-45af-97a6-e08adef0121b";
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'SignUp Page');
    _setLogEvent();
    print("SCS : SignUp Page succeeded");
  }

  Future<void> _setLogEvent() async {
    await widget.analytics
        .logEvent(name: 'SignUp_Page_Success', parameters: <String, dynamic>{
      'name': 'SignUp Page',
    });
  }

  void initState() {
    super.initState();
    _setCurrentScreen();
  }

  Future<void> signUpUser() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      valid = true;
      _message = "";
      print(userCredential.toString());
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if (e.code == 'email-already-in-use') {
        _message = 'This email is already in use';
        valid = false;
      } else if (e.code == 'weak-password') {
        _message =
        'Weak password, add uppercase, lowercase, digit, special character, emoji, etc.';
        valid = false;
      }
    }
  }

  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: AppColors.darkpurple,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Dimen.regularPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              Center(
                  child: Column(children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(0.1),
                        //child: Image.asset('assets/images/social_like.png', width: 370, height: 370),
                        child: Image(
                          image: AssetImage('assets/images/arrived.png'),
                        ))
                  ])),
              SizedBox(height: 10.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: AppColors.lightgrey,
                              filled: true,
                              hintText: 'E-mail',
                              //labelText: 'username',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primarypurple, width: 1.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              errorStyle: TextStyle(
                                color: AppColors.peachpink,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.peachpink),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.peachpink, width: 2),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              labelStyle: kLabelLightTextStyle,
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.darkpurple),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your e-mail';
                              }
                              if (!EmailValidator.validate(value)) {
                                return 'The e-mail address is not valid';
                              }

                              return null;
                            },
                            onSaved: (String value) {
                              email = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: AppColors.lightgrey,
                              filled: true,
                              hintText: 'Full Name',
                              //labelText: 'username',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primarypurple, width: 1.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              errorStyle: TextStyle(
                                color: AppColors.peachpink,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.peachpink),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.peachpink, width: 2),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              labelStyle: kLabelLightTextStyle,
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.darkpurple),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your Full Name';
                              }
                              if (value.length > 16) {
                                return 'Full Name has to be less than or equal to 16 characters';
                              }
                              //Todo: add some more validation logic for full screen

                              return null;
                            },
                            onSaved: (String value) {
                              fullname = value;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: AppColors.lightgrey,
                              filled: true,
                              hintText: 'User Name',
                              //labelText: 'username',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primarypurple, width: 1.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              errorStyle: TextStyle(
                                color: AppColors.peachpink,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.peachpink),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.peachpink, width: 2),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              labelStyle: kLabelLightTextStyle,
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.darkpurple),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your username';
                              }
                              if (value.length > 8) {
                                return 'Username has to be less than or equal to 8 characters';
                              }

                              return null;
                            },
                            onSaved: (String value) {
                              username = value; //TODO: make if username
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: AppColors.lightgrey,
                              filled: true,
                              hintText: 'Password',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primarypurple, width: 1.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              errorStyle: TextStyle(
                                color: AppColors.peachpink,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.peachpink),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.peachpink, width: 2),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              //labelText: 'username',
                              labelStyle: kLabelLightTextStyle,
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.darkpurple),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              password = value;
                            },
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: AppColors.lightgrey,
                              filled: true,
                              hintText: 'Confirm Password',
                              //labelText: 'username',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.primarypurple, width: 1.5),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              errorStyle: TextStyle(
                                color: AppColors.peachpink,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.peachpink),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.peachpink, width: 2),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                              labelStyle: kLabelLightTextStyle,
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: AppColors.darkpurple),
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              password2 = value;
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      _message,
                      style: TextStyle(
                        color: AppColors.peachpink,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 60.0,
                            child: OutlinedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  if (!(await UserFxns.isUserNameUnique(
                                      username))) {
                                    showAlertDialog(
                                        "Error", "UserName is taken");
                                  } else if (password != password2) {
                                    showAlertDialog(
                                        "Error", "Passwords don't match");
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      // if all are valid then go to success screen
                                      //await signUpUser();
                                      //TODO: Try catch Userfxn signinnormal call show alert dialog with error. if no error push appropiate page
                                      try {
                                        await UserFxns.SignUpNormal(
                                            context,
                                            email,
                                            password,
                                            " ",
                                            fullname,
                                            username,
                                            DefaultProfilePicture);
                                        print("here");
                                        Navigator.pushNamed(
                                            context, '/signupfinish');
                                      } catch (e) {
                                        print("here2");
                                        showAlertDialog("Error", e.code);
                                      }
                                    }
                                  }
                                  //
                                  setState(() {
                                    attemptCount += 1;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Signing up')));
                                }
                              },
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(
                                  'Sign Up',
                                  style: kButtonDarkTextStyle,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                backgroundColor: AppColors.darkpurple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}