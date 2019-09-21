import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:demon_salyer_wallpaper/Wallpaper/Wallpaper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:demon_salyer_wallpaper/stores/ThemeStore.dart';

class FavoriteView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FavoriteViewState();
  }
}

class FavoriteViewState extends State<FavoriteView> {
  SharedPreferences prefs;
  List<String> liked = new List();
  int countItem = 0;
  Future<void> getListFavorite() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      liked = prefs.getStringList("like");

      if (liked == null) {
        liked = new List();
      }
      countItem = liked.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getListFavorite();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: new Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Container(
          child: new StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: countItem,
            itemBuilder: (BuildContext context, int index) => new Container(
                    child: Container(
                  width: width / 2,
                  child: GestureDetector(
                    onTap: () {
                      String heroId =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      try {
                        List<String> list = liked[index].split('/');
                        heroId =
                            liked[index].contains("http") ? list[4] : list[3];
                      } catch (e) {
                        print(e.toString());
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WallpaperPage(
                                  heroId: heroId,
                                  wallpaper: liked[index],
                                )),
                      );
                    },
                    child: Hero(
                        tag: liked[index],
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: liked[index].contains("http")
                              ? new FadeInImage(
                                  image: new NetworkImage(liked[index]),
                                  fit: BoxFit.cover,
                                  placeholder: new AssetImage(
                                    "assets/images/loading.gif",
                                  ),
                                )
                              : new Image.asset(
                                  liked[index],
                                  fit: BoxFit.cover,
                                ),
                        )),
                  ),
                )),
            staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(2, index.isEven ? 2 : 2),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        ),
      ),
    );
  }
}
