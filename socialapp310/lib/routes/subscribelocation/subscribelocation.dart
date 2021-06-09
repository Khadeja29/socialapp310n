import 'package:avatar_letter/avatar_letter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialapp310/models/favorites.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialapp310/utils/styles.dart';
import 'noresult.dart';

final postsRef = FirebaseFirestore.instance.collection('Post');
final favouritesRef = FirebaseFirestore.instance.collection('Favorites');


class SubcribeLocation extends StatefulWidget {
  String place_id;
  String address;
  SubcribeLocation({
    Key key,
    this.analytics,
    this.observer,
    this.place_id, this.address
  }) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SubcribeLocationState createState() => _SubcribeLocationState(
      place_id, address
      );
}

class _SubcribeLocationState extends State<SubcribeLocation> {
  Future<QuerySnapshot> searchResultsFuture;
  int _selectedIndex;
  String place_id;
  String address;
  var _getSubbedLocations;
  bool subbed = false;
  List subbedResults = [];
  FBauth.User currentFB = FBauth.FirebaseAuth.instance.currentUser;
  _SubcribeLocationState(this.place_id, this.address);

  Future<QuerySnapshot> getLocationPosts(id) {
    print(id);
    CollectionReference locationsPostCollection =
        FirebaseFirestore.instance.collection('Post');
    return locationsPostCollection
        .where("locationID", isEqualTo: place_id)
        .where("IsPrivate", isEqualTo: false)
        .get();
  }

  Future<DocumentSnapshot> getLocation() {
    CollectionReference locationsCollection =
        FirebaseFirestore.instance.collection('Locations');
    return locationsCollection.doc(place_id).get();
  }

  Future<bool> getSubbedLocations(place_id) async {
    // User currentFB = FirebaseAuth.instance.currentUser;
    CollectionReference subbedLocationsCollection =
        FirebaseFirestore.instance.collection('subbedLocations');
    var x = await subbedLocationsCollection
        .where("LocationId", isEqualTo: place_id)
        //.where("UserId", isEqualTo: currentFB.uid)
        .get();
    if(x != null)
      for(var y in x.docs) {
        subbedResults.add(y);
      }

    print(subbedResults.length);
    if (subbedResults.length > 0) {
      setState(() {
        subbed = true;
      });
    } else
      setState(() {
        subbed = false;
      });

    return subbed;
  }

  Future<dynamic> addSubscription() {
    CollectionReference subbedLocationsCollection =
        FirebaseFirestore.instance.collection('subbedLocations');
    return subbedLocationsCollection.add({
      "LocationId": place_id,
      "UserId": currentFB.uid,
      "address": address,
    });
  }

  Future<dynamic> deleteSubscription() {

    var query = FirebaseFirestore.instance
        .collection('subbedLocations')
        .where("LocationId", isEqualTo: place_id)
        .where("UserId", isEqualTo: currentFB.uid);
    print('delete');
    query.get().then((querySnapshot) {
      querySnapshot.docs.first.reference.delete();
      print('delete');
      subbed = false;
    });
  }

  @override
  void initState() {
    print(subbed);
    getSubbedLocations(place_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _setLogEvent() async {
      await widget.analytics.logEvent(
          name: 'SubscribeLocation_Page_Success',
          parameters: <String, dynamic>{
            'name': 'SubscribeLocation Page',
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkpurple,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Column(children: [
        Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 30, 10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AvatarLetter(
                        size: 100,
                        backgroundColor: AppColors.darkgrey,
                        textColor: AppColors.peachpink,
                        fontSize: 50,
                        upperCase: true,
                        numberLetters: 1,
                        letterType: LetterType.Circular,
                        text: '$address',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$address', style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),),
                      Visibility(
                        visible: subbed == true ? true : false,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  deleteSubscription();
                                  subbed = false;
                                });
                              },
                              child: Container(
                                width: 200.0,
                                height: 27.0,
                                child: Text(
                                  'Subscribed',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.darkpurple,
                                  border: Border.all(
                                    color: AppColors.darkpurple,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                  Visibility(
                    visible: subbed == false ? true : false,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              addSubscription();
                              subbed = true;
                            });
                          },
                          child: Container(
                            width: 200.0,
                            height: 27.0,
                            child: Text(
                              'Unsubscribed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.peachpink,
                              border: Border.all(
                                color: AppColors.peachpink,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
        FutureBuilder(
            future: getLocationPosts(place_id),
            // Future.wait([getLocationPosts(place_id), getSubbedLocations(place_id)]),
            builder: (context, snapshot) {
              List searchResults = [];
              // List subbedResults = [];
              Post fav;
              bool subbed = false;
              print('here');
              if(snapshot.data != null)
                snapshot.data.docs.forEach((doc) {
                  fav = Post(ImageUrlPost: doc["Image"]);
                  searchResults.add(fav);
                });
              
              if (snapshot.hasError) {
                return Text('There was an error :(');
              } else if (searchResults.length == 0) {
                return Container(
                    child: Expanded(
                      child: Center(
                        child: Image.asset('assets/images/images.png', height:500, width:500)
                ),
                    ));
              } else if (snapshot.hasData && searchResults.length != 0) {
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
                                // onTap: () {
                                //   Navigator.push(context, MaterialPageRoute(builder: (_) {
                                //     return SinglePost(
                                //       PostId: searchResults[index].PostId,);
                                //   }));
                                // },
                                child: Image(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      searchResults[index].ImageUrlPost),
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
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(),
                      height: 20,
                      width: 20,
                    ),
                  ],
                );
              }
            }),
      ]),
    );
  }
}
