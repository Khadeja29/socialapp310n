import 'package:flutter/material.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/routes/homefeed/HomeFeed.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:flutter/material.dart';



class EditPost extends StatefulWidget {

  @override
  _EditPost createState() => _EditPost();
}

class _EditPost extends State<EditPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post',
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
                         image: AssetImage("assets/Dog/last.jpg")
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

                  ),
                ),
              )
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(20.0),

                child: TextField(
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


