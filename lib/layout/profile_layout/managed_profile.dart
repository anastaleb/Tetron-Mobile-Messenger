import 'dart:ui';
import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ManagedProfileWindow extends StatefulWidget {
  final String name;
  final String photo;
  final String bio;
  final String chatTag;
  final String email;

  ManagedProfileWindow(
      {Key key, this.name, this.photo, this.bio, this.chatTag, this.email})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManagedProfileWindowState(
      this.name, this.photo, this.bio, this.chatTag, this.email);
}

class _ManagedProfileWindowState extends State<ManagedProfileWindow>
    with TickerProviderStateMixin {
  final String name;
  final String photo;
  final String bio;
  final String username;
  final String email;

  _ManagedProfileWindowState(
      this.name, this.photo, this.bio, this.username, this.email) {
    nameController = TextEditingController(text: name);
    usernameController = TextEditingController(text: username);
    emailController = TextEditingController(text: email);
    bioController = TextEditingController(text: bio);
  }

  ScrollController mainScroller = ScrollController();
  TextEditingController nameController;
  TextEditingController usernameController;
  TextEditingController emailController;
  TextEditingController bioController;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          color: SettingsHelper.brightness == Brightness.light
              ? Color.fromRGBO(248, 248, 248, 1)
              : Colors.black,
          child: ListView(
            controller: mainScroller,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: <Widget>[
              Container(
                height: 60,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 12,
                    15,
                    MediaQuery.of(context).size.width / 12,
                    15),
                padding: EdgeInsets.only(top: 30, bottom: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: SettingsHelper.brightness == Brightness.light
                        ? Colors.white
                        : Color.fromRGBO(10, 10, 10, 1),
                    border: Border.all(width: 0.2, color: Colors.grey)),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                            onTap: () {},
                            child: Hero(
                                tag: username + "pic",
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width /
                                                4)),
                                    child: ClipOval(
                                        child: Image.asset(
                                      photo,
                                      height:
                                          MediaQuery.of(context).size.width / 4,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                    )))))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CupertinoButton(
                                  child: ClipOval(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          color: SettingsHelper.primary_blue,
                                          child: Icon(
                                            Ionicons.ios_camera,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.light
                                                ? Colors.white
                                                : Color.fromRGBO(10, 10, 10, 1),
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                16,
                                          ))),
                                  onPressed: () {}),
                              Text(
                                "Edit",
                                style: SettingsHelper.defaultTextStyle(
                                  height: 0.5,
                                ),
                              )
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CupertinoButton(
                                  child: ClipOval(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              10,
                                          color: Color.fromRGBO(255, 90, 80, 1),
                                          child: Icon(
                                            Ionicons.ios_trash,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.light
                                                ? Colors.white
                                                : Color.fromRGBO(10, 10, 10, 1),
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                16,
                                          ))),
                                  onPressed: () {}),
                              Text(
                                "Delete",
                                style: SettingsHelper.defaultTextStyle(
                                  color: Color.fromRGBO(255, 90, 80, 1),
                                  height: 0.5,
                                ),
                              )
                            ]),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 12,
                    15,
                    MediaQuery.of(context).size.width / 12,
                    10),
                padding: EdgeInsets.only(top: 5, bottom: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: SettingsHelper.brightness == Brightness.light
                        ? Colors.white
                        : Color.fromRGBO(10, 10, 10, 1),
                    border: Border.all(width: 0.2, color: Colors.grey)),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: 90,
                                child: Text(
                                  "Name ",
                                  style: SettingsHelper.defaultTextStyle(
                                      fontSize: 16, height: 1),
                                )),
                            Expanded(
                                child: CupertinoTextField(
                              controller: nameController,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      width: 0.3,
                                      color: Colors.grey.withOpacity(0.5))),
                              style: SettingsHelper.defaultTextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  color: SettingsHelper.brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            )),
                          ],
                        )),
                    Container(
                      color: Colors.grey,
                      height: 0.2,
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: 90,
                                child: Text(
                                  "Username  ",
                                  style: SettingsHelper.defaultTextStyle(
                                      fontSize: 16, height: 1),
                                )),
                            Expanded(
                                child: CupertinoTextField(
                              controller: usernameController,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      width: 0.3,
                                      color: Colors.grey.withOpacity(0.5))),
                              style: SettingsHelper.defaultTextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  color: SettingsHelper.brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            )),
                          ],
                        )),
                    Container(
                      color: Colors.grey,
                      height: 0.2,
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: 90,
                                child: Text(
                                  "E-Mail  ",
                                  style: SettingsHelper.defaultTextStyle(
                                      fontSize: 16, height: 1),
                                )),
                            Expanded(
                                child: CupertinoTextField(
                              controller: emailController,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      width: 0.3,
                                      color: Colors.grey.withOpacity(0.5))),
                              style: SettingsHelper.defaultTextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  color: SettingsHelper.brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            )),
                          ],
                        )),
                    Container(
                      color: Colors.grey,
                      height: 0.2,
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: CupertinoTextField(
                              controller: bioController,
                              placeholder: "My Bio",
                              maxLines: null,
                              expands: true,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      width: 0.3,
                                      color: Colors.grey.withOpacity(0.5))),
                              textAlign: TextAlign.center,
                              style: SettingsHelper.defaultTextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  color: SettingsHelper.brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            )),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          )),
      CupertinoNavigationBar(
        heroTag: username + "header",
        backgroundColor: SettingsHelper.brightness == Brightness.light
            ? Colors.grey[200].withOpacity(0.6)
            : Colors.grey[900].withOpacity(0.6),
        transitionBetweenRoutes: false,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            "back",
            style: SettingsHelper.defaultTextStyle(fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Container(
            child: Text(
          "My Profile",
          overflow: TextOverflow.ellipsis,
          style: SettingsHelper.defaultTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: SettingsHelper.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
        )),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            "save",
            style: SettingsHelper.defaultTextStyle(fontSize: 18),
          ),
          onPressed: () {},
        ),
      ),
    ]);
  }
}
