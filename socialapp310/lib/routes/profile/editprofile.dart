import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/routes/uploadpic/uploadpic.dart';
import 'profilepage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  String ProfilePic;
  File imageFile;
  int _pageIndex = 0;
  int _selectedIndex = 4;
  void imageuploader(){
    String imagename = DateTime.now().millisecondsSinceEpoch.toString();

    final Reference storageReference = FirebaseStorage.instance.ref()
        .child(imagename);
    final UploadTask uploadTask =  storageReference.putFile(imageFile);
    uploadTask.then((TaskSnapshot taskSnapshot) {

      taskSnapshot.ref.getDownloadURL().then((imageUrl){
        //save info to firestore

        setState(() {
          ProfilePic = imageUrl;
        });

        print(ProfilePic);

      });
    }).catchError((error){
      Fluttertoast.showToast(msg: error.toString(),);//TODO: remove this package
    });
  }
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {

        imageFile = File(pickedFile.path);
        imageuploader();
      });
    }
  }
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Profile Page');
    print("SCS : Edit Profile Page succeeded");

    ProfilePic = await UserFxns.getProfilePic();
    print(ProfilePic);
  }
  void initState() {
    super.initState();
    _listFuture = UserFxns.getUserInfo();

    //FirebaseCrashlytics.instance.crash(); //Emulating a crash
    _setCurrentScreen();
  }
  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;//TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, '/homefeed');
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, '/search');
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/notifications');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, '/profile');
      } //TODO: if index 3 push notif page, if index 4 push profile page
    });
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


  Future<DocumentSnapshot> _listFuture;


  final _formKey = GlobalKey<FormState>();
  String bio;
  String username;
  String fullname;
  bool priv = false;



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:_listFuture,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          bool private = snapshot.data["IsPrivate"];
          //print(data);
          return  Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.darkpurple,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

            ),
            body: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {_getFromGallery();},
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: Theme.of(context).scaffoldBackgroundColor),
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
                                        image: NetworkImage(
                                          ProfilePic,
                                        ))),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context).scaffoldBackgroundColor,
                                    ),
                                    color: AppColors.darkpurple,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      // buildTextFormField("Username", "@${snapshot.data["Username"]}", false),
                      // buildTextField("Full name","${snapshot.data["FullName"]}" , false),
                      // buildTextField("Bio","${snapshot.data["Bio"]}", false),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: TextFormField(
                          obscureText: false,
                          initialValue: "${snapshot.data["Username"]}",
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText:"Username",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if(value.isEmpty) {
                              return 'This field cannot be left empty';
                            }
                            if(value.length > 8) {
                              return 'Username must be less than or equal to 8 characters!';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            username = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: TextFormField(
                          obscureText: false,
                          initialValue: "${snapshot.data["FullName"]}",
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText:"Full Name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if(value.isEmpty) {
                              return 'This field cannot be left empty';
                            }
                            //TODO: Validate full name
                            // if(value.length > ) {
                            //   return 'Bio must be less than 50 characters!';
                            // }
                            return null;
                          },
                          onSaved: (String value) {
                            fullname = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 35.0),
                        child: TextFormField(
                          obscureText: false,
                          initialValue: "${snapshot.data["Bio"]}",
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            labelText:"Bio",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          validator: (value) {
                            if(value.isEmpty) {
                              return 'This field cannot be left empty';
                            }
                            if(value.length > 50) {
                              return 'Bio must be less than 50 characters!';
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            bio = value;
                          },
                        ),
                      ),

                      Row(
                        children: [
                          Checkbox(
                            value: priv ^ private ,
                            activeColor: AppColors.darkgrey,
                            onChanged: (value) {
                              setState(() {

                                priv = !priv;
                                print( priv ^ private);
                              });
                            },
                          ),
                          Text("Make account private"),

                        ],
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlineButton(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("CANCEL",
                                style: TextStyle(

                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black)),
                          ),
                          RaisedButton(
                            onPressed: () async{
                              if(_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                bool uniqueUser = await UserFxns.isUserNameUnique(username);
                                if(uniqueUser)
                                {
                                  UserFxns.UpdateProfilePic(ProfilePic);
                                  UserFxns.UpdateUserInfo( Bio:bio, FullName: fullname ,UserName:username, IsPriv: priv ^ private);
                                  Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
                                }
                                else{
                                  showAlertDialog("Error", "UserName is taken");
                                }

                              }

                            },
                            color: AppColors.darkpurple,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

          );

        }
        else {
          return (Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      AppColors.primarypurple))));

        }
        return Text("loading");
      },);


  }

  Widget buildTextFormField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
