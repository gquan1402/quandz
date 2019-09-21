import 'package:demon_salyer_wallpaper/LiveWallpaper/LiveItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:math';
import 'package:demon_salyer_wallpaper/Wallpaper/Wallpaper.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:demon_salyer_wallpaper/Categories/CategoriesItem.dart';
import 'package:demon_salyer_wallpaper/stores/ThemeStore.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeViewState();
  }
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class HomeViewState extends State<HomeView> {
  var currentPage = 10 - 1.0;
  void initState() {
    super.initState();
    themeStore.getListData();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 10 - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //       begin: Alignment.bottomCenter,
      //       end: Alignment.topCenter,
      //       colors: [
      //         themeStore.themeApp.backGroundColor1,
      //         themeStore.themeApp.backGroundColor2
      //       ]),
      // ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: new SafeArea(
        child: themeStore.listData.length > 0
            ? new Container(
                child: new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Text(
                    //         "Fan Art",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 25.0,
                    //           fontFamily: "Calibre-Semibold",
                    //           letterSpacing: 1.0,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //       IconButton(
                    //         icon: Icon(
                    //           Icons.more_horiz,
                    //           size: 25.0,
                    //           color: Colors.white,
                    //         ),
                    //         onPressed: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => CategoriesItem(
                    //                     name: "FanArt",
                    //                     nameidol: "fanart",
                    //                   ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // new Container(
                    //   width: width,
                    //   height: width / 2,
                    //   child: new Swiper(
                    //     autoplay: true,
                    //     autoplayDelay: 3000,

                    //     itemBuilder: (BuildContext context, int index) {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => WallpaperPage(
                    //                     heroId:
                    //                         "assets/images/fanart/${index + 1}.jpg" +
                    //                             index.toString(),
                    //                     status: "offline",
                    //                     wallpaper:
                    //                         "assets/images/fanart/${index + 1}.jpg",
                    //                   ),
                    //             ),
                    //           );
                    //         },
                    //         child: Hero(
                    //           tag: 'assets/images/fanart/${index + 1}.jpg' +
                    //               index.toString(),
                    //           child: new ClipRRect(
                    //             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //             child: new Container(
                    //               margin: EdgeInsets.all(10.0),
                    //               decoration: BoxDecoration(boxShadow: [
                    //                 BoxShadow(
                    //                     color: Colors.black26,
                    //                     offset: Offset(1.0, 1.0),
                    //                     blurRadius: 5.0,
                    //                     spreadRadius: 0.1)
                    //               ]),
                    //               child: new ClipRRect(
                    //                 borderRadius:
                    //                     BorderRadius.all(Radius.circular(10.0)),
                    //                 child: Image.asset(
                    //                   'assets/images/fanart/${index + 1}.jpg',
                    //                   fit: BoxFit.cover,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //     itemCount: 7,
                    //     loop: true,
                    //     pagination: null,
                    //     control: null,
                    //     viewportFraction: 0.7,
                    //     scale: 0.9,

                    //     layout: SwiperLayout.DEFAULT,
                    //     //                      onIndexChanged: (int index) {
                    //     //                        setState(() {
                    //     //                          ic_name = listName[index];
                    //     //                        });
                    //     //                      },
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Trending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontFamily: "Calibre-Semibold",
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              size: 25.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoriesItem(
                                          name: "All",
                                        )),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        CardScrollWidget(currentPage),
                        Positioned.fill(
                          child: PageView.builder(
                            itemCount: 10,
                            controller: controller,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WallpaperPage(
                                            heroId:
                                                themeStore.listData[index].name,
                                            wallpaper:
                                                "http://api-btswallpaper.babylover.me/photo/all/full/${themeStore.listData[index].name}",
                                          ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Popular",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontFamily: "Calibre-Semibold",
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              size: 25.0,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoriesItem(
                                          name: "All",
                                        )),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Popular(),
                  ],
                ),
              )
            : Container(
                width: width,
                height: height,
                child: Text("No Data!",
                    style: TextStyle(color: Colors.white, fontSize: 50.0)),
              ),
      ),
    ));
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 1; i <= 10; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Hero(
                    tag:
                        "http://api-btswallpaper.babylover.me/photo/all/thumb/${themeStore.listData[i].name}",
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: new FadeInImage(
                            image: new NetworkImage(
                                "http://api-btswallpaper.babylover.me/photo/all/thumb/${themeStore.listData[i].name}"),
                            fit: BoxFit.cover,
                            placeholder: new AssetImage(
                              "assets/images/loading.gif",
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text("Kimetsu No Yaiba",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontFamily: "SF-Pro-Text-Regular")),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}

class Popular extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PopularState();
  }
}

class PopularState extends State<Popular> {
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WallpaperPage(
                        heroId: themeStore.listData[index + 10].name,
                        wallpaper:
                            "http://api-btswallpaper.babylover.me/photo/all/full/${themeStore.listData[index].name}",
                      )),
            );
          },
          child: Hero(
            tag:
                "http://api-btswallpaper.babylover.me/photo/all/thumb/${themeStore.listData[index + 10].name}" +
                    index.toString(),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: new ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: new Container(
                        width: width / 1.1,
                        height: height / 4,
                        margin: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 5.0,
                              spreadRadius: 0.1)
                        ]),
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: new FadeInImage(
                            image: new NetworkImage(
                                "http://api-btswallpaper.babylover.me/photo/all/thumb/${themeStore.listData[index + 10].name}"),
                            fit: BoxFit.cover,
                            placeholder: new AssetImage(
                              "assets/images/loading.gif",
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
