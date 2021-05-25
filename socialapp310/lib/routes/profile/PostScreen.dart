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
    backgroundColor: Theme.of(context).accentColor,
  );
}


class PostScreen extends StatefulWidget {
  final String userId;
  final String postId;

  PostScreen({this.userId, this.postId});

  @override
  _PostScreenState createState() => _PostScreenState();
}



class _PostScreenState extends State<PostScreen> {


  String _locationString;
  bool isLiked = false;
  int likeCount = 0;
  Map<String,dynamic> _Likesmap;
  buildPostHeader(String userId)  {
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
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data["ProfilePic"]),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => {},//todo on tap of username do something
            child: Text(
              data["Username"],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text("$_locationString"),//todo convert location to string
          trailing: isPostOwner
              ? DropdownButton<String>(
            elevation: 0,
            icon:Icon(
               Icons.more_vert,//todo how to get isliked(the map of user ids to bool values)
              color: Colors.black,
            ),
            items: <String>['Edit', 'Delete'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child:  Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (value == "Edit")
              {}
              else if (value == "Delete")
              {
                //print('here');
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
                  onPressed: () {
                    Navigator.pop(context);
                    //deletePost(); //TODO: Add delete logic
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

  // deletePost() async {
  //   // delete post itself
  //   getpostRef
  //       .doc() //currentpost if
  //       .get()
  //       .then((doc) {
  //     if (doc.exists) {
  //       doc.reference.delete();
  //     }
  //   });
  //   // delete uploaded image for thep ost
  //
  //   // then delete all activity feed notifications
  //
  //   // then delete all comments
  //
  // }

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

  buildPostFooter(String userId, String caption, int likes) {

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
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
                  // GestureDetector(
                  //   onTap: (){handleLikePost(userId);}, //todo like handler
                  //   child: Icon(
                  //     isLiked ? Icons.favorite : Icons.favorite_border,//todo how to get isliked(the map of user ids to bool values)
                  //     size: 28.0,
                  //     color: Colors.pink,
                  //   ),
                  // ),
                  IconButton(icon: isLiked ? Icon(Icons.favorite,color: Colors.pink,) : Icon(Icons.favorite_border_outlined   ,color: Colors.pink,)
                      , onPressed: (){handleLikePost(userId);}),
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
                      "${likeCount} likes",//todo save number of likes in post
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


  handleLikePost(String userId) {

    bool _isLiked = _Likesmap[userId] == true;//todo what happened if likes is null ? is likes[userId] null as well or does it crash


    if (_isLiked) {
      getpostRef
          .doc(widget.postId)
          .update({'LikesMap.$userId': false});
      //removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        _Likesmap[userId] = false;
      });
    } else if (!_isLiked) {
      getpostRef
          .doc(widget.postId)
          .update({'LikesMap.$userId': true});
      //addLikeToActivityFeed();
      setState(() {
        likeCount += 1;
        isLiked = true;
        _Likesmap[userId] = true;
        // showHeart = true;
      });
      // Timer(Duration(milliseconds: 500), () {
      //   setState(() {
      //     showHeart = false;
      //   });
      // });
    }
  }
  Future<DocumentSnapshot> _listFuture1;
  Future<DocumentSnapshot> _listFuture2;
  void initState() {
    super.initState();
    _listFuture1 = getPost();
    _listFuture2 = getUser();

  }
  Future<DocumentSnapshot> getPost() async{

    var result = await getpostRef
                .doc(widget.postId)
                .get();
    var parseLocation = result.data()['Location'];
    var location1 = GeoPoint(parseLocation.latitude, parseLocation.longitude);
    setLocation(location1);
    setState(() {
      isLiked = result.data()['LikesMap'][widget.userId] == true ? true : false;
      if (result.data()['LikesMap'] == null) {
        likeCount = 0;
      }
      else{
        int count = 0;
        result.data()['LikesMap'].values.forEach((val) {
          if (val == true) {
            count += 1;
          }
        });
        likeCount = count;
      }

      _Likesmap = result.data()['LikesMap'];
    });
    return result;
  }
  Future<DocumentSnapshot> getUser() async {
    return usersRef.doc(widget.userId).get();
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
            LikesMap : snapshot.data['LikesMap'],
            UserID: widget.userId,
            PostID: widget.postId
        );
        print("here");
        return Center(
          child: Scaffold(
            appBar: header(context, titleText: post.caption),
            body: ListView(
              children: <Widget>[
                buildPostHeader(widget.userId),
                buildPostImage(post.imageURL),
                buildPostFooter(widget.userId, post.caption, post.likes)
              ],
            ),
          ),
        );
      },
    );
  }
}