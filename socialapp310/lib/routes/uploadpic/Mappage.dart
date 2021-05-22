import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoder/geocoder.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';

class Mappage extends StatefulWidget {
  // location
  @override
  _Mappage createState() => _Mappage();
}

class _Mappage extends State<Mappage> {
  var locationMessage = '';
  var locationname='';
  String latitude;
  String longitude;

  // function for getting the current location
  // but before that you need to add this permission!
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;

    // passing this to latitude and longitude strings
    latitude = "$lat";
    longitude = "$long";

    final coordinates = new Coordinates(lat , long);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    setState(() {
      locationMessage = "Latitude: $lat and Longitude: $long";
      locationname= ("${first.featureName} : ${first.addressLine}");
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Map Page',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 45.0,
                color: Colors.white,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Get User Location",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                locationMessage,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                locationname,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 05.0,
              ),

              // button for taking the location
              ElevatedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),

                  ),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  getCurrentLocation();
                },
                child: Text("Get User Location"),
              ),

              ElevatedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),

                  ),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  googleMap();
                },
                child: Text("Open GoogleMap"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}