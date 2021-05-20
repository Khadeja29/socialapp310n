import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/utils/dimension.dart';
import 'homefeed/HomeFeed.dart';

class SettingsUI extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: FinishSignupPageGoogle(),
    );
  }
}

class FinishSignupPageGoogle extends StatefulWidget {
  const FinishSignupPageGoogle({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _FinishSignupPageState createState() => _FinishSignupPageState();
}

class _FinishSignupPageState extends State<FinishSignupPageGoogle> {
  bool switchValue = false;
  String bio = "";
  String username;
  bool private = false;
  final _formKey = GlobalKey<FormState>();
  void onChangedSwitchValue(bool value) {
    setState(() {
      switchValue = value;
    });
  }
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Splash Page');
    print("SCS : Finished SignUp Page succeeded");
  }
  void initState() {
    super.initState();
    _setCurrentScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkpurple,
        elevation: 1,
        title: Center(
          child: Container(
            width: 280,
            child: Text(
              'Complete Sign Up',
              style: kAppBarTitleTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  "Add Profile Picture",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkpurple),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 230,
                        height: 230,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  "assets/images/blank_profile_picture.jpg",
                                ))),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: AppColors.lightgrey,
                        filled: true,
                        hintText: 'Username',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primarypurple,width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        errorStyle: TextStyle(
                          color: AppColors.peachpink,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.peachpink),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.peachpink,width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        //labelText: 'username',
                        labelStyle: kLabelLightTextStyle,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.darkpurple),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,

                      validator: (value) {
                        if(value.isEmpty) {
                          return 'Please enter your username';
                        }
                        if(value.length > 8) {
                          return 'Username has to be less than or equal to 8 characters';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        username = value;//TODO: make if username
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        fillColor: AppColors.lightgrey,
                        filled: true,
                        hintText: 'Bio',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primarypurple,width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        errorStyle: TextStyle(
                          color: AppColors.peachpink,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.peachpink),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.peachpink,width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        //labelText: 'username',
                        labelStyle: kLabelLightTextStyle,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.darkpurple),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      enableSuggestions: false,
                      autocorrect: false,

                      validator: (value) {
                        if(value.length > 50)
                        {
                          return 'Bio is more than 50 characters';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        bio = value;
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: private,
                      activeColor: AppColors.darkgrey,
                      onChanged: (value) {
                        setState(() {
                          private = value;
                        });
                      },
                    ),
                    Text("Make account private"),
                    Spacer()
                  ],
                ),

                /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    new SwitchListTile(
                      value: switchValue,
                      onChanged: onChangedSwitchValue,
                      activeColor: AppColors.darkpurple,
                      title: new Text('Make account private: ', style: new TextStyle(fontSize: 20.0),),
                    )
                ),*/

                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: 300,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        backgroundColor: AppColors.darkpurple,
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {

                          _formKey.currentState.save();
                          FirebaseAuth auth = FirebaseAuth.instance;
                          User currentUser = auth.currentUser;
                          await UserFxns.AddUserInfo(bio, currentUser.displayName, private, false, username);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/homefeed", (route) => false);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 30),
                        child: Text('Finish sign up',
                            style: TextStyle(
                                color: AppColors.lightgrey,
                                fontSize: 20.0,
                                letterSpacing: -0.7,
                                fontFamily: 'OpenSansCondensed-Light')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
