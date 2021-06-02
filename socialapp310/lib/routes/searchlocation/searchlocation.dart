import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/routes/search/searchWidget.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';
import 'package:socialapp310/routes/uploadpic/editpost.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoder/geocoder.dart';

class SearchLocation extends StatefulWidget {
  SearchLocation({Key key, this.analytics, this.observer,this.imageFile,this.imageUrl,this.postId,this.caption})
      : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final File imageFile;
  final String imageUrl;
  final String postId;
  var caption;
  @override
  _SearchLocationState createState() => _SearchLocationState(imageFile,imageUrl,postId,caption);
}

class _SearchLocationState extends State<SearchLocation> {
  double lat=0;
  double long=0;
  String locationname;
  String locationMessage;
  File imageFile;
  String imageUrl;
  String postId;
  var caption;
  _SearchLocationState(this.imageFile,this.imageUrl,this.postId,this.caption);
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Search Location Page');
    _setLogEvent();
    print("SCS : Search Location Page succeeded");
  }

  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Search_Location_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Search Location Page',
        });
  }

  final _formKey = GlobalKey<FormState>();
  String mapKey = 'AIzaSyD0fvZRggBM27RQzg6oxAcpWidUzQ_vB1k';
  String query = '';
  Map<String, dynamic> res;
  String hintText = 'Search Location';
  ValueChanged<String> onChanged;

  Future<void> locationfinder(String address,String placeid) async {
    var locations =  await locationFromAddress(address);
    print(locations);
    lat=(locations[0].latitude);
    long=(locations[0].longitude);
    final coordinates = new Coordinates(lat, long);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    locationname = ("${first.featureName} : ${first.addressLine}");
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) =>  CreatePost(analytics: AppBase.analytics, observer: AppBase.observer, lat: lat,long: long, locationname:locationname,imageFile: imageFile, ),
    ),);
    // locationname = ("${first.featureName} : ${first.addressLine}");
    locationname=address;
    if(imageUrl==null) {
      Navigator.push(context, MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            CreatePost(analytics: AppBase.analytics,
                observer: AppBase.observer,
                lat: lat,
                long: long,
                locationname: locationname,
                imageFile: imageFile,
                placeid: placeid,
                caption: caption),
      ),);
    }
    else
    {
      Navigator.push(context, MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            editpost(analytics: AppBase.analytics,
              observer: AppBase.observer,
              lat: lat,
              long: long,
              locationname: locationname,
              imageUrl: imageUrl,
              placeid: placeid,
              postId: postId,
              caption: caption,
            ),
      ),);
    }

  }
  Future<dynamic> findPlace(String placeName) async {
    // print('here');
    // print(placeName);
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      // (res);
      return res;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Stream<dynamic> getFindView(place) async* {
    //await Future.delayed(Duration(seconds: 1));
    yield await findPlace(place);
  }


  @override
  void initState() {
    // Assign that variable your Future.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String text = "";
    final controller = TextEditingController();
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = text == "" ? styleHint : styleActive;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Location',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: AppColors.darkpurple,
        centerTitle: true,
        // elevation: 0.0,
      ),
      body:
      // StreamBuilder(
      // stream: _stream,
      // // initialData: [],
      // builder: (context, snapshot) {
      //   if (snapshot.hasError) {
      //     return Text('There was an error :(');
      //   } else if (snapshot.hasData || snapshot.data == null) {
      //     res != null ? print(res) : null;
      //     print(snapshot.data);
      //     // if(snapshot.data != null)
      //     // print(snapshot.data.length);
      //     return
      (Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 42,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: style.color),
                    suffixIcon: text.isNotEmpty
                        ? GestureDetector(
                      child: Icon(Icons.close, color: style.color),
                      onTap: () {
                        controller.clear();
                        onChanged('');
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    )
                        : null,
                    hintText: hintText,
                    hintStyle: style,
                    border: InputBorder.none,
                  ),
                  style: style,
                  onSaved: (String value) {
                    query = value;
                  },
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.primarypurple,
                ),
                onPressed: () async {
                  _formKey.currentState.save();
                  findPlace(query);
                  setState(() {
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Search',
                    style: kButtonDarkTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
            future: findPlace(query),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('There was an error :(');
              } else if (snapshot.hasData || snapshot.data == null) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: ListView.builder(
                      itemCount:
                      snapshot.data == null ? 0 : snapshot.data["predictions"].length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            title:
                            Text(snapshot.data["predictions"][index]["description"]),
                            leading: Icon(Icons.add_location_alt),
                            onTap:() {
                              print(snapshot.data["predictions"][index]["description"]);
                              locationfinder(snapshot.data["predictions"][index]["description"],snapshot.data["predictions"][index]["place_id"]);
                            },
                          ),
                          Divider(color: Colors.black)
                        ],
                      ),
                      //ItemCard(
                      //product: snapshot.data[index],
                      //press: () => Navigator.push(
                      // context,
                      //MaterialPageRoute(
                      //builder: (context) =>
                      // SingleProduct(id: products[index].productId),
                      //)),
                    ),
                  ),
                );
              } else {
                // print(snapshot.data);
                return (Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.darkpurple))));
              }
            })
      ])),
    );
  }
}