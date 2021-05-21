import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/models/post.dart';
import 'package:socialapp310/routes/search/searchTabs.dart';
import 'package:socialapp310/routes/search/searchWidget.dart';
import 'package:socialapp310/utils/color.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialapp310/routes/uploadpic/createpost.dart';
import 'package:socialapp310/routes/uploadpic/uploadpic.dart';

class Search extends StatefulWidget {
  const Search({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  searchState createState() => searchState();
}

class searchState extends State<Search> {
  List<Post> post_list = [];
  int choiceIdx;
  String query = '';

  searchState();
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
  @override
  void initState() {
    super.initState();
    _setCurrentScreen();
    post_list = posts;
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
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Uploadpic()));
      } else if (_selectedIndex == 3) {
        Navigator.pushReplacementNamed(context, '/notifications');
      } else if (_selectedIndex == 4) {
        Navigator.pushReplacementNamed(context, '/profile');
      } //TODO: if index 3 push notif page, if index 4 push profile page
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: DefaultTabController(
          length: choices.length,
          child: Scaffold(
            appBar: new PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight + kToolbarHeight),
              child: new Container(
                color: AppColors.darkpurple,
                child: new SafeArea(
                  child: Column(
                    children: <Widget>[
                      buildSearch(),
                      new TabBar(
                        isScrollable: true,
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
            ),
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

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search...',
        onChanged: searchProduct,
      );

  Widget buildProductUser(Post post) => ListTile(
        leading: Image(
          image: AssetImage(post.ImageUrlAvatar),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(post.username),
      );

  Widget userSearchDisplay() {
    return ListView.builder(
      itemCount: post_list.length,
      // ignore: missing_return
      itemBuilder: (context, index) {
        //final choiceIdx = choice.index;
        if (choiceIdx == 0) {
          if (post_list[index]
              .username
              .toLowerCase()
              .contains(query.toLowerCase())) {
            final product = post_list[index];
            return buildProductUser(product);
          } else
            return Container();
        }
      },
    );
  }

  Widget locationSearchDisplay() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StaggeredGridView.countBuilder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            itemCount: post_list.length,
            staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
            itemBuilder: (context, index) {
              if (post_list
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
                          AssetImage(post_list.elementAt(index).ImageUrlPost),
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
  }

  Widget postsSearchDisplay() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          StaggeredGridView.countBuilder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            itemCount: post_list.length,
            staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
            itemBuilder: (context, index) {
              if (post_list
                  .elementAt(index)
                  .caption
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
                          AssetImage(post_list.elementAt(index).ImageUrlPost),
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
  }

  void searchProduct(String query) {
    if (query.length == 0) {
      print(query.length);
      final postsAll = [];
      setState(() {
        this.query = query;
        this.post_list = postsAll;
      });
    } else {
      final postsAll = posts.where((post) {
        final usernameLower = post.username.toLowerCase();
        final locationLower = post.loc.loc_name.toLowerCase();
        final postsLower = post.caption.toLowerCase();
        final searchLower = query.toLowerCase();
        return usernameLower.contains(searchLower) ||
            locationLower.contains(searchLower) ||
            postsLower.contains(searchLower);
      }).toList();

      setState(() {
        this.query = query;
        this.post_list = postsAll;
      });
    }
  }
}
