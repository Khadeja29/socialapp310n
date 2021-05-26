import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
//import 'package:socialapp310/models/comment_model.dart';
import 'package:socialapp310/models/user1.dart';
import 'package:socialapp310/routes/profile/PostScreen.dart';
import 'package:socialapp310/services/UserFxns.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_auth/firebase_auth.dart' as FBauth;

final commentsRef = FirebaseFirestore.instance.collection('comments');
final usersRef = FirebaseFirestore.instance.collection('user');
final DateTime timestamp = DateTime.now();

FBauth.User curUser =  FBauth.FirebaseAuth.instance.currentUser;

class Comments extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  //final String postMediaUrl;
  const Comments({Key key, this.analytics, this.observer,    this.postId, this.postOwnerId,}): super (key: key);

  @override
  CommentsState createState() => CommentsState(
    postId: this.postId,
    postOwnerId: this.postOwnerId,
    //postMediaUrl: this.postMediaUrl,
  );
}

class CommentsState extends State<Comments> {
  User1 currentUser;
  String usrName;
  Future<DocumentSnapshot> userInfo;
  TextEditingController commentController = TextEditingController();
  final String postId; //= "mrPZJQzUriOlYb6ZLdjX"
  final String postOwnerId;
  //final String postMediaUrl;
  Future<QuerySnapshot> searchResultsFuture;

  CommentsState({
    this.postId,
    this.postOwnerId,
   // this.postMediaUrl,
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

  getUserInfo() {
    Future<QuerySnapshot> user = usersRef
        .where("email", isEqualTo: curUser.email)
        .get();
    setState(() {
      searchResultsFuture = user;
    });
    return searchResultsFuture;
  }

   userInfoo(){
    //getUserInfo();
    return FutureBuilder(
        future: userInfo,//getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(
                'There was an error :('
            );
          }
          else if (snapshot.hasData) {
            print("ahdjghaskdj");
            usrName = snapshot.data["Username"];
            List<User1> searchResults = [];
            snapshot.data.docs.forEach((doc) {
              User1 user2 = User1(
                  UID: doc.id,
                  username: doc['Username'],
                  email: doc['Email'],
                  fullName: doc['FullName'],
                  isPrivate: doc['IsPrivate'],
                  isDeactivated: doc['isDeactivated'],
                  bio: doc['Bio'],
                  ProfilePic: doc['ProfilePic']);
              if(user2.email != curUser.email){
                searchResults.add(user2);
                currentUser = user2;
              }else{
                print(user2.email);
              }
            });
            //currentUser = searchResults[0];
            print(currentUser.username);
            return Text("success");
          }else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(child: CircularProgressIndicator(),
                  height: 20,
                  width: 20,),
              ],
            );
          }
        }
    );
  }

  Widget buildComment(Comment comment) {
    if (comment.avatarUrl != null) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: ListTile(
                tileColor: AppColors.peachpink,
                leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(comment.avatarUrl)
                ),
                
                title: Text(comment.comment),
                subtitle: Text("by "+comment.username + " - "+ timeago.format(comment.timestamp.toDate()),
                //subtitle: Text("by "+comment.username + " - "+ timeago.format(comment.timestamp.toDate()),
                ),
          ),
            ),
        ),
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
          print(snapshot.data.docs);
          List<Comment> comments = [];
          snapshot.data.docs.forEach((doc) {
            comments.add(Comment.fromDocument(doc));
          });
          //print("Com here"+postId);
          //print(comments.length);
          return ListView.builder(
            itemCount: comments.length,
            // ignore: missing_return
            itemBuilder: (context, index) {
              //final choiceIdx = choice.index;
              if (comments[index]
                  .username != null) {
                //final product = searchResults[index];
                return buildComment(comments[index]);
                  // buildProductUser(product);
              } //else
                //return Text("success");
            },
          );
        });
  }

  addComment() async {
    String prf =  await UserFxns.getProfilePic();
    userInfo = UserFxns.getUserInfo();
    userInfoo();
  //print(currentUser.username);
     commentsRef.doc(postId).collection("postComments").add({
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": prf,
      "userId": curUser.uid,
      "username": usrName,
    });
    /*bool isNotPostOwner = postOwnerId != currentUser.uid;
    if (isNotPostOwner) {
      activityFeedRef.doc(postOwnerId).collection('feedItems').add({
        "type": "comment",
        "commentData": commentController.text,
        "timestamp": timestamp,
        "postId": postId,
        "userId": currentUser.uid,
        "username": currentUser.username,
        "userProfileImg": currentUser.photoUrl,
        "mediaUrl": postMediaUrl,
      });
    }*/
    commentController.clear();
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex =
          index; //TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, '/homefeed');
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, '/search');
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacementNamed(context, '/uploadpic');
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/notifications');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, '/profile');
      } //TODO: if index 3 push notif page, if index 4 push profile page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Comments", ),
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
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: AppColors.darkpurple,
        selectedItemColor: AppColors.peachpink,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: "Notifications"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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