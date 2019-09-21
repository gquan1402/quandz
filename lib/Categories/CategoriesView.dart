import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'CategoriesItem.dart';
import 'package:demon_salyer_wallpaper/stores/ThemeStore.dart';

class CategoriesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoriesViewState();
  }
}

class CategoriesViewState extends State<CategoriesView> {
  List<String> images = [];
  List<String> name = [
    "Tanjiro Kamado",
    "Nezuko Kamado",
    "Zenitsu Agatsuma",
    "Inosuke Hashibira",
    "Kanao Tsuyuri",
    "Giyu Tomioka",
    "Shinobu Kochō"
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoriesItem(
                            name: name[index],
                          )),
                );
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: new Container(
                          width: width / 1.1,
                          height: height / 5,
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1.0, 1.0),
                                blurRadius: 5.0,
                                spreadRadius: 0.1)
                          ]),
                          child: new ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: Image.asset(
                              "assets/images/2.jpg",
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  ),
                  new Container(
                    alignment: Alignment.center,
                    height: height / 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          name[index],
                          style: TextStyle(
                            fontFamily: "Robotech",
                            color: Colors.white,
                            fontSize: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
