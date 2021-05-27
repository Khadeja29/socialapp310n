import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:flutter/material.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/models/user1.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
import 'package:socialapp310/routes/profile/userList.dart';
import 'package:socialapp310/routes/welcome.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/models/Post1.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';

AppBar header(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? "FlutterShare" : titleText,
      style: TextStyle(
        color: Colors.white,
        fontFamily: isAppTitle ? "Signatra" : "",
        fontSize: isAppTitle ? 50.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: AppColors.darkpurple,//Theme.of(context).accentColor,
  );
}

buildPostHeader(String userId, String location)  {
  return FutureBuilder(
    future: usersRef.doc(userId).get(),
    builder: (context, docsnap) {
      if (!docsnap.hasData) {
        return Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    AppColors.primarypurple)));
      }
      Map<String, dynamic> data = docsnap.data.data();

      User currentUser = FirebaseAuth.instance.currentUser;
      bool isPostOwner = currentUser.uid == userId;
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data["ProfilePic"]),
          backgroundColor: Colors.grey,
        ),
        title: GestureDetector(
          onTap: () => {},//todo on tap of user profile image do something
          child: Text(
            data["Username"],
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text("Location goes here"),//todo convert location to string
        trailing: isPostOwner
            ? IconButton(
          onPressed: () => {},//todo delete post logic
          icon: Icon(Icons.more_vert),
        )
            : Text(''),
      );
    },
  );
}

buildPostImage(String imageURL) {
  return GestureDetector(
    onDoubleTap: (){},//to do, handle like here
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(//todo fix sizing issues
          padding:  EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image(
              fit: BoxFit.cover,
              image:
              NetworkImage(imageURL),
            ),
          ),
        ),
      ],
    ),
  );
}

buildPostFooter(String userId, String caption) {
  bool isLiked = false;
  return FutureBuilder(
    future: usersRef.doc(userId).get(),
    builder: (context, docsnap) {
      if (!docsnap.hasData) {
        return Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    AppColors.primarypurple)));
      }
      Map<String, dynamic> data = docsnap.data.data();
      return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            GestureDetector(
              onTap: (){}, //todo like handler
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,//todo how to get isliked(the map of user ids to bool values)
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () {},//todo push comment page
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "0 likes",//todo save number of likes in post
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "${data["Username"]}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Text(caption))
          ],
        ),
      ],
    );}
  );
}

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getpostRef
          .doc(postId)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      AppColors.primarypurple)));
        }
        Post1 post = Post1(
            caption: snapshot.data["Caption"],
            imageURL: snapshot.data["Image"],
            likes: snapshot.data["Likes"],
            createdAt: snapshot.data["createdAt"],
            isPrivate: snapshot.data["IsPrivate"],
            location: snapshot.data["Location"],
            UserID: userId,
            PostID: postId
        );

        return Center(
          child: Scaffold(
            appBar: header(context, titleText: post.caption),
            body: ListView(
              children: [
                buildPostHeader(userId, "Some String"),
                buildPostImage(post.imageURL),
                buildPostFooter(userId, post.caption)
              ],
            ),
          ),
        );
      },
    );
  }
}