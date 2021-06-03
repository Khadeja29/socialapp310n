import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart' as FBauth;

final commentsRef = FirebaseFirestore.instance.collection('comments');
final usersRef = FirebaseFirestore.instance.collection('user');

FBauth.User curUser =  FBauth.FirebaseAuth.instance.currentUser;

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final String postMediaUrl;
  const Comments({Key key, this.analytics, this.observer, this.postMediaUrl,this.postId, this.postOwnerId,}): super (key: key);

  @override
  CommentsState createState() => CommentsState(
    postId: this.postId,
    postOwnerId: this.postOwnerId,
    postMediaUrl: this.postMediaUrl,
  );
}

class CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();
  final String postId; //= "mrPZJQzUriOlYb6ZLdjX"
  final String postOwnerId;
  final String postMediaUrl;
  Future<QuerySnapshot> searchResultsFuture;

  CommentsState({
    this.postId,
    this.postOwnerId,
    this.postMediaUrl,
  });


  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Comments Page');
    _setLogEvent();
    print("SCS : Comments Page succeeded");
  }

  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Comments_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Comments Page',
        }
    );
  }

  Widget buildComment(Comment comment) {
    if (comment.avatarUrl != null) {
      return Column(
        children: <Widget> [
          Container(
            margin: const EdgeInsets.only(top: 3.0,bottom: 3.0),
            decoration: new BoxDecoration(
              color: AppColors.lightgrey,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            height: 60,
            child: ListTile(
              contentPadding:  const EdgeInsets.only(left: 5, bottom: 5),
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 60,
                  minHeight: 40,
                  maxWidth: 80,
                  maxHeight: 50,
                ),
                child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(comment.avatarUrl)
                ),
              ),
              title: Text(comment.comment, style: TextStyle(fontSize: 14)),
              subtitle: Text("by "+comment.username + " - "+ timeago.format(comment.timestamp.toDate()),
                //subtitle: Text("by "+comment.username + " - "+ timeago.format(comment.timestamp.toDate()),
              ),
            ),
          ),
          //Divider(),
        ],
      );

    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading:
          Image(
            image: AssetImage('assets/images/logo_woof.png'),
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
          title: Text(comment.username),
          subtitle:Text(comment.username + " "+ timeago.format(comment.timestamp.toDate())),
        ),
      );
    }
  }

  buildComments() {
    return StreamBuilder(
        stream: commentsRef
            .doc(postId)
            .collection('postComments')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,),
              ],
            );
          }
          List<Comment> comments = [];
          snapshot.data.docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          return ListView.builder(
            itemCount: comments.length,
            // ignore: missing_return
            itemBuilder: (context, index) {
              //final choiceIdx = choice.index;
              if (comments[index]
                  .username != null) {
                final product = comments[index];
                return buildComment(product);
                // buildProductUser(product);
              } //else
              //return Text("success");
            },
          );
        });
  }

  addComment() async {
    final DateTime timestamp = DateTime.now();
    String prf =  await UserFxns.getProfilePic();
    String usrName = await UserFxns.getUserName();


    commentsRef.doc(postId).collection("postComments").add({
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": prf,
      "userId": curUser.uid,
      "username": usrName,
    });
    bool isNotPostOwner = postOwnerId != curUser.uid;
    if (isNotPostOwner) {
      activityFeedRef.doc(postOwnerId).collection('feedItems').add({
        "type": "comment",
        "ownerId": postOwnerId,
        "commentData": commentController.text,
        "timestamp": timestamp,
        "PostID": postId,
        "userId": curUser.uid,
      });
    }
    commentController.clear();
  }
  AppBar header(context, {bool isAppTitle = false, String titleText, removeBackButton = false}) {
    return AppBar(
      leading: GestureDetector(
        onTap: (){
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back,
          size: 28,
        ),
      ),
      automaticallyImplyLeading: removeBackButton ? false : true,
      title: Text(
        isAppTitle ? "FlutterShare" : "@$titleText",
        style: TextStyle(
          color: Colors.white,
          fontFamily: isAppTitle ? "Signatra" : "",
          fontSize: isAppTitle ? 22.0 : 22.0,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      backgroundColor: AppColors.darkpurple,
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Comments", removeBackButton: true),
      body: Column(
        children: <Widget>[
          Expanded(
              child: buildComments()
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Write a comment...", labelStyle: kTitle),
            ),
            // ignore: deprecated_member_use
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("Post", style: kTitle),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}