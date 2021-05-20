import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFxns{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CollectionReference usersCollection = FirebaseFirestore.instance.collection('user');

  static Future<bool> isUserNameUnique(String Username) async{

    bool unique = true;
    print(Username);
    var result = await FirebaseFirestore.instance
        .collection('user')
        .where('Username', isEqualTo: Username)
        .get();

    if(result.docs.isNotEmpty)
    {unique = false;}
    // result.docs.forEach((doc) {
    //   print("it works");
    //   print(doc["Username"]);
    //   if(doc["Username"] == Username)
    //   {
    //     unique = false;
    //   }
    // });
    print("here ${unique}");
    return unique;
  }

  static Future<bool> UserExistsinFireStore(String uid) async{

    print(uid);
    var result = await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get();

    return result.exists;
  }
  static Future<void> SignUpNormal(BuildContext context, String email,String password,String Bio, String FullName,
      String Username ) async {
    var isNewUser = false;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      isNewUser = userCredential.additionalUserInfo.isNewUser;
    } on FirebaseAuthException catch (e) {
      if(e.code == 'email-already-in-use') {
        throw(e);
      }
      else if(e.code == 'weak-password') {
        throw(e);
      }
      else{
        throw(e);
      }
    }
    if(isNewUser) {
      AddUserInfo(Bio, FullName, false, false, Username);
    }
    else {}//do nothing
    //TODO: push Home page here
    //TODO: in the else change deactivated to true. for sign in and not here
  }
  static Future<void> UpdateBio(String Bio) async {
    User currentUser = _auth.currentUser;
    var result = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .update({'Bio': Bio})
        .then((value) => print("Success"))
        .catchError((error) => print("Error: $error"));
  }
  static Future<void> UpdateUsername(String username) async {
    User currentUser = _auth.currentUser;
    var result = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .update({'Username': username})
        .then((value) => print("Success"))
        .catchError((error) => print("Error: $error"));
  }

  static Future<void> UpdatePrivacy(bool Privacy) async{
    User currentUser = _auth.currentUser;
    var result = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .update({'IsPrivate': Privacy})
        .then((value) => print("Success"))
        .catchError((error) => print("Error: $error"));
  }

  static Future<void> UpdateDeactivation(bool deactivated) async{
    User currentUser = _auth.currentUser;
    var result = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUser.uid)
        .update({'isDeactivated': deactivated})
        .then((value) => print("Success"))
        .catchError((error) => print("Error: $error"));
  }
  static Future<void> loginUser(email, password) async {
    try {
      print(email);
      print(password);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );



    } on FirebaseAuthException catch (e) {
      print(e.toString());
      if(e.code == 'user-not-found') {
        throw(e);
      }
      else if (e.code == 'wrong-password') {
        throw(e);
      }
      else { throw(e);}
    }
  }
  static Future<void> AddUserInfo(String Bio, String FullName, bool isPrivate, bool isDeactivated,String Username) async {
    User currentUser = _auth.currentUser;
    usersCollection
        .doc(currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
      } else {
        usersCollection
            .doc(currentUser.uid)
            .set({
          "Bio": Bio,
          "FullName": FullName,
          "IsPrivate": isPrivate,
          "Username": Username,
          "Email": currentUser.email,
          "isDeactivated" : isDeactivated
        })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }
}