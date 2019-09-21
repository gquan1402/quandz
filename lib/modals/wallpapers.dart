import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:demon_salyer_wallpaper/constants/api_constants.dart';

Future getList(String text, int page) async {
  try {
    var response = await http.get(
      "$sever_url/$upload?type=$text&sort=-createdAt&page=$page&limit=20",
      headers: {},
    );
    if (response.statusCode == 200) {
      final responseBody = await json.decode(response.body);
      print("Wallpaper Response: ${responseBody}");
      return responseBody;
    } else {
      return null;
    }
  } catch (e) {
    print(e.toString());
    return null;
  }
}
