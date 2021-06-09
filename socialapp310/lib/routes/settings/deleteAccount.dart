import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/utils/dimension.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;

import '../welcome.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key key, this.analytics, this.observer})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool remember = false;
  bool validuser = false;
  bool validpassword = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Delete Account Page');
    print("SCS : Delete Account Page succeeded");
  }

  void initState() {
    super.initState();
    _setCurrentScreen();
  }

  Future<void> deleteUserAccount() async {
    FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;


    EmailAuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('user');

    try {
      // await currentFB.reauthenticateWithCredential(credential).then((value) {
      //   FirebaseAuth.instance.currentUser.delete().then((val) {
      //     usersCollection.doc(currentFB.uid).delete().then((res) {
      //       ScaffoldMessenger.of(context)
      //           .showSnackBar(SnackBar(content: Text('Deleting account!')));
      //       // Navigator.pushReplacementNamed(context, '/welcome');
      //     });
      //   });
      // });
    if(!currentFB.emailVerified)
    {
      await currentFB.reauthenticateWithCredential(credential).then((value) {
        FirebaseAuth.instance.currentUser.delete().then((res) {
          usersCollection.doc(currentFB.uid).delete().then((res) {
            FirebaseFirestore.instance.collection('FollowRequests').doc(currentFB.uid).collection('requests').get().then((res) async {
              for (var x in res.docs){
                x.reference.delete();
              }
              FirebaseFirestore.instance.collection('feed').doc(currentFB.uid).collection('feedItems').get().then((res)async{
                //TODO: consider feeds of other users. prob you will have to manually iterate through everything.

                for (var x in res.docs){
                  x.reference.delete();
                }
                FirebaseFirestore.instance.collection('followers').doc(currentFB.uid).collection('userFollowers').get().then((res)async{
                  //delete following of others
                  for (var x in res.docs){
                    await FirebaseFirestore.instance.collection('following').doc(x.id).collection('userFollowing').doc(currentFB.uid).delete();
                    x.reference.delete();
                  }
                  FirebaseFirestore.instance.collection('following').doc(currentFB.uid).collection('userFollowing').get().then((res)async{
                    //delete followers of others

                    for (var x in res.docs){
                      await FirebaseFirestore.instance.collection('followers').doc(x.id).collection('userFollowers').doc(currentFB.uid).delete();
                      x.reference.delete();
                    }
                    FirebaseFirestore.instance.collection('Post').where("PostUser", isEqualTo: currentFB.uid).get().then((res) async{
                      for (var x in res.docs){
                        x.reference.delete();
                      }
                      FirebaseFirestore.instance.collection('subbedLocations').where("UserId", isEqualTo: currentFB.uid).get().then((res) async {
                        for (var x in res.docs){
                          x.reference.delete();
                        }
                        FirebaseFirestore.instance.collection('Favorites').where("UserId", isEqualTo: currentFB.uid).get().then((res){
                          for (var x in res.docs){
                            x.reference.delete();
                          }
                          FirebaseFirestore.instance.collection('comments').doc().collection('postComments').where("UserId", isEqualTo: currentFB.uid).get().then((res){
                            for (var x in res.docs){
                              x.reference.delete();
                            }
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('Deleting account!')));
                            // Navigator.pushReplacementNamed(context, '/welcome');
                          })
                          ;
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    }
    else{
      await FirebaseAuth.instance.currentUser.delete().then((res) {
        usersCollection.doc(currentFB.uid).delete().then((res) {
          FirebaseFirestore.instance.collection('FollowRequests').doc(currentFB.uid).collection('requests').get().then((res) async {
            for (var x in res.docs){
              x.reference.delete();
            }
            FirebaseFirestore.instance.collection('feed').doc(currentFB.uid).collection('feedItems').get().then((res)async{
              //TODO: consider feeds of other users. prob you will have to manually iterate through everything.

              for (var x in res.docs){
                x.reference.delete();
              }
              FirebaseFirestore.instance.collection('followers').doc(currentFB.uid).collection('userFollowers').get().then((res)async{
                //delete following of others
                for (var x in res.docs){
                  await FirebaseFirestore.instance.collection('following').doc(x.id).collection('userFollowing').doc(currentFB.uid).delete();
                  x.reference.delete();
                }
                FirebaseFirestore.instance.collection('following').doc(currentFB.uid).collection('userFollowing').get().then((res)async{
                  //delete followers of others

                  for (var x in res.docs){
                    await FirebaseFirestore.instance.collection('followers').doc(x.id).collection('userFollowers').doc(currentFB.uid).delete();
                    x.reference.delete();
                  }
                  FirebaseFirestore.instance.collection('Post').where("PostUser", isEqualTo: currentFB.uid).get().then((res) async{
                    for (var x in res.docs){
                      x.reference.delete();
                    }
                    FirebaseFirestore.instance.collection('subbedLocations').where("UserId", isEqualTo: currentFB.uid).get().then((res) async {
                      for (var x in res.docs){
                        x.reference.delete();
                      }
                      FirebaseFirestore.instance.collection('Favorites').where("UserId", isEqualTo: currentFB.uid).get().then((res){
                        for (var x in res.docs){
                          x.reference.delete();
                        }
                        FirebaseFirestore.instance.collection('comments').doc().collection('postComments').where("UserId", isEqualTo: currentFB.uid).get().then((res){
                          for (var x in res.docs){
                            x.reference.delete();
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Deleting account!')));
                          // Navigator.pushReplacementNamed(context, '/welcome');
                        })
                        ;
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    }


    await Authentication.signOutWithGoogle(context: context);
    FBauth.FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacementNamed(context, '/welcome');
    });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
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
            'Delete Account',
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
                  child: Image.asset('assets/images/mobile_login.png',
                      width: 300, height: 300),
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
                                    return 'Please enter your e-mail';
                                  }
                                  if (!EmailValidator.validate(value)) {
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
                                  fillColor: AppColors.lightgrey,
                                  filled: true,
                                  hintText: 'Password',
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
                                      color: Colors.grey.withOpacity(0.5),
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
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;
                                        if(currentFB.emailVerified)
                                        {
                                          await deleteUserAccount();
                                        }
                                        else {
                                          await deleteUserAccount();
                                          if (validpassword && validuser) {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                "/homefeed",
                                                    (Route<dynamic> route) =>
                                                false);
                                          } else if (!validuser) {
                                            showAlertDialog(
                                                "Error", "User Does not exist");
                                          } else if (!validpassword) {
                                            showAlertDialog(
                                                "Error", "Password is wrong");
                                          }
                                        }


                                      }
                                    },
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
      ),
    );
    // );
  }
}
