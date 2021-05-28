import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/routes/welcome.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/routes/splashpage.dart';
import 'package:socialapp310/routes/login.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  int currentPage = 1;
  int totalPages = 6;
  List<String> AppbarTitles = [
    "Hello",
    "Intro",
    "Profiles",
    "Posts",
    "Following",
    "Messages"
  ];
  List<String> PageTitles = [
    "Woof",
    "Sign Up",
    "Create your profile",
    "Create and Share Posts",
    "Follow Other People",
    "Message Your Friends"
  ];
  List<String> imageURLs = [
    "assets/images/logo_woof.png",
    "assets/images/authentication.png",
    "assets/images/success.png",
    "assets/images/connectionwith.png",
    "assets/images/Connected.png",
    "assets/images/Social_networking.png"
  ];
  List<String> imageCaptions = [
    "An app fit for kings and queens",
    "An easy sign up process",
    "Personalize your Image and Bio!",
    "Share your life",
    "Connect with fellow wolves",
    "Stay connected  "
  ];

  String BRbutton = "Next";
  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Walkthrough Page');
    _setLogEvent();
    print("SCS : Finished Walkthrough succeeded");
  }

  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Walkthrough_Page_Success',
        parameters: <String, dynamic> {
          'name': 'Walkthrough Page',
        }
    );
  }

  void initState() {
    super.initState();
    _setCurrentScreen();
  }
  void nextPage() {
    setState(() {
      if (currentPage == totalPages) {
        Navigator.pushReplacementNamed(context, "/welcome");
      }
      if (currentPage < totalPages) {
        currentPage++;
      }
      if (currentPage == 6) {
        BRbutton = "Leave";
      }
    });
  }

  void prevPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage--;
      }
      if (currentPage < 6) {
        BRbutton = "Next";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.darkpurple,
        centerTitle: true,
        //backgroundColor: Colors ,
        title: Text(
          "${AppbarTitles[currentPage - 1]}",
          style: kAppBarTitleTextStyle,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "${PageTitles[currentPage - 1]}",
              style: kHeadingTextStyle,
            ),
            Image(
              width: 700,
              height: 300,
              image: AssetImage(imageURLs[currentPage - 1]),
            ),
            Center(
              child: Text(
                "${imageCaptions[currentPage - 1]}",
                style: kImageCaptions,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlinedButton(
                  onPressed: prevPage,
                  child: Text(
                    "Prev",
                    style: kLabelLightTextStyle,
                  ),
                ),
                Text("${currentPage} / ${totalPages}"),
                OutlinedButton(
                  onPressed: nextPage,
                  child: Text(
                    "${BRbutton}",
                    style: kLabelLightTextStyle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
