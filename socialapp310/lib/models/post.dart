import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp310/models/location.dart';

class Post {
  String userId;
  String PostID;
  String username;
  String ImageUrlPost;
  String caption;
  int likes;
  bool IsPrivate;
  dynamic comment;
  dynamic location;
  dynamic createdAt;

  Post(
      {this.username,
        this.userId,
        this.ImageUrlPost,
        this.PostID,
        this.caption,
        this.likes,
        this.comment,
        this.location,
        this.createdAt,
      this.IsPrivate,});
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      userId: doc['PostUser'],
      ImageUrlPost: doc['Image'],
      caption: doc['Caption'],
      likes: doc['Likes'],
      comment: doc['Comment'],
      location: doc['Location'],
      createdAt: doc['createdAt'],
      IsPrivate: doc['IsPrivate'],
    );
  }
}



/*
Post post = Post(
    username: "Generic Name",
    loc: x,
    likes: 100,
    ImageUrlAvatar: "assets/Dog/cutegolden.jpg",
    reposts: 20,
    ImageUrlPost: "assets/Dog/index.jpg",
    caption:
        "This is a generic sentence.This is a generic sentence.This is a generic sentence.",
    date: "April 17 2021",
    comments: 100);
List<Post> posts = [
  Post(
      username: "Another",
      loc: x,
      likes: 15,
      ImageUrlAvatar: "assets/Dog/another.jpg",
      reposts: 20,
      ImageUrlPost: "assets/Dog/scenicgolden.jpg",
      caption:
          "Cap",
      date: "April 17 2021",
      comments: 20),
  Post(
      username: "Generic Name",
      loc: x,
      likes: 100,
      ImageUrlAvatar: "assets/Dog/last.jpg",
      reposts: 58,
      ImageUrlPost: "assets/Dog/doglifting.png",
      caption:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence.",
      date: "April 17 2021",
      comments: 30),
  Post(
      username: "Generic Name",
      loc: x,
      likes: 235,
      ImageUrlAvatar: "assets/Dog/cutegolden.jpg",
      reposts: 62,
      ImageUrlPost: "assets/Dog/dogmask.jpg",
      caption:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence.",
      date: "April 17 2021",
      comments: 100),
  Post(
      username: "Generic Name",
      loc: x,
      likes: 1880,
      ImageUrlAvatar: "assets/Dog/cuteshiba.png",
      reposts: 108,
      ImageUrlPost: "assets/Dog/hungrydog.jpg",
      caption:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence.",
      date: "April 17 2021",
      comments: 2),
  Post(
      username: "Generic Name",
      loc: x,
      likes: 10000,
      ImageUrlAvatar: "assets/Dog/cutepug.jpg",
      reposts: 50,
      ImageUrlPost: "assets/Dog/husky.jpg",
      caption:
          "This is a generic sentence.This is a generic sentence.This is a generic sentence.",
      date: "April 17 2021",
      comments: 0)
];
*/