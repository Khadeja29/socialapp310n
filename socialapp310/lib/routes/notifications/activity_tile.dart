import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/utils/dimension.dart';
import 'package:socialapp310/models/notifications.dart';


class ActivityTile extends StatelessWidget {
  final NotificationItem activity;
  const ActivityTile({
    Key key,
    this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(activity.type == 'follow')
      return ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(activity.followerImageUrl),
        ),
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: activity.followerUsername,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' started following you.',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: ' 2d',
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
          ]),
        ),
        //* Need some gesture detection over here to convert follow to following
        // trailing: Container(
        //   width: activity.isFollowed ? 95 : 85,
        //   height: 30,
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   decoration: BoxDecoration(
        //     color: activity.isFollowed ? AppColors.primarypurple : Colors.black,
        //     border: activity.isFollowed
        //         ? Border.all(
        //       color: Colors.grey[500],
        //     )
        //         : Border.all(width: 0),
        //     borderRadius: BorderRadius.circular(5),
        //   ),
        //   child: Center(
        //     child: Text(
        //       activity.isFollowed ? 'Following' : 'Follow',
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
      );
    else if(activity.type == 'comment') {
      return ListTile(
        isThreeLine: true,
        contentPadding: EdgeInsets.only(left: 10),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(activity.otherUserProfileImageUrl),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: activity.otherUsername,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: activity.isMention
                    ? ' mentioned you in a comment:'
                    : ' liked your comment:',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: activity.isMention ? ' @gyakhoe' : '',
                style: TextStyle(
                  color: AppColors.darkgreyblack,
                ),
              ),
              TextSpan(
                text: activity.comment,
                style: TextStyle(
                  color: AppColors.darkgreyblack,
                ),
              ),
              TextSpan(
                text: ' 3d',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.favorite_border,
                size: 12,
                color: Colors.grey[400],
              ),
              SizedBox(width: 10),
              Text(
                'Reply',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        //* Need some gesture detection over here to convert follow to following
        trailing: Container(
          margin: EdgeInsets.only(right: 10),
          width: 45,
          height: 45,
          color: Colors.pink,
          child: Image(
            image: AssetImage(activity.commentedOrLikedOnMediaUrl),
            fit: BoxFit.fill,
          ),
        ),
      );
    }
    else {
      return ListTile(
        contentPadding: EdgeInsets.only(left: 10),
        leading:
            CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(activity.followerImageUrl),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: activity.followerUsername,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' liked your post.',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: ' 3d',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
        //* Need some gesture detection over here to convert follow to following
        trailing: Container(
          margin: EdgeInsets.only(right: 10),
          width: 45,
          height: 45,
          color: Colors.pink,
          child: Image(
            image: AssetImage(activity.commentedOrLikedOnMediaUrl),
            fit: BoxFit.fill,
          ),
        ),
      );
    }
  }
}
