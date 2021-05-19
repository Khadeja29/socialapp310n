import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/dimension.dart';
import 'package:socialapp310/utils/styles.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: Dimen.regularPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                                prefixIcon: Icon(Icons.lock_outlined, color: AppColors.primarypurple),
                                fillColor: AppColors.lightgrey,
                                filled: true,
                                hintText: 'Password',
                                // labelText: 'Username',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primarypurple,
                                      width: 1.5),
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
                                  borderSide: BorderSide(
                                      color: AppColors.darkgreyblack),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your password!';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
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
                          child: Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outlined, color: AppColors.primarypurple),
                                fillColor: AppColors.lightgrey,
                                filled: true,
                                hintText: 'Confirm Password',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primarypurple,
                                      width: 1.5),
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

                                //labelText: 'Username',
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
                              // onSaved: (input) => loginRequestModel.password = input,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
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
                                    bottomRight: Radius.circular(40)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: AppColors.primarypurple,
                                  ),
                                  onPressed: () async {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
                                    child: Text(
                                      'Confirm',
                                      style: kButtonDarkTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            )),
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
