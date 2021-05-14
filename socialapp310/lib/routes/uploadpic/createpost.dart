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

class CreatePost extends StatefulWidget {
  File imageFile;
  CreatePost({this.imageFile});
  @override
  _CreatePost createState() => _CreatePost();
}

class _CreatePost extends State<CreatePost> {
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
                  Navigator.pushNamed(context, '/homefeed');
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

                    }),
                  ),
                ),
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),

            child: TextField(

              onChanged: ((value) {

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
}


