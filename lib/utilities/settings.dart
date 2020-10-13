import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Tetron/teclient/user.dart';

class SettingsHelper {
  static SharedPreferences settings;
  static Directory dataDirectory;
  static Directory docsDirectory;
  static const Color primary_blue = Color.fromRGBO(25, 165, 255, 1);

  static User get myProfile {
    var data = settings.getStringList("MyProfile");
    User me = User();
    me.tag = data[0];
    me.name = data[1];
    me.email = data[2];
    me.password = data[3];
    me.profilePictureID = data[4];
    return me;
  }

  static set myProfile(User user) {
    var data = List<String>();
    data.add(user.tag);
    data.add(user.name);
    data.add(user.email);
    data.add(user.password);
    data.add(user.profilePictureID);
    settings.setStringList("MyProfile", data);
  }

  static Brightness get brightness {
    if (SettingsHelper.autoDark) {
      SettingsHelper.brightness =
          SchedulerBinding.instance.window.platformBrightness;
    }
    return Brightness
        .values[settings == null ? 0 : settings.getInt("DarkMode")];
  }

  static set brightness(Brightness mode) {
    settings.setInt("DarkMode", mode.index);
  }

  static bool get autoDark {
    return settings.getBool("AutoDark");
  }

  static set autoDark(bool mode) {
    settings.setBool("AutoDark", mode);
  }

  static TextStyle defaultTextStyle(
      {Color color: SettingsHelper.primary_blue,
      double fontSize: 12,
      double height: 1,
      FontWeight fontWeight: FontWeight.normal,
      String fontFamily: "SF-Pro",
      TextDecoration decoration: TextDecoration.none}) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        height: height,
        fontWeight: fontWeight,
        decoration: decoration);
  }

  static bool get logged {
    return settings == null || settings.getBool("logged") == null
        ? false
        : settings.getBool("logged");
  }

  static set logged(bool logged) {
    settings.setBool("logged", logged);
  }

  static Future<dynamic> setDirectories() async {
    settings = await SharedPreferences.getInstance();
    if (settings.getInt("DarkMode") == null) {
      settings.setInt("DarkMode", 0);
    }
    if (settings.getBool("AutoDark") == null) {
      settings.setBool("AutoDark", true);
    }
    dataDirectory = await getApplicationSupportDirectory();
    docsDirectory = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();
    while (
        settings == null || dataDirectory == null || docsDirectory == null) {}
    return settings;
  }
}
