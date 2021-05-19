import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';

class InstaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final bool isProfileScreen;
  final Widget leading;
  final Widget center;
  final Widget profileStats;
  final Widget bio;
  final Widget tabbar;
  final Widget trailing;

  final Color backgroundColor;


  const InstaAppBar({
    Key key,
    @required this.height,
    this.leading,
    @required this.center,
    @required this.profileStats,
    @required this.bio,
    @required this.tabbar,
    this.trailing,
    this.isProfileScreen = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: height,
      color: backgroundColor == null
          ? Colors.black
          : AppColors.darkpurple,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(
                height: 1,
                color: Colors.white,
              ),
              Expanded(
                child: isProfileScreen
                    ? Container()
                    : Align(
                  alignment: Alignment.centerLeft,
                  child: leading,
                ),
              ),
              Expanded(
                child: Align(
                  child: center,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: trailing,
                ),
              ),

            ],
          ),
          profileStats,
          bio,
          tabbar,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}