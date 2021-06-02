import 'package:cloud_firestore/cloud_firestore.dart';

class Post1 {
  final String caption;
  final String imageURL;
  final bool isPrivate;
  final int likes;
  final GeoPoint location;
  final String locationName;
  final Timestamp createdAt;
  Map<String,dynamic> LikesMap;
  final String PostID;
  final String UserID;

  Post1({
    this.caption,
    this.locationName,
    this.imageURL,
    this.likes,
    this.createdAt,
    this.LikesMap,
    this.isPrivate,
    this.location,
    this.PostID,
    this.UserID
  });
}
