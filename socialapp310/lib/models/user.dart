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
  userPost: [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
  userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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
      userPost:  [],
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

