import 'package:socialapp310/models/location.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/utils.dart';


class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}


class User {
  final String username;
  final int userId;
  final String email; // types include liked photo, follow user, comment on photo
  final String imageUrlAvatar;
  final String fullname;
  final String bio;
  final bool isPrivate;
  final String password;
  final DateTime lastMessageTime;
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
    this.lastMessageTime,
    this.userPost,
    this.followers,
    this.followings,
    this.locations,
  });

   User copyWith({
     String username,
     int userId,
     String email, // types include liked photo, follow user, comment on photo
     String imageUrlAvatar,
     String fullname,
     String bio,
     bool isPrivate,
     String password,
     String lastMessageTime,
    List<dynamic> userPost,
    List<dynamic> followers,
    List<dynamic> followings,
    List<dynamic> locations,


   }) =>
      User(
        username: username ?? this.username,
        userId: userId ?? this.userId,
        email: email ?? this.email,
        imageUrlAvatar: imageUrlAvatar ?? this.imageUrlAvatar,
        fullname: fullname ?? this.fullname,
        bio: bio ?? this.bio,
        isPrivate: isPrivate ?? this.isPrivate,
        password: password ?? this.password,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );


  static User fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        userId: json['userId'],
        email: json['email'],
        imageUrlAvatar: json['imageUrlAvatar'],
        fullname: json['fullname'],
        bio: json['bio'],
        isPrivate: json['isPrivate'],
        password: json['password'],
    lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
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
    'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
  };

}

User profuser = User(
  username: "doggo",
  userId: 0,
  email: "doogo@gmail.com",
  imageUrlAvatar: "assets/Dog/cutegolden.jpg",
  fullname: "Generic Name",
  isPrivate: true,
  bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
  password: "12345678910",
  userPost: posts,
  followings: [
    User(
      username: "doggo0",
      userId: 0,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutegolden.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo1",
      userId: 1,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/dogmask.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 2,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo3",
      userId: 3,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/another.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo4",
      userId: 4,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cuteshiba.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 5,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 6,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 7,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
  ],
  followers: [
    User(
      username: "doggo0",
      userId: 0,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutegolden.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo1",
      userId: 1,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/dogmask.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 2,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo3",
      userId: 3,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/another.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo4",
      userId: 4,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cuteshiba.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo5",
      userId: 5,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/last.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
  ],
  locations: [
    location(
      loc_name: "Azerbaijan,Azerbaijan,AZ",
      latitude: 40.143105,
      longitude: 47.576927,
    ),
    location(
      loc_name: "Bosnia and Herzegovina,BA",
      latitude: 43.915886,
      longitude: 17.679076,
    ),
    location(
      loc_name: "Egypt,EG",
      latitude: 26.820553,
      longitude: 30.802498,
    ),
    location(
      loc_name: "Kadikoy,Istanbul",
      latitude: 40.988171,
      longitude: 29.029930,
    ),
    location(
      loc_name: "Atasehir,Istanbul",
      latitude: 40.982270,
      longitude: 29.108890,
    ),
    location(
      loc_name: "Besiktas,Istanbul",
      latitude: 41.043870,
      longitude: 29.012890,
    ),
    location(
      loc_name: "Kadikoy,Istanbul",
      latitude: 40.988171,
      longitude: 29.029930,
    ),
    location(
      loc_name: "Pendic,Istanbul",
      latitude: 40.870410,
      longitude: 29.272180,
    ),
    location(
      loc_name: "Karachi,Pakistan,PK",
      latitude: 30.375321,
      longitude: 69.345116,
    ),
    location(
      loc_name: "Islamabad,Pakistan,PK",
      latitude: 30.375321,
      longitude: 69.345116,
    ),
    location(
      loc_name: "Tuzla,Istnabul,Turkey,TR",
      latitude: 38.963745,
      longitude: 35.243322,
    ),
  ],
);
User secuser = User(
  username: "doggo1",
  userId: 8,
  email: "doogo@gmail.com",
  imageUrlAvatar: "assets/Dog/another.jpg",
  fullname: "Generic Name",
  isPrivate: true,
  bio:
  "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
  password: "12345678910",
  userPost: posts,
  followings: [
    User(
      username: "doggo0",
      userId: 0,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutegolden.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo1",
      userId: 1,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/dogmask.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 2,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo3",
      userId: 3,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/another.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo4",
      userId: 4,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cuteshiba.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 5,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 6,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 7,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
  ],
  followers: [
    User(
      username: "doggo0",
      userId: 0,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutegolden.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo1",
      userId: 1,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/dogmask.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo2",
      userId: 2,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cutepug.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo3",
      userId: 3,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/another.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo4",
      userId: 4,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/cuteshiba.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
    User(
      username: "doggo5",
      userId: 5,
      email: "doogo@gmail.com",
      imageUrlAvatar: "assets/Dog/last.jpg",
      fullname: "Generic Name",
      isPrivate: true,
      bio:
      "This is a generic sentence.This is a generic sentence.This is a generic sentence doggo bio.",
      password: "12345678910",
      userPost: posts,
    ),
  ],
  locations: [
    location(
      loc_name: "Azerbaijan,Azerbaijan,AZ",
      latitude: 40.143105,
      longitude: 47.576927,
    ),
    location(
      loc_name: "Bosnia and Herzegovina,BA",
      latitude: 43.915886,
      longitude: 17.679076,
    ),
    location(
      loc_name: "Egypt,EG",
      latitude: 26.820553,
      longitude: 30.802498,
    ),
    location(
      loc_name: "Kadikoy,Istanbul",
      latitude: 40.988171,
      longitude: 29.029930,
    ),
    location(
      loc_name: "Atasehir,Istanbul",
      latitude: 40.982270,
      longitude: 29.108890,
    ),
    location(
      loc_name: "Besiktas,Istanbul",
      latitude: 41.043870,
      longitude: 29.012890,
    ),
    location(
      loc_name: "Kadikoy,Istanbul",
      latitude: 40.988171,
      longitude: 29.029930,
    ),
    location(
      loc_name: "Pendic,Istanbul",
      latitude: 40.870410,
      longitude: 29.272180,
    ),
    location(
      loc_name: "Karachi,Pakistan,PK",
      latitude: 30.375321,
      longitude: 69.345116,
    ),
    location(
      loc_name: "Islamabad,Pakistan,PK",
      latitude: 30.375321,
      longitude: 69.345116,
    ),
    location(
      loc_name: "Tuzla,Istnabul,Turkey,TR",
      latitude: 38.963745,
      longitude: 35.243322,
    ),
  ],
);