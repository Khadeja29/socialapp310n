import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';
import 'package:socialapp310/utils/color.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:flutter/src/material/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:intl/intl.dart';

class CreatePost extends StatefulWidget {
  final File imageFile;
  CreatePost({Key key, this.analytics, this.observer,this.imageFile}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _CreatePost createState() => _CreatePost(imageFile);
}

class _CreatePost extends State<CreatePost> {
  File imageFile;
  var location_pic;
  var caption;
  _CreatePost(this.imageFile);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location_pic = TextEditingController();
    caption = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    location_pic?.dispose();
    caption?.dispose();
  }

  void imageuploader(String caption, String Location_pic){
    String imagename = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference = FirebaseStorage.instance.ref()
        .child(imagename);
    final UploadTask uploadTask =  storageReference.putFile(imageFile);
    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageUrl){
        //save info to firestore
        _saveData(imageUrl,caption,Location_pic);
      });
    }).catchError((error){
      Fluttertoast.showToast(msg: error.toString(),);
    });
  }
  void _saveData(String imageUrl,String caption,String Location_pic){
    FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;
    String id_user = currentFB.uid;
    int num = null;
    List<String> comments;
    FirebaseFirestore.instance.collection('Post').add({
      'Image': imageUrl,
      'Caption': caption,
      'Location': GeoPoint(10,10),
      'Comment': comments,
      'Likes': num,
      'createdAt': Timestamp.now(),
      'PostUser': id_user,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post',
          style:TextStyle(color: Colors.white), ),
        backgroundColor: AppColors.darkpurple,
        elevation: 1.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
                child: Text('Share',
                    style: TextStyle(color: Colors.white, fontSize: 16.0)),
                onTap: () {
                  imageuploader(caption,location_pic);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeFeed()), (Route<dynamic> route) => false);
                }),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(widget.imageFile)
                      )
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(

                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Write a caption...',
                    ),
                    onChanged: ((value) {
                      setState(() {
                        caption=value;
                      });
                    }),
                  ),
                ),
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),

            child: TextField(

              onChanged: ((location_picx) {
                setState(() {
                  location_pic=location_picx;
                });
              }),
              decoration: InputDecoration(
                hintText: 'Add location',
                prefixIcon: Icon(Icons.add_location_sharp,
                  color: Colors.red,),
              ),
            ),
          ),

        ],
      ),
    );
  }
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Create Post');
    print("SCS : Create Post succeeded");
  }
  void _initState() {
    super.initState();
    _setCurrentScreen();
  }
}
