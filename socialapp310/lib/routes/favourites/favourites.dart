import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialapp310/models/favorites.dart';
import 'package:socialapp310/routes/profile/PostScreen.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp310/utils/styles.dart';

final postsRef = FirebaseFirestore.instance.collection('Post');
final favouritesRef = FirebaseFirestore.instance.collection('Favorites');
FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;

class Favourites extends StatefulWidget {
  Favourites({Key key, this.analytics, this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favourites> {
  Future<QuerySnapshot> searchResultsFuture;
  int _selectedIndex;
  List<Favorites> searchResults = [];
  Future<QuerySnapshot> getFavInfo() async {
    //Call the user's CollectionReference to add a new user
    User currentFB = FirebaseAuth.instance.currentUser;
    CollectionReference FavCollection =
        FirebaseFirestore.instance.collection('Favorites');
    var results = await FavCollection.where("UserId", isEqualTo: currentFB.uid).get();

    List<Favorites> _searchResults = [];
    Favorites fav;
    for (var doc in results.docs) {
      fav = Favorites(
          Image: doc["Image"],
          UserId: doc["UserId"],
          PostId: doc["PostId"]);

      if(await PostIdExists(doc["PostId"]))
      {
        _searchResults.add(fav);
      }
      else {
        FavCollection.doc(doc.id).delete();
      }
  }
    setState(() {
      searchResults = _searchResults;
    });
    return results;
  }

  @override
  void initState() {
    super.initState();
    searchResultsFuture = getFavInfo();
  }

  Future<bool> PostIdExists(String postID) async
  {
    bool exists = false;
    var result = await getpostRef.doc(postID).get().then((value) => exists = value.exists);
    return exists;
  }
  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex =
          index; //TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, '/homefeed');
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, '/search');
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/notifications');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, '/profile');
      } //TODO: if index 3 push notif page, if index 4 push profile page
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _setLogEvent() async {
      await widget.analytics.logEvent(
          name: 'Favourites_Page_Success',
          parameters: <String, dynamic>{
            'name': 'Favourites Page',
          });
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Favourites',
            style: kAppBarTitleTextStyle,
          ),
          backgroundColor: AppColors.darkpurple,
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          ),
      ),
      body: FutureBuilder(
          future: searchResultsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('There was an error :(');
            }
            else if (snapshot.hasData ) {
              if(snapshot.data.docs != [])
              {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(0),
                              child: GestureDetector(
                                onTap: () async {
                                  var UserId = await getpostRef.doc(searchResults[index].PostId).get();
                                  Navigator.push(context, MaterialPageRoute<void>(
                                      builder: (BuildContext context) => PostScreen(postId: searchResults[index].PostId,userId: UserId.get("PostUser"),index: 100,)));
                                },
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(searchResults[index].Image),
                                ),
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) =>
                            StaggeredTile.count(1, 1),
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                    ],
                  ),
                );
              }
              else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.primarypurple)),
                  ),
                );
              }
            }
            else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          AppColors.primarypurple)),
                ),
              );
            }
          }),
    );
  }
}
