import 'package:flutter/material.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    bool isSwitched = true;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: kAppBarTitleTextStyle,
          ),
          backgroundColor: AppColors.darkpurple,
          centerTitle: true,
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
            child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            InkWell(
              onTap: () {
                // Navigator.pushReplacementNamed(context, '/homefeed');
              },
              child: ListTile(
                title: Text('Change Password',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.7,
                        fontFamily: 'OpenSansCondensed-Bold',
                        color: Colors.black)),
                leading: Icon(Icons.now_widgets_outlined),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homefeed');
              },
              child: ListTile(
                title: Text('Delete Account',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.7,
                        fontFamily: 'OpenSansCondensed-Bold',
                        color: Colors.black)),
                leading: Icon(Icons.auto_delete_outlined),
                trailing: OutlinedButton(
                  onPressed: () {
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      letterSpacing: -0.7,
                      fontFamily: 'OpenSansCondensed-Bold',
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primarypurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    side: BorderSide(
                        width: 2, color: AppColors.primarypurple),
                  ),
                )
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homefeed');
              },
              child: ListTile(
                title: Text('Deactivate Account',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.7,
                        fontFamily: 'OpenSansCondensed-Bold',
                        color: Colors.black)),
                leading: Icon(Icons.admin_panel_settings_rounded),
                  trailing: OutlinedButton(
                    onPressed: () {
                    },
                    child: Text(
                      'Deactivate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        letterSpacing: -0.7,
                        fontFamily: 'OpenSansCondensed-Bold',
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primarypurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: BorderSide(
                          width: 2, color: AppColors.primarypurple),
                    ),
                  )
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/homefeed');
              },
              child: ListTile(
                title: Text('Private Account',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.7,
                        fontFamily: 'OpenSansCondensed-Bold',
                        color: Colors.black)),
                leading: Icon(Icons.lock_outline),
                trailing: Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = !value;
                      print(isSwitched);
                    });
                  },
                  activeTrackColor: AppColors.primarypurple,
                  activeColor: AppColors.primarypurple,
                ),
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        )));
  }
}
