import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:expanding_bottom_bar/expanding_bottom_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/services.dart';
import 'HomeView/HomeView.dart';
import 'Features/FeaturesView.dart';
import 'Categories/CategoriesView.dart';
import 'Favorite/FavoriteView.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'Curved_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:demon_salyer_wallpaper/stores/ThemeStore.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

const platform = const MethodChannel('com.liveWallpaper');

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: HomeNavigator(),
    );
  }
}

class DialogContent extends StatefulWidget {
  var callBack;

  DialogContent(this.callBack);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DialogContentState();
  }
}

class DialogContentState extends State<DialogContent> {
  SharedPreferences prefs;
  String theme;

  Future<bool> setTheme(key) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", key);
    themeStore.setTheme(theme);
    widget.callBack();
    return await prefs.setString("theme", key);
  }

  Future<void> getTheme() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      theme = prefs.getString("theme");
      if (theme == null) {
        theme = "default";
      }
    });
    themeStore.setTheme(theme);

//    setState(() {
//      list = prefs.getStringList(key);
//      listTime = prefs.getStringList(key + "Time");
//      if (list == null) {
//        list = new List();
//      }
//      countItem = list.length;
//    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeStore.getListData();
    print("âsasasasasa");
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(width / 15))),
      backgroundColor: themeStore.themeApp.backGroundColor1,
      title: new Column(
        children: <Widget>[
          new Center(
            child: new Text(
              "Change theme",
              style: TextStyle(color: Colors.white),
            ),
          ),
          new SizedBox(
            height: height / 30,
          ),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new GestureDetector(
                  onTap: () {
                    setTheme("pink");
                    getTheme();
                  },
                  child: new Container(
                    decoration: BoxDecoration(
                      border: theme == "pink"
                          ? Border.all(width: 2, color: Colors.white)
                          : Border.all(width: 0),
                      borderRadius:
                          BorderRadius.all(Radius.circular(width / 20)),
                      color: Color(0xffEE9A92),
                    ),
                    width: width / 10,
                    height: width / 10,
                  )),
              new SizedBox(
                width: width / 30,
              ),
              new GestureDetector(
                  onTap: () {
                    setTheme("blue");

                    getTheme();
                  },
                  child: new Container(
                    decoration: BoxDecoration(
                      border: theme == "blue"
                          ? Border.all(width: 2, color: Colors.white)
                          : Border.all(width: 0),
                      borderRadius:
                          BorderRadius.all(Radius.circular(width / 20)),
                      color: Color(0xffa1c4fd),
                    ),
                    width: width / 10,
                    height: width / 10,
                  )),
              new SizedBox(
                width: width / 30,
              ),
              new GestureDetector(
                  onTap: () {
                    setTheme("default");
                    getTheme();
                  },
                  child: new Container(
                    decoration: BoxDecoration(
                      border: theme == "default"
                          ? Border.all(width: 2, color: Colors.white)
                          : Border.all(width: 0),
                      borderRadius:
                          BorderRadius.all(Radius.circular(width / 20)),
                      color: Colors.black,
                    ),
                    width: width / 10,
                    height: width / 10,
                  ))
            ],
          )
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
      ],
    );
  }
}

class ThemeApp {
  Color backGroundColor1 = Color(0xff212121);
  Color backGroundColor2 = Color(0xff212121);
  Color tabBarColor = Colors.black;
  Color iconTabBarColor = Colors.white;
  Color textColor = Colors.white;
}

class HomeNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeNavigatorState();
  }
}

class HomeNavigatorState extends State<HomeNavigator> {
  PageController pageController = PageController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  var pageIndex = 0;
  String theme;

  bool render = true;
  SharedPreferences prefs;
  var timer;

  Future<void> getTheme() async {
    prefs = await SharedPreferences.getInstance();
    String colorTheme = await prefs.getString("theme");
    setState(() {
      theme = colorTheme;
      if (theme == null) {
        theme = "default";
      }
    });
    themeStore.setTheme(colorTheme);
    setState(() {
      render = !render;
    });
  }

  Drawer _buildDrawer(context, width, height) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            color: themeStore.themeApp.backGroundColor1,
            child: Center(
                child: Container(
              color: themeStore.themeApp.backGroundColor1,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  "assets/images/kimetsunoyaibawallpaper.png",
                  width: width / 3,
                  height: width / 3,
                ),
              ),
            )),
          ),
          new Container(
            height: height,
            color: themeStore.themeApp.backGroundColor1,
            child: new Column(
              children: <Widget>[
//                new SizedBox(
//                  height: height / 50,
//                ),
//                new Container(
//                    width: width / 3.5,
//                    child: new ClipRRect(
//                      child: new Image.asset(
//                        'assets/Logo/Logo_500x500.png',
//                        width: width / 3,
//                      ),
//                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                    )),
                new SizedBox(
                  height: height / 100,
                ),
                new Container(
                  child: new Text(
                    "BTS WALLPAPERS",
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Comfortaa'),
                  ),
                ),
                new Divider(
                  color: Colors.white,
                  indent: 0.0,
                ),
                new GestureDetector(
                  onTap: () {
                    _showDialog(width, height);
                  },
                  child: new Container(
                    color: themeStore.themeApp.backGroundColor1,
                    height: height / 12,
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          width: width / 6,
                          child: new Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                        new Text(
                          "Change Theme",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Comfortaa'),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      platform.invokeMethod('rate');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Image.asset(
                            "assets/images/ic_rating.png",
                            width: width / 10,
                            height: width / 10,
                          ),
                        ),
                        Container(
                          child: Text(
                            "Rating",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Comfortaa'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: GestureDetector(
                    onTap: () {
                      platform.invokeMethod('moreApp');
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Image.asset(
                            "assets/images/ic_more.png",
                            width: width / 10,
                            height: width / 10,
                          ),
                        ),
                        Container(
                          child: Text(
                            "More App",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Comfortaa'),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void showBackApp(width, height) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(width / 15))),
            backgroundColor: themeStore.themeApp.backGroundColor1,
            title: new Column(
              children: <Widget>[
                new Center(
                  child: new Text(
                    "Are you sure to exit?",
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Comfortaa'),
                  ),
                ),
                new SizedBox(
                  height: height / 30,
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new GestureDetector(
                        onTap: () {
                          exit(0);
                        },
                        child: new Container(
                          child: Text(
                            "Yes",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Comfortaa'),
                          ),
                        )),
                    new SizedBox(
                      width: width / 30,
                    ),
                    new GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: new Container(
                          child: Text(
                            "No",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Comfortaa'),
                          ),
                        )),
                  ],
                ),
                new SizedBox(
                  height: height / 30,
                ),
                Container(
                    child: GestureDetector(
                  onTap: () {
                    platform.invokeMethod('btsloveme');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "BTS Love Me?",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Comfortaa'),
                      ),
                      new SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        "assets/images/btsloveme.png",
                        width: 100,
                        height: 100,
                      )
                    ],
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
            ],
          );
        });
  }

  void renderScreen() {
    setState(() {
      render = !render;
    });
  }

  void _showDialog(width, height) {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return DialogContent(renderScreen);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheme();
//    rateApp();
  }

//  rateApp() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var check = await prefs.getBool("rated");
//    if(check == null || !check){
//      timer = Timer(Duration(seconds: 10), () async {
//        var res = await platform.invokeMethod('showRate');
//        await prefs.setBool('rate', res);
//      });
//    }
//  }

  @override
  void dispose() {
//    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context, width, height),
      appBar: AppBar(
//        gradient:
//        LinearGradient(colors: [ Color(0xffE4798D),Color(0xffEE9A92),]),
        backgroundColor: themeStore.themeApp.backGroundColor1,
        centerTitle: true,
        title: new Text(
          "BTS Wallpaper",
          style: new TextStyle(
            fontFamily: "Comfortaa",
          ),
        ),
      ),
      body: WillPopScope(
          child: Container(
            child: PageView(
                physics: BouncingScrollPhysics(),
                controller: pageController,
                onPageChanged: onPageChanged,
                children: <Widget>[
                  HomeView(),
                  CategoriesView(),
                  FavoriteView(),
                ]),
          ),
          onWillPop: () {
            showBackApp(width, height);
          }),
//            bottomNavigationBar: BottomNavyBar(
//
//              backgroundColor: Colors.pinkAccent,
//              selectedIndex: pageIndex,
//              showElevation: true, // use this to remove appBar's elevation
//              onItemSelected: (index) => setState(() {
//                pageIndex = index;
//                pageController.animateToPage(index,
//                    duration: Duration(milliseconds: 300), curve: Curves.ease);
//              }),
//              items: [
//
//                BottomNavyBarItem(
//                  icon: Icon(Icons.apps),
//                  title: Text('Home'),
//                  activeColor: Colors.white,
//
//                ),
//                BottomNavyBarItem(
//                    icon: Icon(Icons.person),
//                    title: Text('OPPA!'),
//                    activeColor: Colors.white
//                ),
//                BottomNavyBarItem(
//                    icon: Icon(Icons.favorite),
//                    title: Text('Favorite'),
//                    activeColor: Colors.white
//                ),
//                BottomNavyBarItem(
//                    icon: Icon(Icons.border_color),
//                    title: Text('Features'),
//                    activeColor: Colors.white
//                ),
//              ],
//            )
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: themeStore.themeApp.backGroundColor1,
        color: themeStore.themeApp.tabBarColor,
        height: 50,
        index: pageIndex,
        items: <Widget>[
          Icon(
            Icons.apps,
            size: 30,
            color: Colors.white,
          ),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          //Handle button tap
          pageIndex = index;
          pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
      ),
//          bottomNavigationBar: ExpandingBottomBar(
//            backgroundColor: Colors.pink,
//            navBarHeight: 60.0,
//            items: [
//
//              ExpandingBottomBarItem(
//
//                icon: Icons.home,
//                text: "Home",
//                  selectedColor: Colors.white
//
//              ),
//              ExpandingBottomBarItem(
//                icon: Icons.category,
//                text: "Categories",
//                  selectedColor: Colors.white
//              ),
//
//              ExpandingBottomBarItem(
//                  icon: Icons.favorite,
//                  text: "Favourite",
//                  selectedColor: Colors.white
//              ),
//              ExpandingBottomBarItem(
//                  icon: Icons.settings,
//                  text: "Features",
//
//                  selectedColor: Colors.white
//              ),
//            ],
//            selectedIndex: pageIndex,
//            onIndexChanged: navigationTapped,
//          ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      pageIndex = value;
    });
  }
}
