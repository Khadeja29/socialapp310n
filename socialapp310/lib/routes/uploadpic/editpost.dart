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
import 'package:socialapp310/utils/color.dart';
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

class editpost extends StatefulWidget {
  String postId;
  String imageUrl;
  double lat;
  double long;
  var locationname;
  String placeid;
  var caption;
  editpost({Key key, this.analytics, this.observer, this.imageUrl,this.placeid,this.locationname,this.lat,this.long,this.postId,this.caption})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _editpost createState() => _editpost(lat,long,locationname,placeid,imageUrl,postId,caption);
}

//Location Functions come here
class _editpost extends State<editpost> {
  var location_pic;
  var caption;
  var locationMessage;
  String postId;
  String imageUrl;
  String placeid;
  var locationname;
  String latitude;
  String longitude;
  double lat;
  double long;

  _editpost(this.lat,this.long,this.locationname,this.placeid,this.imageUrl,this.postId,this.caption);

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
      locationname = ("${first.addressLine}");
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


  // void imageuploader(String caption, File inputimageFile) {
  //   String imagename = DateTime.now().millisecondsSinceEpoch.toString();
  //   final Reference storageReference =
  //   FirebaseStorage.instance.ref().child(imagename);
  //   final UploadTask uploadTask = storageReference.putFile(inputimageFile);
  //   uploadTask.then((TaskSnapshot taskSnapshot) {
  //     taskSnapshot.ref.getDownloadURL().then((imageUrl) {
  //       //save info to firestore
  //       _saveData(imageUrl, caption);
  //     });
  //   }).catchError((error) {
  //     Fluttertoast.showToast(
  //       msg: error.toString(),
  //     );
  //   });
  // }

  Future<bool> checkUser()  async {
    bool privatesc;
    final firestoreInstance = FirebaseFirestore.instance;
    var firebaseUser =  FBauth.FirebaseAuth.instance.currentUser;
    var private = await firestoreInstance.collection("user").doc(firebaseUser.uid).get().then((value){
      privatesc=value.data()["IsPrivate"];
    });
    return privatesc;
  }
  // void newfunction ()async{
  //   print(await checkUser());
  // }
  Future<void> _saveData(String caption) async {
    FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;
    String id_user = currentFB.uid;
    int num = 0;
    List<String> comments=[];
    print("test");
    bool isprivate = await checkUser();
    if (lat==null||long==null){
      lat=0;
      long=0;
    }

    QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('Post').where('Image', isEqualTo: widget.imageUrl).get();
    QueryDocumentSnapshot doc = querySnap.docs[0];  // Assumption: the query returns only one document, THE doc you are looking for.
    DocumentReference docRef = doc.reference;
    docRef.update({
      'Caption': caption,
      'Location': GeoPoint(lat, long),
      'locationID': placeid,
      'Locationname':locationname,
    });
    FirebaseFirestore.instance.collection('Locations').doc(placeid).set({
      'address':locationname,
      'coordinates':GeoPoint(lat,long),
    });
  }

  @override
  Widget build(BuildContext context) {
    //final widget = ModalRoute.of(context).settings.arguments as PassingValues;
    //print(widget.imagefile);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Post',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.darkpurple,
        elevation: 1.0,
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/profile');
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
                child: Text('Update',
                    style: TextStyle(color: Colors.white, fontSize: 16.0)),
                onTap: () {
                  //imageuploader(caption);
                  //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeFeed()), (Route<dynamic> route) => false);

                  _saveData(caption);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/profile', (route) => false);
                }),
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/cpback3.jpg'),
                fit: BoxFit.cover)
        ),
        child: Column(
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
                            fit: BoxFit.cover, image: NetworkImage(imageUrl)
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                    child: TextField(
                      style: TextStyle(
                        color:Colors.white,
                      ),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText:  'Write a caption...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder:  UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white,width: 1.0),
                            borderRadius: BorderRadius.circular(1.0),
                          ),

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
                  hintText: (locationname!=null)?'$locationname':'Press button to search for location',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  enabledBorder:  UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white,width: 1.0),
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  prefixIcon: IconButton(
                      icon: Icon(Icons.location_on_outlined,
                        color: Colors.red,
                      ),
                      onPressed: () => {//getCurrentLocation()
                        Navigator.push(context, MaterialPageRoute<void>(
                          builder: (BuildContext context) =>  SearchLocation(analytics: AppBase.analytics,observer: AppBase.observer, imageUrl:imageUrl ),
                        ),)
                      }
                      ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
            //   child: ElevatedButton(
            //     style: OutlinedButton.styleFrom(
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10.0),
            //
            //       ),
            //       backgroundColor: AppColors.peachpink,
            //     ),
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute<void>(
            //         builder: (BuildContext context) =>  SearchLocation(analytics: AppBase.analytics,imageUrl:imageUrl),
            //       ),);
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: <Widget>[
            //           Text(
            //               'Press button to search location',
            //               style:  TextStyle(
            //                   color: AppColors.darkpurple,
            //                   fontSize: 15.0,
            //                   letterSpacing: -0.7,
            //                   fontFamily: 'OpenSansCondensed-Light'
            //               )
            //           ),
            //           SizedBox(width:5),
            //           Icon(Icons.location_on_outlined,
            //             color: AppColors.darkpurple,)
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
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
