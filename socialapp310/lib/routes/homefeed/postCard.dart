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


class PostCard extends StatefulWidget {
  final Post1 post;
  PostCard({this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool pressed = false;
  String _postOwner ="";
  var _location = "Something Else";
  bool _isPostOwner = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
    var parseLocation = widget.post.location;
    var location1 = GeoPoint(parseLocation.latitude, parseLocation.longitude);
    setLocation(location1);
    User currentUser = FirebaseAuth.instance.currentUser;
    _isPostOwner = currentUser.uid == widget.post.UserID;
    //print(_isPostOwner);

    //create some function that gets user
  }
  getUsername() async{
    var result = await usersRef
        .doc(widget.post.UserID)
        .get();
    var PostOwner = result.data()['Username'];
    setState(() {
     _postOwner =PostOwner;
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
    // delete uploaded image for thep ost
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
                    backgroundImage: NetworkImage(widget.post.imageURL),
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
              GestureDetector(
                child: Hero(
                  tag: '${widget.post.imageURL}',
                  child: Image(
                    image: NetworkImage(widget.post.imageURL),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreenLink(
                      ImageUrlPost: widget.post.imageURL,
                    );
                  }));
                },
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
                            "${widget.post.likes} likes",
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
                          icon: pressed == true
                              ? //if true then filled heart else empty heart
                              Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                  size: 30,
                                )
                              : Icon(Icons.favorite_border_outlined,
                                  color: Colors.redAccent, size: 30),
                          padding: EdgeInsets.all(0.0),
                          splashColor: Colors.pinkAccent[100],
                          splashRadius: 25,
                          onPressed: () {
                            setState(() {
                              pressed = !pressed;
                              if (pressed) {
                                widget.post.likes;
                              } else {
                                widget.post.likes;
                              }
                            });
                          },
                        ),
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

