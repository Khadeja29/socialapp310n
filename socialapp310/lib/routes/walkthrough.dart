import 'package:flutter/material.dart';
import 'package:socialapp310/routes/welcome.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:socialapp310/routes/splashpage.dart';
import 'package:socialapp310/routes/login.dart';



class WalkThrough extends StatefulWidget {
  @override
  _WalkThroughState createState() => _WalkThroughState();
}

class _WalkThroughState extends State {

  int currentPage = 1;
  int totalPages = 6;
  List <String> AppbarTitles = ["Hello", "Intro", "Profiles" , "Posts", "Following" , "Messages"];
  List <String> PageTitles = ["Woof", "Sign Up", "Create your profile" , "Create and Share Posts" , "Follow Other People" , "Message Your Friends"];
  List <String> imageURLs = ["assets/images/logo_woof.png", "assets/images/authentication.png", "assets/images/success.png" , "assets/images/connectionwith.png","assets/images/Connected.png","assets/images/Social_networking.png"];
  List <String> imageCaptions = ["An app fit for kings and queens", "An easy sign up process", "Personalize your Image and Bio!" ,"Share your life" ,"Connect with fellow wolves", "Stay connected  "];

  String BRbutton = "Next";
  void nextPage() {

    setState(() {
      if(currentPage == totalPages )
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Welcome()));
      }
      if(currentPage < totalPages)
      {currentPage ++ ;}
      if(currentPage == 6)
      {BRbutton = "Leave";}

    });


  }

  void prevPage() {
    setState(() {
      if(currentPage > 1)
      {currentPage -- ;}
      if(currentPage < 6)
      {BRbutton = "Next";}
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
          children:<Widget> [
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

              children:<Widget> [
                OutlinedButton(
                  onPressed: prevPage,
                  child: Text(
                    "Prev",
                    style: kLabelLightTextStyle,
                  ),),
                Text(
                    "${currentPage} / ${totalPages}"
                ),
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