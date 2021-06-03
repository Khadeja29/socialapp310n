import 'package:flutter/material.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';
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
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';



class Uploadpic extends StatefulWidget {
  const Uploadpic({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _Uploadpic createState() => _Uploadpic();
}

class _Uploadpic extends State<Uploadpic> {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      appBar: AppBar(
        backgroundColor: AppColors.darkpurple,
        title: Text(''),
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/homefeed');
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
      ),
      body: Center(
        child: imageFile == null ? Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/welcoming.png'),
                  fit: BoxFit.cover)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 80),
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),

                    ),
                    backgroundColor: AppColors.peachpink,
                  ),
                  onPressed: () {
                    _getFromCamera();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'Use camera',
                            style: TextStyle(
                                color: AppColors.darkpurple,
                                fontSize: 20.0,
                                letterSpacing: -0.7,
                                fontFamily: 'OpenSansCondensed-Light'
                            )
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.camera_alt_outlined,
                          color: AppColors.darkpurple,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50),
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),

                    ),
                    backgroundColor: AppColors.peachpink,
                  ),
                  onPressed: () {
                    _getFromGallery();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'Upload from device',
                            style: TextStyle(
                                color: AppColors.darkpurple,
                                fontSize: 20.0,
                                letterSpacing: -0.7,
                                fontFamily: 'OpenSansCondensed-Light'
                            )
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.file_upload,
                            color: AppColors.darkpurple),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40,),
              ElevatedButton(

                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),

                  ),
                  backgroundColor: AppColors.peachpink,
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/homefeed');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 30),
                  child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: AppColors.darkpurple,
                          fontSize: 20.0,
                          letterSpacing: -0.7,
                          fontFamily: 'OpenSansCondensed-Light'
                      )
                  ),
                ),
              ),
              SizedBox(height: 30,),

            ],

          ),
        )
            : Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/logo_woof.png'),
                  fit: BoxFit.cover)
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    )
                ),
              ),
              FloatingActionButton(
                child: Icon(Icons.backup_outlined),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                onPressed: () =>
                {
                  Navigator.push(context, MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        CreatePost(analytics: AppBase.analytics,
                            observer: AppBase.observer,
                            imageFile: imageFile),
                  ),)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Upload page');
    print("SCS : Upload page succeeded");
  }

  void initState() {
    super.initState();
    _setCurrentScreen();
  }

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}