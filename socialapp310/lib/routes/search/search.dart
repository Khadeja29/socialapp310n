import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBauth;
import 'package:flutter/material.dart';
import 'package:socialapp310/models/user1.dart';
import 'package:socialapp310/routes/search/searchTabs.dart';
import 'package:socialapp310/routes/search/searchWidget.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';
import 'package:socialapp310/routes/uploadpic/uploadpic.dart';

final usersRef = FirebaseFirestore.instance.collection('user');

class Search extends StatefulWidget {
  const Search({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  int choiceIdx;
  String query = '';



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

  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .orderBy("Username")
        .where("Username", isGreaterThanOrEqualTo: query.toLowerCase())
        .get();
    setState(() {
      searchResultsFuture =users;
    });
  }

  clearSearch() {
    searchController.clear();
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
        Navigator.pushReplacementNamed(context,'/uploadpic');
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/notifications');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, '/profile');
      } //TODO: if index 3 push notif page, if index 4 push profile page
    });
  }


  PreferredSize buildSearchField(){
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

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(
              Icons.search,
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<Text> searchResults = [];
        snapshot.data.docs.forEach((doc) {
          //FBauth.User user = FBauth.User;
          searchResults.add(Text(doc['Username']));
        });
        return ListView(
          children: searchResults,
        );
      },
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
              children:  <Widget>[
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
  Widget build(BuildContext context) => MaterialApp(
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

  Widget buildProductUser(User1 user){
    if (user.ProfilePic != null){
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
            onTap: () =>_showMyDialog("Todo: Path to this user's page should be added")
          ),
        ),
      );
    }else{
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
            onTap: () => _showMyDialog("Todo: Path to this user's page should be added")
        ),
      );
    }
  }


  Widget userSearchDisplay() {
    FBauth.User currentFB =  FBauth.FirebaseAuth.instance.currentUser;
    if (searchResultsFuture == null)
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
    else{
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
        snapshot.data.docs.forEach((doc) {
          User1 user = User1(username: doc['Username'],
            email: doc['Email'],
            fullName: doc['FullName'],
            isPrivate: doc['IsPrivate'],
            isDeactivated: doc['isDeactivated'],
            bio: doc['Bio'],
            ProfilePic: doc['ProfilePic']);

          if(user.email != currentFB.email){
            searchResults.add(user);
          }else{
            print(user.email);
          }
        });
        int len = 0;

          if (searchResults != null)
            len = searchResults.length;
          if (len > 0) {return ListView.builder(
            itemCount: len,
            // ignore: missing_return
            itemBuilder: (context, index) {
              //final choiceIdx = choice.index;
              if (choiceIdx == 0) {
                if (searchResults[index]
                    .username != null) {
                  final product = searchResults[index];
                  return buildProductUser(product); // buildProductUser(product);
                } else
                  return  Text("no username");
              }
            },
          );
          }else
            return Text("No users were found!");
        }else{
          return CircularProgressIndicator();
        }
      }
      );
    }
  }

  Widget locationSearchDisplay() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          /*StaggeredGridView.countBuilder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            itemCount: searchResultsFuture.length,
            staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
            itemBuilder: (context, index) {
              if (searchResultsFuture
                  .elementAt(index)
                  .loc
                  .loc_name
                  .toLowerCase()
                  .contains(query.toLowerCase())) {
                return Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image(
                      fit: BoxFit.cover,
                      image:
                      AssetImage(searchResultsFuture.elementAt(index).ImageUrlPost),
                    ),
                  ),
                );
              } else
                return Container();
            },
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),*/
        ],
      ),
    );
  }

  Widget postsSearchDisplay() {
    return SingleChildScrollView(
    );
  }
}

class UserResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("User Result");
  }
}