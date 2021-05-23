import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/routes/searchlocation/searchlocation.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';
import 'package:socialapp310/utils/color.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socialapp310/routes/uploadpic/Mappage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoder/geocoder.dart';

import 'package:socialapp310/main.dart';

class CreatePost extends StatefulWidget {
  final File imageFile;
  double lat;
  double long;
  String locationname='Press the button to get current location';
  CreatePost({Key key, this.analytics, this.observer, this.imageFile,this.lat,this.long,this.locationname})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _CreatePost createState() => _CreatePost(imageFile,lat,long,locationname);
}

//Location Functions come here
class _CreatePost extends State<CreatePost> {
  File imageFile;
  var location_pic;
  var caption;
  var locationMessage;
  String locationname;
  String latitude;
  String longitude;
  double lat;
  double long;

  _CreatePost(this.imageFile,this.lat,this.long,this.locationname);

  // function for getting the current location
  // but before that you need to add this permission!
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;

    // passing this to latitude and longitude strings
    latitude = "$lat";
    longitude = "$long";

    final coordinates = new Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    setState(() {
      locationMessage = "Latitude: $lat and Longitude: $long";
      locationname = ("${first.featureName} : ${first.addressLine}");
    });
  }

  // function for opening it in google maps

  void googleMap() async {
    String googleUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else
      throw ("Couldn't open google maps");
  }

//location functions end here
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    caption = TextEditingController();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   location_pic?.dispose();
  //   caption?.dispose();
  // }

  void imageuploader(String caption, File inputimageFile) {
    String imagename = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(imagename);
    final UploadTask uploadTask = storageReference.putFile(inputimageFile);
    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageUrl) {
        //save info to firestore
        _saveData(imageUrl, caption);
      });
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: error.toString(),
      );
    });
  }

  void _saveData(String imageUrl, String caption) {
    FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;
    String id_user = currentFB.uid;
    int num = 0;
    List<String> comments=[];
    print("test");

    FirebaseFirestore.instance.collection('Post').add({
      'Image': imageUrl,
      'Caption': caption,
      'Location': GeoPoint(lat, long),
      'Comment': comments,
      'Likes': num,
      'createdAt': Timestamp.now(),
      'PostUser': id_user,
    });
  }

  @override
  Widget build(BuildContext context) {
    //final widget = ModalRoute.of(context).settings.arguments as PassingValues;
    //print(widget.imagefile);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.darkpurple,
        elevation: 1.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
                child: Text('Share',
                    style: TextStyle(color: Colors.white, fontSize: 16.0)),
                onTap: () {
                  //imageuploader(caption);
                  //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeFeed()), (Route<dynamic> route) => false);

                  imageuploader(caption, widget.imageFile);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/homefeed', (route) => false);
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
                          fit: BoxFit.cover, image: FileImage(widget.imageFile))),
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
                        caption = value;
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
              onChanged: ((location_picx) {}),
              readOnly: true,
              decoration: InputDecoration(
                hintText: '$locationname',
                prefixIcon: IconButton(
                    icon: Icon(Icons.add_location),
                    onPressed: () => {getCurrentLocation()}),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: ElevatedButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_location),
                    SizedBox(width: 5),
                    Text('Press button to see current location and Maps'),
                  ],
                ),
                onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Mappage()),
                      )
                    }),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: ElevatedButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_location),
                    SizedBox(width: 5),
                    Text('Press button to search location'),
                  ],
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute<void>(
                       builder: (BuildContext context) =>  SearchLocation(analytics: AppBase.analytics, imageFile: imageFile, ),
                      ),);
                }
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

// class PassingValues {
//   final File imagefile;
//
//   PassingValues(this.imagefile);
// }
