import 'package:mobx/mobx.dart';
import 'package:demon_salyer_wallpaper/HomeNavigator.dart';
// Include generated file
import 'package:flutter/material.dart';
import 'package:demon_salyer_wallpaper/modals/wallpaper.dart';
import 'package:demon_salyer_wallpaper/modals/wallpapers.dart';
part 'ThemeStore.g.dart';

// This is the class used by rest of your codebase
class ThemeStore = _ThemeStore with _$ThemeStore;

// The store-class
abstract class _ThemeStore with Store {
  @observable
  List<BTSModal> listData = new List<BTSModal>();
  @observable
  ThemeApp themeApp = new ThemeApp();
  @action
  void getListData() async {
    var child = await getList("All", 1);
    if (child != null && child.length > 0) {
      List<BTSModal> newList = new List<BTSModal>();
      child.forEach((item) {
        BTSModal res = BTSModal.fromJson(item);
        if (res.id != null) {
          newList.add(res);
        }
      });
      listData = []..addAll(newList);
      print("All Sub Comment: ${listData.length}");
    }
    print("---------- $listData");
  }

  @action
  void setTheme(String theme) {
    if (theme == "pink") {
      themeApp.backGroundColor1 = Color(0xffEE9A92);
      themeApp.backGroundColor2 = Color(0xffEE9A92);
      themeApp.tabBarColor = Color(0xffFF818D);
      themeApp.iconTabBarColor = Colors.white;
      themeApp.textColor = Colors.white;
    }
    if (theme == "default") {
      themeApp.backGroundColor1 = Color(0xff23969C);
      themeApp.backGroundColor2 = Color(0xff23969C);
      themeApp.tabBarColor = Color(0xff07363F);
      themeApp.iconTabBarColor = Colors.white;
      themeApp.textColor = Colors.white;
    }
    if (theme == "blue") {
      themeApp.backGroundColor1 = Color(0xffa1c4fd);
      themeApp.backGroundColor2 = Color(0xffa1c4fd);
      themeApp.tabBarColor = Color(0xff72a8ff);
      themeApp.iconTabBarColor = Colors.white;
      themeApp.textColor = Colors.white;
    }
  }
}

final ThemeStore themeStore = new ThemeStore();
