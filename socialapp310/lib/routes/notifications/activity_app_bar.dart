import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/utils/dimension.dart';
import 'package:socialapp310/models/notifications.dart';

class ActivityAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  const ActivityAppBar({
    Key key,
    @required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      color: AppColors.darkpurple,
      height: height,
      child: Center(
        child: Text(
          'Activity',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}