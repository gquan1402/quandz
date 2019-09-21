import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:edge_alert/edge_alert.dart';
import 'package:toast/toast.dart';
import 'package:demon_salyer_wallpaper/utils/download_file.dart';
import 'package:demon_salyer_wallpaper/utils/admob_ads.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:demon_salyer_wallpaper/constant/admob_constant.dart';

const platform = const MethodChannel('com.liveWallpaper');

class PermistionModule {
  static Future<bool> checkPermistionStogare() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission == PermissionStatus.granted) {
      return true;
    } else if (permission == PermissionStatus.disabled) {
      return false;
    } else {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);

      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}

class WallpaperPage extends StatefulWidget {
  final String heroId;
  final String wallpaper;
  WallpaperPage({@required this.heroId, @required this.wallpaper});

  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  bool downloading = false;
  String progressString;

  @override
  void initState() {
    super.initState();

    checkLike();
    load();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void checkLike() async {
    prefs = await SharedPreferences.getInstance();
    List<String> liked = await prefs.getStringList('like') != null
        ? prefs.getStringList('like')
        : [];
    if (liked.contains(widget.wallpaper)) {
      setState(() {
        isLike = true;
      });
    } else {
      setState(() {
        isLike = false;
      });
    }
  }

  void liked(id) async {
    setState(() {
      isLike = !isLike;
    });
    prefs = await SharedPreferences.getInstance();
    List<String> liked = await prefs.getStringList('like') != null
        ? prefs.getStringList('like')
        : [];
    if (liked.contains(id)) {
      liked.remove(id);
    } else {
      liked.add(id);
    }
    await prefs.setStringList('like', liked);
  }

  bool isLike = false;
  SharedPreferences prefs;
  InterstitialAd _interstitialAd;

  Future load() async {
    await FirebaseAdMob.instance.initialize(appId: ADMOB_APP_ID);
  }

  Future<ByteData> loadAsset() async {
    return await rootBundle.load(widget.wallpaper);
  }

  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> setBackground() async {
    bool permistionStorage = await PermistionModule.checkPermistionStogare();
    if (permistionStorage) {
      setState(() {
        downloading = true;
      });
      List<String> list = widget.wallpaper.split("/");
      Directory directory = await getApplicationDocumentsDirectory();
      var dbPath = "${directory.path}/${list[3]}";
      ByteData data = await rootBundle.load(widget.wallpaper);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      File file = await File(dbPath).writeAsBytes(bytes);
      platform
          .invokeMethod('setBackground', {"filePath": file.path}).then((value) {
        _interstitialAd = AdmobAds.createInterstitialAd(() {
          if (value) {
            setState(() {
              downloading = false;
              progressString = "Completed";
            });
            EdgeAlert.show(context,
                title: 'Wallpaper!',
                description: 'Set Wallpaper Successfully',
                icon: Icons.check,
                backgroundColor: Color.fromRGBO(50, 165, 74, 1),
                gravity: EdgeAlert.TOP);
          } else {
            setState(() {
              downloading = false;
              progressString = "Failed";
            });
            EdgeAlert.show(context,
                title: 'Wallpaper!',
                description: 'Set Wallpaper failed',
                icon: Icons.check,
                backgroundColor: Color.fromRGBO(50, 165, 74, 1),
                gravity: EdgeAlert.TOP);
          }
        })
          ..load()
          ..show();
      });
    } else {
      EdgeAlert.show(context,
          title: 'Wallpaper!',
          description: 'Set Wallpaper failed',
          icon: Icons.clear,
          backgroundColor: Color.fromRGBO(50, 165, 74, 1),
          gravity: EdgeAlert.TOP);
    }
  }

  Future<void> downloadImage(bool isSetBackground) async {
    bool permistionStorage = await PermistionModule.checkPermistionStogare();
    if (permistionStorage) {
      String path = await downloadFileVideo(
          widget.wallpaper, widget.heroId.replaceAll(".jpg", ""), (rec, total) {
        print("Download Success");
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
      if (path != null) {
        if (!isSetBackground) {
          platform.invokeMethod('add', {"filePath": path}).then((value) {
            _interstitialAd = AdmobAds.createInterstitialAd(() {
              if (value) {
                setState(() {
                  downloading = false;
                  progressString = "Completed";
                });
                EdgeAlert.show(context,
                    title: 'Wallpaper!',
                    description: 'Download complete!',
                    icon: Icons.file_download,
                    backgroundColor: Color.fromRGBO(50, 165, 74, 1),
                    gravity: EdgeAlert.TOP);
              } else {
                setState(() {
                  downloading = false;
                  progressString = "Failed";
                });
                EdgeAlert.show(context,
                    title: 'Wallpaper!',
                    description: 'Download Failed!',
                    icon: Icons.file_download,
                    backgroundColor: Color.fromRGBO(205, 46, 46, 1),
                    gravity: EdgeAlert.TOP);
              }
            })
              ..load()
              ..show();
          });
        } else {
          platform
              .invokeMethod('setBackground', {"filePath": path}).then((value) {
            _interstitialAd = AdmobAds.createInterstitialAd(() {
              if (value) {
                setState(() {
                  downloading = false;
                  progressString = "Completed";
                });
                EdgeAlert.show(context,
                    title: 'Wallpaper!',
                    description: 'Set background complete!',
                    icon: Icons.file_download,
                    backgroundColor: Color.fromRGBO(50, 165, 74, 1),
                    gravity: EdgeAlert.TOP);
              } else {
                setState(() {
                  downloading = false;
                  progressString = "Failed";
                });
              }
            })
              ..load()
              ..show();
          });
        }
      } else {
        EdgeAlert.show(context,
            title: 'Wallpaper!',
            description: 'Download Failed!',
            icon: Icons.file_download,
            backgroundColor: Color.fromRGBO(205, 46, 46, 1),
            gravity: EdgeAlert.TOP);
      }
    } else {
      EdgeAlert.show(context,
          title: 'Wallpaper!',
          description:
              'Live Wallpaper needs to access photo gallery to download your wallpaper!!',
          icon: Icons.file_download,
          backgroundColor: Color.fromRGBO(205, 46, 46, 1),
          gravity: EdgeAlert.TOP);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.heroId,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: FadeInImage(
                image: NetworkImage(widget.wallpaper),
                fit: BoxFit.cover,
                placeholder: new AssetImage(
                  "assets/images/loading2.gif",
                ),
              ),
            ),
          ),
          Positioned(
            top: 28,
            left: 8,
            child: FloatingActionButton(
              backgroundColor: Colors.pinkAccent,
              tooltip: 'Close',
              child: Icon(
                Icons.clear,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              heroTag: 'close',
              mini: true,
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(bottom: 30, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: isLike ? Colors.pinkAccent : Colors.white,
                            size: 50,
                          ),
                          onPressed: () {
                            liked(widget.wallpaper);
                            isLike
                                ? EdgeAlert.show(context,
                                    title: 'Wallpaper!',
                                    description: 'Liked!',
                                    icon: Icons.favorite,
                                    backgroundColor:
                                        Color.fromRGBO(50, 165, 74, 1),
                                    gravity: EdgeAlert.TOP)
                                : EdgeAlert.show(
                                    context,
                                    title: 'Wallpaper!',
                                    description: 'Unliked!',
                                    icon: Icons.close,
                                    backgroundColor:
                                        Color.fromRGBO(50, 165, 74, 1),
                                    gravity: EdgeAlert.TOP,
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      right: 30.0,
                      top: 0.0,
                      child: Row(
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: "btnDownload",
                            tooltip: 'Download Wallpaper',
                            backgroundColor: Colors.pinkAccent,
                            child: Icon(
                              Icons.file_download,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              downloadImage(false);
                            },
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FloatingActionButton(
                            heroTag: "btnDSetWallpaper",
                            tooltip: 'Set as Wallpaper',
                            backgroundColor: Colors.pinkAccent,
                            child: Icon(
                              Icons.format_paint,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              downloadImage(true);
                            },
                          ),
                        ],
                      )),
                ],
              )
            ],
          ),
          Positioned(
            child: downloading
                ? Container(
                    child: Center(
                      child: Image.asset(
                        "assets/images/download.gif",
                        width: 150,
                        height: 150,
                      ),
                    ),
                    color: Colors.transparent,
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
