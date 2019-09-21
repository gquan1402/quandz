import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

final Dio dio = Dio();
CancelToken token = new CancelToken();
final String appPath = "TikTok Downloader";

Future<String> downloadFileVideo(
    String uri, String name, Function onProgress) async {
  Dio dio = Dio();
  token = new CancelToken();
  try {
    String dirPath = await createAppFolder();

    if (dirPath != null) {
      dirPath = "${dirPath}/${name}.${getExt(uri)}";
      await dio.download(uri, dirPath,
          onReceiveProgress: onProgress, cancelToken: token);
      return dirPath;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<String> createAppFolder() async {
  try {
    var dir = await getExternalStorageDirectory();
    final myDir = new Directory('${dir.path}/${appPath}');
    bool isThere = await myDir.exists();
    if (isThere) {
      return myDir.path;
    } else {
      myDir.create(recursive: true);
      return myDir.path;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

void cancelDownload() {
  token.cancel("cancelled");
}

String getExt(String path) {
  var ext = path.split(".").last;
  if (ext.length > 3) ext = 'jpg';
  return ext;
}
