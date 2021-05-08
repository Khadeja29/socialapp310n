import 'package:flutter/material.dart';
import 'package:socialapp310/models/user.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';

import 'package:socialapp310/utils/color.dart';

Widget profileStats({Size screen, Color color, @required  post , @required  int followers , @required int following, @required BuildContext context}) {
  return Container(
    padding: const EdgeInsets.only(left: 10, right: 10),
    color: color,
    height: 120,
    child: Row(
      children: <Widget>[
        SizedBox(height: 15,),
        Container(
          width: 100,
          child: Align(
            alignment: Alignment.centerLeft,
            child: profileAvatar(
              height: 100,
              width: 100,
              context: context,
            ),
          ),
        ),
        Container(
          width: screen.width - 100 - 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              statsBox(count: '$post', title: 'Posts'),
              statsBox(count: '$followers', title: 'Followers'),
              statsBox(count: '$following', title: 'Following'),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget bio({@required String name, @required String biodata}) {
  return Container(
    color: Colors.white,
    height: 100,
    width: 500,
    padding: const EdgeInsets.only(left: 15, right: 20, top: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkpurple,
            fontSize: 20.0,
          ),
        ),
        SizedBox(height: 10.0,),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                 biodata,
                style: TextStyle(
                  color: AppColors.darkgreyblack,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget statsBox({
  @required String count,
  @required String title,
}) {
  return Container(
    height: 98,
    width: 80,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: TextStyle(
              fontSize: 18, color: AppColors.darkpurple, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 14, color: AppColors.darkpurple),
        ),
      ],
    ),
  );
}

Widget profileAvatar({
  @required double height,
  @required double width,
  @required BuildContext context,
}) {
  return Container(
    height: height,
    width: width,
    child: Center(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            child: Hero(
              tag: '${profuser.imageUrlAvatar}',
              child: CircleAvatar(
                backgroundImage: AssetImage(profuser.imageUrlAvatar),
                radius: 90,
              ),
            ),
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (_) {
                return DetailScreen(ImageUrlPost: profuser.imageUrlAvatar,);
              }));
            },
          ),
        ),
      ),
    ),
  );
}

