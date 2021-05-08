

import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
                    ],
                  )
                ],
              )

          )
      ),
    );
  }
}