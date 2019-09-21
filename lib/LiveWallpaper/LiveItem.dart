import 'package:demon_salyer_wallpaper/Wallpaper/LiveWallpaper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:demon_salyer_wallpaper/modals/wallpaper.dart';
import 'package:demon_salyer_wallpaper/modals/wallpapers.dart';
import 'package:demon_salyer_wallpaper/stores/ThemeStore.dart';

class LiveItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LiveItemState();
  }
}

class LiveItemState extends State<LiveItem> {
  List<BTSModal> listData;
  ScrollController controller;
  int page = 1;
  String name = "All";
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    listData = new List<BTSModal>();
    getData();
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      setState(() {
        page++;
      });
      getData();
    }
  }

  Future getData() async {
    var child = await getList(name, page);
    if (child != null && child.length > 0) {
      List<BTSModal> newList = new List<BTSModal>();
      child.forEach((item) {
        BTSModal res = BTSModal.fromJson(item);
        if (res.id != null) {
          newList.add(res);
        }
      });
      setState(() {
        listData..addAll(newList);
        listData.sort((a, b) =>
            DateTime.parse(a.createdAt).compareTo(DateTime.parse(b.createdAt)));
      });
      print("All Sub Comment: ${listData.length}");
    }
    print("---------- $listData");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeStore.themeApp.backGroundColor1,
        centerTitle: true,
        title: new Text(
          "Live Wallpaper",
          style: new TextStyle(
            fontFamily: "Comfortaa",
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(bottom: height / 12),
            padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    themeStore.themeApp.backGroundColor1,
                    themeStore.themeApp.backGroundColor2,
                  ]),
            ),
            child: new StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              controller: controller,
              itemCount: listData.length,
              itemBuilder: (BuildContext context, int index) => new Container(
                      child: Container(
                    width: width / 2,
                    child: GestureDetector(
                      onTap: () {
                        print("-${listData[index].name}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VideoWallpaperPage(
                                    wallpaper: "url anh",
                                    heroId:
                                        "http://api-btswallpaper.babylover.me/photo/all/thumb/${listData[index].name}" +
                                            index.toString(),
                                  )),
                        );
                      },
                      child: Hero(
                        tag:
                            "http://api-btswallpaper.babylover.me/photo/all/thumb/${listData[index].name}" +
                                index.toString(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: new FadeInImage(
                            image: new NetworkImage(
                                "http://api-btswallpaper.babylover.me/photo/all/thumb/${listData[index].name}"),
                            fit: BoxFit.cover,
                            placeholder: new AssetImage(
                              "assets/images/loading.gif",
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 3 : 2),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
          ),
        ],
      ),
    );
  }
}
