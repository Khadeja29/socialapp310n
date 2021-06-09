import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/models/user1.dart';
import 'package:socialapp310/routes/comment/comments.dart';
import 'package:socialapp310/routes/favourites/favourites.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';
import 'package:socialapp310/routes/uploadpic/editpost.dart';

import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/models/Post1.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:timeago/timeago.dart' as timeago;

final usersRef = FirebaseFirestore.instance.collection('user');
final commentsRef = FirebaseFirestore.instance.collection('comments');

class PostScreen extends StatefulWidget {
  final String userId;
  final String postId;
  final int index;

  PostScreen({this.userId, this.postId,this.index});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  User currentUser = FirebaseAuth.instance.currentUser;
  var _locationString = "Something Else";
  String Username = "";
  String userProfileImg = "";
  String _gotLoggedinUsername;
  bool isLiked = false;
  int likeCount = 0;
  Map<String,dynamic> _Likesmap;
  bool _Bookmarked = false;
  bool _isFlagged = false;
  int commentLen = 0;
  final animatorKeyLike = AnimatorKey<double>();
  final animatorKeyLike2 = AnimatorKey<double>();
  final animatorKeyBookmark = AnimatorKey<double>();

  AppBar header(context, {bool isAppTitle = false, String titleText, removeBackButton = false}) {
    return AppBar(
      leading: GestureDetector(
        onTap: (){
          if(widget.index == 100)
          {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) => Favourites()), (route) => route.isFirst);
          }
          else if(widget.index == 101)
          {
            Navigator.pop(context) ;
          }
          else if(widget.userId != currentUser.uid)
          {
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(analytics: AppBase.analytics,
                        observer: AppBase.observer,
                        index: widget.index,
                        UID: (widget.userId== currentUser.uid)?null : widget.userId )
            ),
                    (route) => route.isFirst);
          }
          else {
            Navigator.pushAndRemoveUntil(context,MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(analytics: AppBase.analytics,
                        observer: AppBase.observer,
                        index: widget.index,
                        UID: (widget.userId== currentUser.uid)?null : widget.userId )
            ),
                    (route) => false);
          }
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

  buildCommentLength() {
    return StreamBuilder(
        stream: commentsRef
            .doc(widget.postId)
            .collection('postComments')
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
          commentLen = 0;
          snapshot.data.docs.forEach((doc) {
            commentLen+=1;
          });
          return Padding(
            padding: const EdgeInsets.fromLTRB(15,0,0,0),
            child: Text(commentLen.toString() + " comments",
              style: TextStyle(
                  color: AppColors.darkgreyblack,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0,
                  fontFamily: 'OpenSansCondensed-Bold'),
            ),
          );
        });
  }

  buildPostHeader(String userId ,String imageURL)  {
    return FutureBuilder(
      future: _listFuture2,
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
          leading: Container(
            width: 50,
            height: 60,
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["ProfilePic"]),
              backgroundColor: Colors.grey,
            ),
          ),
          title: GestureDetector(
            onTap: () => {},//TODO: on tap of username do something
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 2, 0, 6),
              child: Text(
                data["Username"],
                style: TextStyle(
                  color: AppColors.darkpurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 18,
              ),
              SizedBox(width: 2),
              Expanded(
                child: Text(
                  "$_locationString",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.4,
                      fontFamily: 'OpenSansCondensed-Bold'
                  ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          trailing: isPostOwner
              ? DropdownButton<String>(
            elevation: 0,
            iconSize: 25,
            icon:Icon(
              Icons.more_vert,
              color: Colors.blueGrey,
            ),
            items: <String>['Edit', 'Delete'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child:  Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (value == "Edit")
              {
                //TODO: Edit post
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) =>  editpost(imageUrl: imageURL,postId: widget.postId,),
                ),);
              }
              else if (value == "Delete")
              {
                handleDeletePost(context);
              }

            },
          )
              : Text(''),

        );
      },
    );
  }
  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () async {

                    await deletePost();

                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(analytics: AppBase.analytics,
                              observer: AppBase.observer,)
                    ),
                            (route) => route.isFirst);
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }
  deletePost() async {
    // delete post itself
    getpostRef
        .doc(widget.postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }

    });
    // delete uploaded image for thep ost
    // TODO:then delete all activity feed notifications
    var toDelete =  await activityFeedRef
        .doc(widget.userId)
        .collection('feedItems')
        .where('PostID', isEqualTo: widget.postId)
        .get();
    for(var notif in toDelete.docs)
    {
      activityFeedRef
          .doc(widget.userId)
          .collection('feedItems')
          .doc(notif.id)
          .delete();
    }
    // TODO:then delete all comments

  }

  buildPostImage(String imageURL) {
    return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return DetailScreenLink(
                  ImageUrlPost: imageURL,
                );
              }));
            },
            onDoubleTap: (){handleLikePost(widget.userId);},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8,5,5,8),
              child: Container(
                height: (MediaQuery.of(context).size.width)-70,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageURL),
                    fit: BoxFit.cover  ,
                  ),
                ),
              ),
            ),
          ),
          Animator<double>(
            tween: Tween<double>(begin: 0, end: 200),
            cycles: 2,
            animatorKey: animatorKeyLike2,
            triggerOnInit: false,
            duration: Duration(milliseconds: 500),
            curve: Curves.bounceIn,

            builder: (context, animatorState, child ) => Center(
                child:  isLiked ? Icon(
                  Icons.favorite,
                  color: Colors.pink.withOpacity(0.7),
                  size: animatorState.value,)
                    : Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.pink,
                  size:animatorState.value,
                )
            ),
          ),

        ]
    );
  }

  buildPostFooter(String userId, String caption, int likes , String imageURL, String time) {
    return FutureBuilder(
        future: _listFuture2,
        builder: (context, docsnap) {
          if (!docsnap.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        AppColors.primarypurple)));
          }
          Map<String, dynamic> data = docsnap.data.data();
          bool isPostOwner = currentUser.uid == userId;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Animator<double>(
                        tween: Tween<double>(begin: 0, end: 28),
                        cycles: 1,
                        animatorKey: animatorKeyLike,
                        triggerOnInit: true,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                        builder: (context, animatorState, child ) => Center(
                          child: IconButton(
                              icon: isLiked ? Icon(
                                Icons.favorite,
                                color: Colors.pink,
                                size: animatorState.value,)
                                  : Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.pink,
                                size:animatorState.value,
                              )
                              , onPressed: () async {

                            handleLikePost(userId);

                          }),
                        ),
                      ),

                      Padding(
                          padding: EdgeInsets.only(top: 40.0, left: 5.0)
                      ),
                      GestureDetector(

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Comments(postId: widget.postId, postOwnerId:  userId, postMediaUrl: imageURL,
                                analytics: AppBase.analytics,
                                observer: AppBase.observer)),);
                        },
                        child: Icon(
                          Icons.chat_bubble_outline_sharp,
                          size: 26.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 40.0, left: 5.0)
                      ),
                      !isPostOwner?GestureDetector(
                          onTap: () {}, //TODO:add reshare functions
                          child: (!_isFlagged) ? Icon(
                            Icons.assistant_photo_outlined,
                            size: 28.0,
                            color: Colors.blueGrey[900],
                          ) :  Icon(
                            Icons.assistant_photo,
                            size: 28.0,
                            color: Colors.blueGrey[900],
                          )
                      ): SizedBox(width:5,),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Animator<double>(
                        tween: Tween<double>(begin: 0, end: 28),
                        cycles: 1,
                        animatorKey: animatorKeyBookmark,
                        triggerOnInit: true,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                        builder: (context, animatorState, child ) => Center(
                          child: GestureDetector(
                              onTap: () {
                                animatorKeyBookmark.refreshAnimation(
                                    tween: Tween<double>(begin: 0, end: 28),//new tween
                                    duration : Duration(milliseconds: 500),
                                    curve : Curves.elasticOut,
                                    cycles : 1
                                );
                                animatorKeyBookmark.triggerAnimation(restart:  true);
                                handleBookmark(imageURL); },//todo add to favorites
                              child: _Bookmarked ? Icon(
                                Icons.bookmark,
                                size: animatorState.value,
                                color: Colors.blue[900],
                              ) : Icon(
                                Icons.bookmark_border,
                                size: animatorState.value,
                                color: Colors.blue[900],
                              )
                          ),
                        ),
                      ),

                      //TODO: add reshare button
                      SizedBox(width: 5,)],
                  ),

                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      "${likeCount} likes",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  buildCommentLength(),
                ],
              ),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 15.0),
                    child: Text(
                      "${data["Username"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width:5,),
                  Expanded(child: Text(
                    caption,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  )
                  )

                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15,20, 0, 0),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );}
    );
  }
  handleBookmark(String imageURL) async {
    var results = await favoriteRef
        .where("PostId", isEqualTo: widget.postId)
        .where("UserId", isEqualTo: currentUser.uid)
        .get();
    bool bookmarked;
    if(results.docs.isNotEmpty)
    {
      //remove it
      for(var result in results.docs)
      {
        favoriteRef
            .doc(result.id)
            .delete();
      }
      bookmarked = false;
    }
    else{
      //add it
      favoriteRef
          .add({"PostId" : widget.postId, "UserId" : currentUser.uid, "Image" : imageURL});
      bookmarked = true;
    }
    setState(() {
      _Bookmarked = bookmarked;
    });
  }
  handleLikePost(String userId) async {
    animatorKeyLike.refreshAnimation(
        tween: Tween<double>(begin: 0, end: 28),//new tween
        duration : Duration(milliseconds: 500),
        curve : Curves.elasticOut,
        cycles : 1
    );
    bool _isLiked = _Likesmap[currentUser.uid] == true;
    if (_isLiked) {
      getpostRef
          .doc(widget.postId)
          .update({'LikesMap.${currentUser.uid}': false});
      //removeLikeFromActivityFeed();
      if(widget.userId != currentUser.uid)
      {
        var toDelete =  await activityFeedRef
            .doc(widget.userId)
            .collection('feedItems')
            .where('PostID', isEqualTo: widget.postId)
            .get();
        for(var notif in toDelete.docs)
        {
          if(notif.data()["userId"] == currentUser.uid)
          {
            activityFeedRef
                .doc(widget.userId)
                .collection('feedItems')
                .doc(notif.id)
                .delete();
            break;
          }
        }

      }
      setState(() {
        likeCount -= 1;

        isLiked = false;
        _Likesmap[currentUser.uid] = false;


      });

    } else if (!_isLiked) {
      getpostRef
          .doc(widget.postId)
          .update({'LikesMap.${currentUser.uid}': true});
      if(widget.userId != currentUser.uid) {
        activityFeedRef
            .doc(widget.userId)
            .collection('feedItems')
            .add({
          "commentData" : "",
          "PostID": widget.postId,
          "type": "like",
          "ownerId": widget.userId,
          //"username": _gotLoggedinUsername,
          "userId": currentUser.uid,
          //"userProfileImg": userProfileImg,2
          "timestamp": Timestamp.now(),
        });
      }

      setState(() {
        likeCount += 1;
        isLiked = true;
        _Likesmap[currentUser.uid] = true;
        animatorKeyLike2.triggerAnimation(restart: true);

        // showHeart = true;
      });
      // Timer(Duration(milliseconds: 500), () {
      //   setState(() {
      //     showHeart = false;
      //   });
      // });
    }
    animatorKeyLike.triggerAnimation(restart:  true);

  }

  Future<DocumentSnapshot> _listFuture1;
  Future<DocumentSnapshot> _listFuture2;
  void initState() {
    super.initState();
    _listFuture1 = getPost();
    _listFuture2 = getUser();
    setBookmark();
  }

  setBookmark() async {
    var results = await favoriteRef
        .where("PostId", isEqualTo: widget.postId)
        .where("UserId", isEqualTo: currentUser.uid)
        .get();
    setState(() {
      _Bookmarked = results.docs.isNotEmpty;
    });

  }
  Future<DocumentSnapshot> getPost() async{

    var result = await getpostRef
        .doc(widget.postId)
        .get();
    var parseLocation = result.data()['Location'];
    var location1 = GeoPoint(parseLocation.latitude, parseLocation.longitude);
    if(result.data()['Locationname'] != null)
    {
      setState(() {
        _locationString = result.data()['Locationname'];
      });
    }
    else {
      setLocation(location1);
    }


    isLiked = result.data()['LikesMap'][currentUser.uid] == true ;
    int count = 0;
    List<String> KeysToRemove = [];
    _Likesmap = result.data()['LikesMap'];
    if (_Likesmap == null) {
      count = 0;
    }
    else{
      for(var key in _Likesmap.keys)
      {
        await usersRef
            .doc(key)
            .get()
            .then((doc) {
          if (!doc.exists) {
            KeysToRemove.add(doc.id);
          }
          else{
            if(_Likesmap[doc.id] == true)
            {
              count++;
            }
          }
        });
      }
      for(var key in KeysToRemove)
      {
        _Likesmap.remove(key);
      }
      getpostRef.doc(widget.postId).update({'LikesMap': _Likesmap});

    }
    setState(() {
      likeCount = count;
      _Likesmap = _Likesmap;
    });
    return result;
  }
  Future<DocumentSnapshot> getUser() async {
    var result = await usersRef.doc(widget.userId).get();
    var loggedInUser = await usersRef.doc(currentUser.uid).get();
    var gotUsername = result.data()['Username'];
    var gotLoggedinUsername = loggedInUser.data()['Username'];
    var gotProfilePic = loggedInUser.data()['ProfilePic'];
    setState(() {
      Username = gotUsername;
      _gotLoggedinUsername = gotLoggedinUsername;
      userProfileImg = gotProfilePic;
    });
    return result;
  }
  setLocation(GeoPoint location1) async {
    final coordinates = new Coordinates(location1.latitude, location1.longitude);
    var locationString = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _locationString = locationString.first.addressLine;

    });

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  _listFuture1,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          AppColors.primarypurple)),
                ),
              );
        }
        //print(snapshot.data);
        Post1 post = Post1(
            caption: snapshot.data["Caption"],
            imageURL: snapshot.data["Image"],
            likes: snapshot.data["Likes"],
            createdAt: snapshot.data["createdAt"],
            isPrivate: snapshot.data["IsPrivate"],
            location: snapshot.data["Location"],
            LikesMap : snapshot.data['LikesMap'],
            UserID: widget.userId,
            PostID: widget.postId
        );

        return Center(
          child: Scaffold(
            appBar: header(context, titleText: Username),
            body: ListView(
              children: <Widget>[
                SizedBox(height: 5),
                buildPostHeader(widget.userId , post.imageURL),
                SizedBox(height: 5),
                buildPostImage(post.imageURL),
                buildPostFooter(widget.userId, post.caption, post.likes, post.imageURL,timeago.format(post.createdAt.toDate()))
              ],
            ),
          ),
        );
      },
    );
  }
}