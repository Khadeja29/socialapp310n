import 'package:flutter/cupertino.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:flutter/material.dart';
import '../../models/post.dart';
import 'package:flutter/gestures.dart';

class PostCard extends StatefulWidget {
  final Post post;
  PostCard({this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool pressed = false;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(widget.post.ImageUrlAvatar),
                      radius: 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: "${widget.post.username}",

                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print(
                                  'Click on username'), //TODO: Push user profile
                            style: TextStyle(
                                color: AppColors.darkpurple,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.7,
                                fontFamily: 'OpenSansCondensed-Bold'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on_rounded,
                              size: 17.0,
                              color: Colors.redAccent,
                            ),
                            RichText(
                              text: TextSpan(
                                text: "${widget.post.loc.loc_name}",//loc => lat and long
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => print(
                                      'Click on location'), //TODO: Push user profile
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.4,
                                    fontFamily: 'OpenSansCondensed-Bold'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(
                color: AppColors.lightgrey,
                height: 5,
                thickness: 1.0,
              ),
              GestureDetector(
                child: Hero(
                  tag: '${widget.post.ImageUrlPost}',
                  child: Image(
                    image: AssetImage(widget.post.ImageUrlPost),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreen(
                      ImageUrlPost: widget.post.ImageUrlPost,
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
                          Text(
                            "${widget.post.comments} comments",
                            style: TextStyle(
                                color: AppColors.darkgrey,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                                fontFamily: 'OpenSansCondensed-Bold'),
                          ),
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
                                widget.post.likes++;
                              } else {
                                widget.post.likes--;
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
