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
import 'package:video_player/video_player.dart';

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

class VideoWallpaperPage extends StatefulWidget {
  final String heroId;
  final String wallpaper;
  VideoWallpaperPage({@required this.heroId, @required this.wallpaper});

  @override
  _VideoWallpaperPageState createState() => _VideoWallpaperPageState();
}

class _VideoWallpaperPageState extends State<VideoWallpaperPage> {
  VideoPlayerController controller;
  bool downloading = false;
  String progressString;

  @override
  void initState() {
    super.initState();
    load();
    controller = VideoPlayerController.network(
        "https://r4---sn-npoe7ne6.googlevideo.com/videoplayback?expire=1568726089&ei=6YeAXbagF6PZ-gbr45_ACg&ip=203.170.69.234&id=o-AKB2qlq1sXMK0bXjnodkTakjP4Xxmk6X4azGgQjxB3dG&itag=18&source=youtube&requiressl=yes&mime=video%2Fmp4&gir=yes&clen=1577180&ratebypass=yes&dur=20.874&lmt=1530524726320962&fvip=4&fexp=23842630&c=WEB&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cmime%2Cgir%2Cclen%2Cratebypass%2Cdur%2Clmt&sig=ALgxI2wwRQIgb5BXhMY2AnTsapbYwSj0iH-smEWtb5h9q1bbMyOtwj0CIQDKC6lQ1BB6rLiXL4hGSxboCh0aaJkarI-OQKw0mfHEJQ%3D%3D&video_id=eZ7X16y6ks4&title=&rm=sn-50bxgx-aixl7e&req_id=e7673fcf95a0a3ee&redirect_counter=2&cm2rm=sn-hju67z&cms_redirect=yes&mip=27.72.103.6&mm=34&mn=sn-npoe7ne6&ms=ltu&mt=1568703811&mv=u&mvi=3&pl=24&lsparams=mip,mm,mn,ms,mv,mvi,pl&lsig=AHylml4wRQIgecBs-7G46qjcvKQ-xI5igIMhK_5HLxUPag9O4E72MxYCIQCAn15LF-XJKYdzcMmQvsSHD7hbDXvyzv0SXMWyYajxTA==")
      ..setVolume(0)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          controller.play();
        });
      });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

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
          controller.value.initialized
              ? VideoPlayer(controller)
              : Hero(
                  tag: widget.heroId,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: FadeInImage(
                      image: NetworkImage(
                          "http://api-btswallpaper.babylover.me/photo/jimin/full/1567073561_35.jpg"),
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/loading.gif'),
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
          Positioned(
              right: 30.0,
              bottom: 10.0,
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
