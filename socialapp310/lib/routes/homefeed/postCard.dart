import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/models/Post1.dart';
import 'package:flutter/gestures.dart';
import 'package:geocoder/geocoder.dart';
import 'package:animator/animator.dart';


class PostCard extends StatefulWidget {
  final Post1 post;
  PostCard({this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  User currentUser = FirebaseAuth.instance.currentUser;
  bool pressed = false;
  String _postOwner ="";
  var _location = "Something Else";
  bool _isPostOwner = false;
  bool isLiked = false;
  int likeCount = 0;
  Map<String,dynamic> _Likesmap;
  final animatorKeyLike2 = AnimatorKey<double>();
  String _ProfPic = 'https://picsum.photos/250?image=9';
  // final animatorKeyLike = AnimatorKey<double>();
  // final animatorKeyLike2 = AnimatorKey<double>();
  // final animatorKeyBookmark = AnimatorKey<double>();

  void initState() {
    // TODO: implement initState
    super.initState();
    getUserinfo();
    var parseLocation = widget.post.location;
    var location1 = GeoPoint(parseLocation.latitude, parseLocation.longitude);
    setLocation(location1);
    _isPostOwner = currentUser.uid == widget.post.UserID;
    //print(_isPostOwner);
    setUpLikes();

  }
  getUserinfo() async{
    var result = await usersRef
        .doc(widget.post.UserID)
        .get();
    var PostOwner = result.data()['Username'];
    var profPic = result.data()['ProfilePic'];
    setState(() {
     _postOwner =PostOwner;
     _ProfPic = profPic;
    });
  }
  setLocation(GeoPoint location1) async {
    final coordinates = new Coordinates(location1.latitude, location1.longitude);
    var locationString = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _location = locationString.first.addressLine;
    });
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

                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) =>  ProfileScreen(analytics: AppBase.analytics, observer: AppBase.observer)
                    ),);
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
        .doc(widget.post.PostID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }

    });
    // delete all activity feed notifications
    var toDelete =  await activityFeedRef
        .doc(widget.post.UserID)
        .collection('feedItems')
        .where('PostID', isEqualTo: widget.post.PostID)
        .get();
    for(var notif in toDelete.docs)
    {
      activityFeedRef
          .doc(widget.post.UserID)
          .collection('feedItems')
          .doc(notif.id)
          .delete();
    }
    // TODO:then delete all comments

  }

  setUpLikes() async{
    setState(() {
      isLiked = widget.post.LikesMap[currentUser.uid] == true ;
      if (widget.post.LikesMap == null) {
        likeCount = 0;
      }
      else{
        int count = 0;
        widget.post.LikesMap.values.forEach((val) {
          if (val == true) {
            count += 1;
          }
        });
        likeCount = count;
      }
      _Likesmap = widget.post.LikesMap;

    });
  }

  handleLikePost(String userID) async {
    // animatorKeyLike.refreshAnimation(
    //     tween: Tween<double>(begin: 0, end: 28),//new tween
    //     duration : Duration(milliseconds: 500),
    //     curve : Curves.elasticOut,
    //     cycles : 1
    // );
    bool _isLiked = _Likesmap[currentUser.uid] == true;
    if (_isLiked) {  //already liked, current user unlikes post
      getpostRef
          .doc(widget.post.PostID)
          .update({'LikesMap.${currentUser.uid}': false}); //update post likes inpost collection
      //removeLikeFromActivityFeed();
      if(widget.post.UserID != currentUser.uid) //if unliked by current user who is not the owner
      {
        var toDelete =  await activityFeedRef //from notification collection
            .doc(widget.post.UserID) //find the user in notifications who owns the post
            .collection('feedItems')
            .where('PostID', isEqualTo: widget.post.PostID) //get all notififcations with this post ID from owner
            .get();
        for(var notif in toDelete.docs) //for each notification
        {
          if(notif.data()["userId"] == currentUser.uid) //inside notfi use userID and compare to current user who unliked it/so remove only his like
          {
            activityFeedRef
                .doc(widget.post.UserID) //go to that userID and delete that Object with Postid returned
                .collection('feedItems')
                .doc(notif.id)
                .delete();
            break;
          }
        }
      }
      setState(() {
        print("subtract 1");
        likeCount -= 1;

        isLiked = false;
        _Likesmap[currentUser.uid] = false;
      });

    }
    else if (!_isLiked) {   //if current user hasnot liked the post
      getpostRef
          .doc(widget.post.PostID)
          .update({'LikesMap.${currentUser.uid}': true}); //change like status to true in the posts table
      if(widget.post.UserID != currentUser.uid) { //if someone other than the postowner  liked
        activityFeedRef
            .doc(widget.post.UserID) //find the notifications of post owner
            .collection('feedItems')
            .add({  //add notification
          "PostID": widget.post.PostID,
          "type": "like",
          "ownerId": widget.post.UserID,
          //"username": _gotLoggedinUsername,
          "userId": currentUser.uid,
          //"userProfileImg": userProfileImg,2
          "timestamp": Timestamp.now(),
        });
      }

      setState(() {
        print("add 1");
        likeCount +=1;
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
    //animatorKeyLike.triggerAnimation(restart:  true);

  }

  getUser() async{
    //query user using widget.post.userid
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.fromLTRB(0, 4.0, 0.0, 4.0),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Container(
                  width: 50,
                  height: 60,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(_ProfPic),
                    backgroundColor: Colors.grey,
                  ),
                ),
                title: GestureDetector(
                  onTap: () => {},//TODO: on tap of username do something
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 0, 6),
                    child: Text(
                      _postOwner,
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
                        "$_location",
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
                trailing: _isPostOwner
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
                    }
                    else if (value == "Delete")
                    {
                      handleDeletePost(context);
                    }

                  },
                )
                    : Text(''),

              ),
              Divider(
                color: AppColors.lightgrey,
                height: 5,
                thickness: 1.0,
              ),

              Stack(
                  alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreenLink(
                          ImageUrlPost: widget.post.imageURL,
                        );
                      }));
                    },
                    onDoubleTap: (){handleLikePost(widget.post.PostID);},
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8,5,5,8),
                      child: Container(
                        height: (MediaQuery.of(context).size.width)-70,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.post.imageURL),
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
                  ),]
              ),
              Divider(
                color: AppColors.lightgrey,
                height: 10,
                thickness: 1.0,
              ),
              Text(
                "${widget.post.caption}",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    fontFamily: 'OpenSansCondensed-Bold'),
              ),
              SizedBox(height: 5),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${likeCount} likes",
                            style: TextStyle(
                                color: AppColors.darkgrey,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                                fontFamily: 'OpenSansCondensed-Bold'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          /*Text(   //Get total number of comments
                            "${widget.post.comments} comments",
                            style: TextStyle(
                                color: AppColors.darkgrey,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                                fontFamily: 'OpenSansCondensed-Bold'),
                          ), */
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                                icon: isLiked ? Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                  size: 28,)
                                    : Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.pink,
                                  size: 28,
                                )
                                , onPressed: () async {
                                  await handleLikePost(widget.post.PostID);
                                }),

                        IconButton(
                          padding: EdgeInsets.all(0.0),
                          splashRadius: 25,
                          onPressed: () {},
                          icon: Icon(
                            Icons.chat_bubble_outline,
                            size: 30.0,
                            color: Colors.black54,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0.0),
                          splashRadius: 25,
                          onPressed: () {},
                          icon: Icon(
                            Icons.redo,
                            size: 30.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String ImageUrlPost;

  DetailScreen({this.ImageUrlPost});
  Matrix4 initialScale =
  Matrix4(1, 0, 0, 0, 0, 1.0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController _transformationController =
  TransformationController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: AppColors.darkgreyblack,
        body: Center(
          child: Hero(
            tag: '${ImageUrlPost}',
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              panEnabled: true, // Set it to false
              boundaryMargin: EdgeInsets.all(60),
              minScale: 0.33,
              maxScale: 3,
              child: Image(
                image: AssetImage(ImageUrlPost),
                fit: BoxFit.fill,
              ),
              transformationController: _transformationController,
              onInteractionEnd: (details) {
                if (_transformationController.value.getMaxScaleOnAxis() < 1) {
                  _transformationController.value = initialScale;
                }
              },
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

class DetailScreenLink extends StatelessWidget {
  final String ImageUrlPost;

  DetailScreenLink({this.ImageUrlPost});
  Matrix4 initialScale =
  Matrix4(1, 0, 0, 0, 0, 1.0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController _transformationController =
  TransformationController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: AppColors.darkgreyblack,
        body: Center(
          child: Hero(
            tag: '${ImageUrlPost}',
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              panEnabled: true, // Set it to false
              boundaryMargin: EdgeInsets.all(60),
              minScale: 0.33,
              maxScale: 3,
              child: Image(
                image: NetworkImage(ImageUrlPost),
                fit: BoxFit.fill,
              ),
              transformationController: _transformationController,
              onInteractionEnd: (details) {
                if (_transformationController.value.getMaxScaleOnAxis() < 1) {
                  _transformationController.value = initialScale;
                }
              },
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

