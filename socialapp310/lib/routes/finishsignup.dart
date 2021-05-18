import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
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
      home: FinishSignupPage(),
    );
  }
}

class FinishSignupPage extends StatefulWidget {
  const FinishSignupPage({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _FinishSignupPageState createState() => _FinishSignupPageState();
}

class _FinishSignupPageState extends State<FinishSignupPage> {
  bool switchValue = false;
  String bio = "";
  bool private = false;

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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.lightgrey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          width: 280,
          child: Text(
            'Complete Sign Up',
            style: kAppBarTitleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
                padding: const EdgeInsets.all(15.0),
                child: Expanded(
                  flex: 1,
                  child: TextFormField(
                    decoration: InputDecoration(
                      fillColor: AppColors.lightgrey,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 40.0),
                      filled: true,
                      hintText: 'Enter your bio here',
                      //labelText: 'username',
                      labelStyle: kLabelLightTextStyle,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.darkpurple),
                        borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    enableSuggestions: false,
                    autocorrect: false,
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
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil("/homefeed", (route) => false);
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
    );
  }
}
