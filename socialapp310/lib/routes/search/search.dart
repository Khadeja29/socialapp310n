import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:socialapp310/main.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/models/user1.dart';
import 'package:socialapp310/routes/profile/PostScreen.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/routes/search/searchTabs.dart';
import 'package:socialapp310/routes/search/searchWidget.dart';
import 'package:socialapp310/routes/subscribelocation/subscribelocation.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';
import 'package:socialapp310/routes/uploadpic/uploadpic.dart';
import 'package:http/http.dart' as http;

final usersRef = FirebaseFirestore.instance.collection('user');
final postsRef = FirebaseFirestore.instance.collection('Post');


class Search extends StatefulWidget {
  const Search({Key key, this.analytics, this.observer, this.imageFile}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final File imageFile;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FBauth.User currentFB =  FBauth.FirebaseAuth.instance.currentUser;
  double lat=0;
  double long=0;
  String locationname, locationMessage, placeId, placeName;
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture, searchResultsCaptionFuture,
      searchResultsLocationFuture;
  String query = '', queryY = '';
  String mapKey = 'AIzaSyD0fvZRggBM27RQzg6oxAcpWidUzQ_vB1k';
  int choiceIdx = 0;
  File imageFile;

  _SearchState();

  Future<void> _setCurrentScreen() async {
    await widget.analytics.setCurrentScreen(screenName: 'Search Page');
    _setLogEvent();
    print("SCS : Search Page succeeded");
  }

  Future<void> _setLogEvent() async {
    await widget.analytics.logEvent(
        name: 'Search_Page_Success',
        parameters: <String, dynamic>{
          'name': 'Search Page',
        }
    );
  }
  Map<String, dynamic> res;
  String hintText = 'Search Location';
  ValueChanged<String> onChanged;

  Future<void> locationfinder(String address, String placeID) async {
    print(placeID);
    placeName = address;
    var locations =  await locationFromAddress(address);
    lat=(locations[0].latitude);
    long=(locations[0].longitude);
    final coordinates = new Coordinates(lat, long);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    //print("${first.featureName} : ${first.addressLine}");
    locationname = ("${first.featureName} : ${first.addressLine}");
    //TODO: IFRU'S CODE HERE user placeID and placeName
   Navigator.push(context, MaterialPageRoute<void>(
     builder:(BuildContext context) =>
         SubcribeLocation(analytics: AppBase.analytics, observer: AppBase.observer, place_id: placeID, address: placeName ),
    ),);

    // Navigator.push(context, MaterialPageRoute<void>(
    // builder: (BuildContext context) =>  LocationSubscription(analytics: AppBase.analytics, observer: AppBase.observer, lat: lat,long: long,locationname:locationname,imageFile: imageFile, ),
    //),);
  }
  Future<dynamic> findPlace(String placeName) async {
    // print('here');
    // print(placeName);
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      return res;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Stream<dynamic> getFindView(place) async* {
    //await Future.delayed(Duration(seconds: 1));
    yield await findPlace(place);
  }

  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .orderBy("Username")
        .where("Username", isGreaterThanOrEqualTo: query.toLowerCase())
        .get();
    print("hello");
    Future<QuerySnapshot> posts = postsRef
        .orderBy("Caption")
        .where("Caption", isNotEqualTo: "")
        .get();

    setState(() {
      searchResultsCaptionFuture = posts;
      searchResultsFuture = users;
      queryY = query;
    });
  }



  @override
  void initState() {
    super.initState();

    _setCurrentScreen();
    choiceIdx = 0;
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      print(index);
      _selectedIndex =
          index; //TODO: if index 0 nothing happens, if index 1 push search page, if index 2 push create page,
      if (_selectedIndex == 0) {
        Navigator.pushReplacementNamed(context, '/homefeed');
      } else if (_selectedIndex == 1) {
        Navigator.pushReplacementNamed(context, '/search');
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacementNamed(context, '/uploadpic');
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/notifications');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, '/profile');
      } //TODO: if index 3 push notif page, if index 4 push profile page
    });
  }


  PreferredSize buildSearchField() {
    return new PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + kToolbarHeight),
      child: new Container(
        color: AppColors.darkpurple,
        child: new SafeArea(
          child: Column(
            children: <Widget>[
              SearchWidget(
                text: query,
                hintText: 'Search...',
                onChanged: handleSearch,
              ),
              new TabBar(
                isScrollable: true,
                indicatorColor: AppColors.peachpink,
                tabs: choices.map<Widget>((Choice choice) {
                  return new Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: new Tab(
                      text: choice.title,
                      //icon: Icon(choice.icon),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        home: DefaultTabController(
          length: choices.length,
          child: Scaffold(
            appBar: buildSearchField(),
            body: TabBarView(children: [
              userSearchDisplay(),
              locationSearchDisplay(),
              postsSearchDisplay(),
            ]),
            bottomNavigationBar: BottomNavigationBar(
              iconSize: 30,
              backgroundColor: AppColors.darkpurple,
              selectedItemColor: AppColors.peachpink,
              unselectedItemColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: "Search"),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: "Create"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border_outlined),
                    label: "Notifications"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile"),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ),
      );

  Widget buildProductUser(User1 user) {
    if (user.ProfilePic != null) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              leading: Image.network(
                user.ProfilePic,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
              title: Text(user.username),
              subtitle: Text(user.fullName),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) =>  ProfileScreen(analytics: AppBase.analytics, observer: AppBase.observer, UID: user.UID, index: 1),
                ),)
              }
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            leading:
            Image(
              image: AssetImage('assets/images/logo_woof.png'),
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
            title: Text(user.username),
            subtitle: Text(user.fullName),
            onTap: () =>
                _showMyDialog("Todo: Path to this user's page should be added")
        ),
      );
    }
  }


  Widget userSearchDisplay() {
    if (searchResultsFuture == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Image(
                image: AssetImage('assets/images/logo_woof.png'),
                height: 200,
                width: 200,
              ),
            ),
          ),
          //Text("No users were found",),
        ],
      );
    }
    else {
      return FutureBuilder(
          future: searchResultsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                  'There was an error :('
              );
            }
            else if (snapshot.hasData) {
              List<User1> searchResults = [];

              for(var doc in snapshot.data.docs)
              {
                User1 user = User1(
                    UID: doc.id,
                    username: doc['Username'],
                    email: doc['Email'],
                    fullName: doc['FullName'],
                    isPrivate: doc['IsPrivate'],
                    isDeactivated: doc['isDeactivated'],
                    bio: doc['Bio'],
                    ProfilePic: doc['ProfilePic']);

                 if(user.email != currentFB.email){
                   searchResults.add(user);
                }else{
                  print("hello" + user.email);
                  print(doc["Email"]);
                }
              }
              int len = 0;

              if (searchResults != null)
                len = searchResults.length;
              if (len > 0) {
                return ListView.builder(
                  itemCount: len,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    //final choiceIdx = choice.index;
                    if (searchResults[index]
                        .username != null) {
                      final product = searchResults[index];


                      return buildProductUser(
                          product); // buildProductUser(product);
                    } else
                      return Text("no username");
                  },
                );
              } else
                return Text("No users were found!");
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(child: CircularProgressIndicator(),
                    height: 20,
                    width: 20,),
                ],
              );
            }
          }
      );
    }
  }

  Widget locationSearchDisplay() {
    print(choiceIdx);
    if (searchResultsCaptionFuture == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Image(
                image: AssetImage('assets/images/logo_woof.png'),
                height: 200,
                width: 200,
              ),
            ),
          ),
          //Text("No users were found",),
        ],
      );
    } else {
      return
        FutureBuilder(
            future: findPlace(queryY),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('There was an error :(');
              } else if (snapshot.hasData || snapshot.data == null) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(),
                        child: ListView.builder(
                          itemCount:
                          snapshot.data == null ? 0 : snapshot.data["predictions"].length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title:
                                  Text(snapshot.data["predictions"][index]["description"]),
                                  leading: Icon(Icons.add_location_alt, color: AppColors.darkgreyblack,),
                                  onTap:() {
                                    placeId = snapshot.data["predictions"][index]['place_id'];
                                    print('this is '+placeId);
                                    locationfinder(snapshot.data["predictions"][index]["description"], placeId);
                                  },
                                ),
                              ),
                              //Divider(color: Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // print(snapshot.data);
                return (Center(
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.darkpurple))));
              }
            });
    }  }

  Widget postsSearchDisplay() {
    print(choiceIdx);
    if (searchResultsCaptionFuture == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Image(
                image: AssetImage('assets/images/logo_woof.png'),
                height: 200,
                width: 200,
              ),
            ),
          ),
          //Text("No users were found",),
        ],
      );
    } else {
      return FutureBuilder(
          future: searchResultsCaptionFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                  'There was an error :('
              );
            }
            else if (snapshot.hasData) {
              List<Post> searchResultsPosts = [];
              snapshot.data.docs.forEach((doc) {
                String cap = doc['Caption'];
                if(cap.contains(queryY) || cap.contains(queryY.toLowerCase()) ||  cap.contains(queryY.toUpperCase())){
                  Post post = Post(
                    userId: doc['PostUser'],
                    ImageUrlPost: doc['Image'],
                    caption: doc['Caption'],
                    likes: doc['Likes'],
                    comment: doc['Comment'],
                    location: doc['Location'],
                    createdAt: doc['createdAt'],
                    IsPrivate: doc['IsPrivate'],
                    PostID: doc.id,
                  );
                  if (post.userId != currentFB.uid && post.IsPrivate == false ) {
                    searchResultsPosts.add(post);
                  } else {
                    print(post.userId);
                  }
                }
              });
              int pNum = 0;

              if (searchResultsPosts != null)
                pNum = searchResultsPosts.length;
              if (pNum > 0) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        itemCount: pNum,
                        staggeredTileBuilder: (index) =>
                            StaggeredTile.count(1, 1),
                        itemBuilder: (context, index) {
                          if (searchResultsPosts
                              .elementAt(index)
                              .caption != null) {
                            return Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap:(){ Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostScreen(
                                      postId: searchResultsPosts
                                          .elementAt(index).PostID,
                                      userId: searchResultsPosts
                                          .elementAt(index).userId,
                                      index: 101,

                                    ),
                                  ),
                                );},
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Image.network(
                                    searchResultsPosts
                                        .elementAt(index)
                                        .ImageUrlPost,
                                    fit: BoxFit.cover,

                                  ),
                                  /*Text( (searchResultsPosts
                                            .elementAt(index).caption.length < 15) ? searchResultsPosts
                                            .elementAt(index).caption.substring(0,searchResultsPosts
                                            .elementAt(index).caption.length-1 )+"..." : searchResultsPosts
                                            .elementAt(index).caption.substring(0, 3)+"...",
                                        textAlign: TextAlign.left,)*/
                                ),
                              ),
                            );
                          } else
                            return Container();
                        },
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
                      child:
                      Text("No Posts were found!"),
                    ),
                  ],
                );
              }
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(child: CircularProgressIndicator(),
                    height: 20,
                    width: 20,),
                ],
              );
            }
          }
      );
    }
  }
}
class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}

class PassingUID {
  final String UID;
  PassingUID(this.UID);
}