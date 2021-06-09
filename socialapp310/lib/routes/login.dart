import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/utils/dimension.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';

class Login extends StatefulWidget {
  const Login({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Log in Page');
    _setLogEvent();
    print("SCS : Log in Page succeeded");
  }
  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Login_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Log in Page',
        }
    );
  }
  void initState() {
    super.initState();
    _setCurrentScreen();
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
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        print('G');
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Sign In',
            style: kAppBarTitleTextStyle,
          ),
          backgroundColor: AppColors.darkpurple,
          centerTitle: true,
          // elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimen.regularPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.asset('assets/images/mobile_login.png', width: 300 , height: 300),
                ),
                // Spacer(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(

                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: AppColors.lightgrey,
                                  filled: true,
                                  hintText: 'E-mail',
                                  // labelText: 'Username',
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
                                  labelStyle: kLabelLightTextStyle,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.darkgreyblack),
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,

                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'Please enter your e-mail';
                                  }
                                  if(!EmailValidator.validate(value)) {
                                    return 'The e-mail address is not valid';
                                  }
                                  email = value;
                                  return null;
                                },
                                // onSaved: (input) => loginRequestModel.email = input,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.0,),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  fillColor: AppColors.lightgrey,
                                  filled: true,
                                  hintText: 'Password',
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

                                  //labelText: 'Username',
                                  labelStyle: kLabelLightTextStyle,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: AppColors.darkpurple),
                                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,

                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if(value.length < 8) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  print("here" + value);
                                  password = value;
                                  return null;
                                },
                                // onSaved: (input) => loginRequestModel.password = input,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40),
                                      bottomLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40)
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: AppColors.primarypurple,
                                    ),
                                    onPressed: () async {
                                      if(_formKey.currentState.validate()) {
                                        try {
                                          await UserFxns.loginUser(email, password);
                                          await UserFxns.UpdateDeactivation(false);
                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                              "/homefeed", (
                                              Route<dynamic> route) => false);
                                        } catch (e)
                                        {
                                          showAlertDialog("Error", e.code);
                                        }

                                      }
                                    }
                                    ,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Text(
                                        'Login',
                                        style: kButtonDarkTextStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),

                      SizedBox(height: 15,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, "/signup"),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.darkgrey),
                            ),
                          ),
                        ],
                      )


                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
    // );
  }
}