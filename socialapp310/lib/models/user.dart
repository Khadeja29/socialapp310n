import 'package:socialapp310/models/location.dart';
import 'package:socialapp310/models/post.dart';


class User {
  final String username;
  final int userId;
  final String email; // types include liked photo, follow user, comment on photo
  final String imageUrlAvatar;
  final String fullname;
  final String bio;
  final bool isPrivate;
  final String password;
  List<dynamic> userPost;
  List<dynamic> followers;
  List<dynamic> followings;
  List<dynamic> locations;

  User({
    this.username,
    this.userId,
    this.email, // types include liked photo, follow user, comment on photo
    this.imageUrlAvatar,
    this.fullname,
    this.isPrivate,
    this.bio,
    this.password,
    this.userPost,
    this.followers,
    this.followings,
    this.locations,
  });

  User.fromData(Map<String, dynamic> data)
      : username= data['username'],
  userId = data['userId'],
  email= data['email'],
  imageUrlAvatar= data['imageUrlAvatar'],
  fullname= data['fullname'],
  bio= data['bio'],
  isPrivate=data['isPrivate'],
  password= data['password'];

  static User fromMap(Map<String, dynamic> map) => User(
    username: map['username'],
    userId: map['userId'],
    email: map['email'],
    imageUrlAvatar: map['imageUrlAvatar'],
    fullname: map['fullname'],
    bio: map['bio'],
    isPrivate: map['isPrivate'],
    password: map['password'],

  );


  Map<String, dynamic> toJson() => {
    'username': username,
    'userId': userId,
    'email': email,
    'imageUrlAvatar': imageUrlAvatar,
    'fullname': fullname,
    'bio': bio,
    'isPrivate': isPrivate,
    'password': password,

  };
}




