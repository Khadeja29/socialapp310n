import 'package:cloud_firestore/cloud_firestore.dart';

class User1 {
  final String username;
  final String email;
  final String fullName;
  final String bio;
  final String ProfilePic;
  final bool isPrivate,  isDeactivated;

  User1({
    this.username,
    this.email,
    this.fullName,
    this.isPrivate,
    this.bio,
    this.ProfilePic,
    this.isDeactivated,
  });

  factory User1.fromDocument(DocumentSnapshot doc) {
    return User1(
      username: doc['Username'],
      email: doc['Email'],
      fullName: doc['FullName'],
      isPrivate: doc['isPrivate'],
      isDeactivated: doc['isDeactivated'],
      bio: doc['Bio'],
      ProfilePic: doc['ProfilePic'],
    );
  }
}
