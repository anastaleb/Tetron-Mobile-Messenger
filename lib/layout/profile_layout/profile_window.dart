import 'dart:ui';
import 'package:Tetron/utilities/other_tools.dart';
import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:dotted_border/dotted_border.dart';

class ProfileWindow extends StatefulWidget {
  final String name;
  final String photo;
  final String bio;
  final String chatTag;
  final String status;
  final String email;
  final ChatType chatType;

  ProfileWindow(
      {Key key,
      this.name,
      this.photo,
      this.bio,
      this.chatTag,
      this.status,
      this.email,
      this.chatType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileWindowState(
      this.name,
      this.photo,
      this.bio,
      this.chatTag,
      this.status,
      this.email,
      this.chatType);
}

class ProfileWindowState extends State<ProfileWindow>
    with TickerProviderStateMixin {
  final String name;
  final String photo;
  final String bio;
  final String chatTag;
  final String status;
  final String email;
  final ChatType chatType;

  ProfileWindowState(this.name, this.photo, this.bio, this.chatTag, this.status,
      this.email, this.chatType) {
    tabController = TabController(
        vsync: this,
        initialIndex: 0,
        length: chatType == ChatType.Group ? 5 : 4);
    tabController.addListener(() {
      if (chatType == ChatType.Group) {
        tabAnimations[tabController.previousIndex].reverse();
        tabAnimations[tabController.index].forward();
      } else {
        tabAnimations[tabController.previousIndex + 1].reverse();
        tabAnimations[tabController.index + 1].forward();
      }
      this.setState(() {});
    });
    tabAnimations = [
      AnimationController(
          vsync: this, duration: Duration(milliseconds: 300), value: 1),
      AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 300),
          value: chatType == ChatType.Normal ? 1 : 0),
      AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
      AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
      AnimationController(vsync: this, duration: Duration(milliseconds: 300)),
    ];
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  TabController tabController;
  List<AnimationController> tabAnimations;
  List<ScrollController> scroller = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController()
  ];
  ScrollController mainScroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
          color: SettingsHelper.brightness == Brightness.light
              ? Color.fromRGBO(248, 248, 248, 1)
              : Colors.black,
          child: ListView(
            controller: mainScroller,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
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
                              tag: chatTag + "pic",
                              child: ClipOval(
                                  child: Image.asset(
                                photo,
                                height: MediaQuery.of(context).size.width / 4,
                                width: MediaQuery.of(context).size.width / 4,
                              )),
                            ))),
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
                                            CupertinoIcons.video_camera_solid,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.light
                                                ? Colors.white
                                                : Color.fromRGBO(10, 10, 10, 1),
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                14,
                                          ))),
                                  onPressed: () {}),
                              Text(
                                "Video Call",
                                style: TextStyle(
                                    color: SettingsHelper.primary_blue,
                                    fontSize: 12,
                                    fontFamily: "SF-Pro",
                                    height: 0.5,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none),
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
                                          color: SettingsHelper.primary_blue,
                                          child: Icon(
                                            CupertinoIcons.phone_solid,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.light
                                                ? Colors.white
                                                : Color.fromRGBO(10, 10, 10, 1),
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                14,
                                          ))),
                                  onPressed: () {}),
                              Text(
                                "Voice Call",
                                style: TextStyle(
                                    color: SettingsHelper.primary_blue,
                                    fontSize: 12,
                                    fontFamily: "SF-Pro",
                                    height: 0.5,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none),
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
                                          color: SettingsHelper.primary_blue,
                                          child: Icon(
                                            MaterialCommunityIcons.share,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.light
                                                ? Colors.white
                                                : Color.fromRGBO(10, 10, 10, 1),
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                14,
                                          ))),
                                  onPressed: () {}),
                              Text(
                                "Share",
                                style: SettingsHelper.defaultTextStyle(
                                    height: 0.5),
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
                        margin: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Username  ",
                              style: SettingsHelper.defaultTextStyle(
                                  fontSize: 16, height: 1),
                            ),
                            Expanded(
                                child: Text(
                              "@" + chatTag,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: SettingsHelper.defaultTextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  color: SettingsHelper.brightness == Brightness.light
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
                        margin: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 25),
                                child: Text(
                                  "E-Mail  ",
                                  style: SettingsHelper.defaultTextStyle(
                                      fontSize: 16, height: 1),
                                )),
                            Expanded(
                                child: Text(
                              email,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: SettingsHelper.defaultTextStyle(
                                  fontSize: 16,
                                  height: 1,
                                  color: SettingsHelper.brightness == Brightness.light
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
                        margin: EdgeInsets.all(15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              bio,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: SettingsHelper.defaultTextStyle(
                                  fontSize: 16,
                                  height: 1.2,
                                  color: SettingsHelper.brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            )),
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 12,
                      15,
                      MediaQuery.of(context).size.width / 12,
                      15),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: SettingsHelper.brightness == Brightness.light
                          ? Colors.white
                          : Color.fromRGBO(10, 10, 10, 1),
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  child: Column(children: <Widget>[
                    Container(
                      height: 60,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            width: 15,
                          ),
                          chatType == ChatType.Group
                              ? Column(
                                  children: <Widget>[
                                    CupertinoButton(
                                      minSize: 30,
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        "Members",
                                        style: SettingsHelper.defaultTextStyle(
                                            fontSize: 16,
                                            color: tabController.index == 0
                                                ? SettingsHelper.primary_blue
                                                : Colors.grey),
                                      ),
                                      onPressed: () {
                                        tabController.animateTo(0);
                                        tabAnimations[
                                                tabController.previousIndex]
                                            .reverse();
                                        tabAnimations[0].forward();
                                        setState(() {});
                                      },
                                    ),
                                    AnimatedBuilder(
                                      animation: tabAnimations[0],
                                      builder: (context, child) {
                                        return FadeTransition(
                                          opacity:
                                              Tween<double>(begin: 0, end: 1)
                                                  .animate(tabAnimations[0]),
                                          child: child,
                                        );
                                      },
                                      child: DottedBorder(
                                        padding: EdgeInsets.zero,
                                        strokeWidth: 4,
                                        strokeCap: StrokeCap.round,
                                        color: SettingsHelper.primary_blue,
                                        dashPattern: [0, 6],
                                        child: Container(
                                          height: 0,
                                          width: 42,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          Column(
                            children: <Widget>[
                              CupertinoButton(
                                minSize: 30,
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text(
                                  "Media",
                                  style: SettingsHelper.defaultTextStyle(
                                      fontSize: 16,
                                      color: chatType == ChatType.Normal
                                          ? (tabController.index == 0
                                              ? SettingsHelper.primary_blue
                                              : Colors.grey)
                                          : tabController.index == 1
                                              ? SettingsHelper.primary_blue
                                              : Colors.grey),
                                ),
                                onPressed: () {
                                  tabController.animateTo(
                                      chatType == ChatType.Normal ? 0 : 1);
                                  tabAnimations[chatType == ChatType.Normal
                                          ? tabController.previousIndex + 1
                                          : tabController.previousIndex]
                                      .reverse();
                                  tabAnimations[1].forward();
                                  setState(() {});
                                },
                              ),
                              AnimatedBuilder(
                                animation: tabAnimations[1],
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: Tween<double>(begin: 0, end: 1)
                                        .animate(tabAnimations[1]),
                                    child: child,
                                  );
                                },
                                child: DottedBorder(
                                  padding: EdgeInsets.zero,
                                  strokeWidth: 4,
                                  strokeCap: StrokeCap.round,
                                  color: SettingsHelper.primary_blue,
                                  dashPattern: [0, 6],
                                  child: Container(
                                    height: 0,
                                    width: 42,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              CupertinoButton(
                                minSize: 30,
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text(
                                  "Files",
                                  style: SettingsHelper.defaultTextStyle(
                                      fontSize: 16,
                                      color: chatType == ChatType.Normal
                                          ? (tabController.index == 1
                                              ? SettingsHelper.primary_blue
                                              : Colors.grey)
                                          : tabController.index == 2
                                              ? SettingsHelper.primary_blue
                                              : Colors.grey),
                                ),
                                onPressed: () {
                                  tabController.animateTo(
                                      chatType == ChatType.Normal ? 1 : 2);
                                  tabAnimations[chatType == ChatType.Normal
                                          ? tabController.previousIndex + 1
                                          : tabController.previousIndex]
                                      .reverse();
                                  tabAnimations[2].forward();
                                  setState(() {});
                                },
                              ),
                              AnimatedBuilder(
                                animation: tabAnimations[2],
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: Tween<double>(begin: 0, end: 1)
                                        .animate(tabAnimations[2]),
                                    child: child,
                                  );
                                },
                                child: DottedBorder(
                                  color: SettingsHelper.primary_blue,
                                  padding: EdgeInsets.zero,
                                  strokeWidth: 4,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: [0, 6],
                                  child: Container(
                                    height: 0,
                                    width: 42,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              CupertinoButton(
                                minSize: 30,
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text(
                                  "Links",
                                  style: SettingsHelper.defaultTextStyle(
                                      fontSize: 16,
                                      color: chatType == ChatType.Normal
                                          ? (tabController.index == 2
                                              ? SettingsHelper.primary_blue
                                              : Colors.grey)
                                          : tabController.index == 3
                                              ? SettingsHelper.primary_blue
                                              : Colors.grey),
                                ),
                                onPressed: () {
                                  tabController.animateTo(
                                      chatType == ChatType.Normal ? 2 : 3);
                                  tabAnimations[chatType == ChatType.Normal
                                          ? tabController.previousIndex + 1
                                          : tabController.previousIndex]
                                      .reverse();
                                  tabAnimations[3].forward();
                                  setState(() {});
                                },
                              ),
                              AnimatedBuilder(
                                animation: tabAnimations[3],
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: Tween<double>(begin: 0, end: 1)
                                        .animate(tabAnimations[3]),
                                    child: child,
                                  );
                                },
                                child: DottedBorder(
                                  color: SettingsHelper.primary_blue,
                                  padding: EdgeInsets.zero,
                                  strokeWidth: 4,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: [0, 6],
                                  child: Container(
                                    height: 0,
                                    width: 42,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              CupertinoButton(
                                minSize: 30,
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text(
                                  "Audio",
                                  style: SettingsHelper.defaultTextStyle(
                                      fontSize: 16,
                                      color: chatType == ChatType.Normal
                                          ? (tabController.index == 3
                                              ? SettingsHelper.primary_blue
                                              : Colors.grey)
                                          : tabController.index == 4
                                              ? SettingsHelper.primary_blue
                                              : Colors.grey),
                                ),
                                onPressed: () {
                                  tabController.animateTo(
                                      chatType == ChatType.Normal ? 3 : 4);
                                  setState(() {});
                                  tabAnimations[chatType == ChatType.Normal
                                          ? tabController.previousIndex + 1
                                          : tabController.previousIndex]
                                      .reverse();
                                  tabAnimations[4].forward();
                                },
                              ),
                              AnimatedBuilder(
                                animation: tabAnimations[4],
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: Tween<double>(begin: 0, end: 1)
                                        .animate(tabAnimations[4]),
                                    child: child,
                                  );
                                },
                                child: DottedBorder(
                                  padding: EdgeInsets.zero,
                                  color: SettingsHelper.primary_blue,
                                  strokeWidth: 4,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: [0, 6],
                                  child: Container(
                                    height: 0,
                                    width: 42,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height -
                            170 -
                            MediaQuery.of(context).padding.top,
                        child: TabBarView(
                          controller: tabController,
                          children: <Widget>[
                            Container(
                                child: NotificationListener(
                              onNotification: (noti) {
                                if (noti is OverscrollNotification) {
                                  if (scroller[1]
                                              .position
                                              .userScrollDirection ==
                                          ScrollDirection.forward &&
                                      scroller[1].position.pixels <= 0) {
                                    mainScroller.position.jumpTo(
                                        mainScroller.position.pixels +
                                            (noti as OverscrollNotification)
                                                .overscroll);
                                  }
                                }
                                if (noti is ScrollNotification &&
                                    scroller[1].position.userScrollDirection ==
                                        ScrollDirection.reverse &&
                                    mainScroller.position.pixels <
                                        mainScroller.position.maxScrollExtent) {
                                  mainScroller.jumpTo(
                                      mainScroller.position.pixels +
                                          (noti as ScrollNotification)
                                              .metrics
                                              .pixels);
                                  scroller[1].jumpTo(0);
                                }
                              },
                              child: ListView.builder(
                                  controller: scroller[1],
                                  itemCount: 1,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index == 0)
                                      return Container(
                                        child: Center(
                                          child: Text(
                                            "No Media",
                                            style:
                                                SettingsHelper.defaultTextStyle(
                                                    fontSize: 18,
                                                    color: SettingsHelper
                                                        .primary_blue),
                                          ),
                                        ),
                                      );
                                    return null;
                                  }),
                            )),
                            Container(
                                child: NotificationListener(
                              onNotification: (noti) {
                                if (noti is OverscrollNotification) {
                                  if (scroller[2]
                                              .position
                                              .userScrollDirection ==
                                          ScrollDirection.forward &&
                                      scroller[2].position.pixels <= 0) {
                                    mainScroller.position.jumpTo(
                                        mainScroller.position.pixels +
                                            (noti as OverscrollNotification)
                                                .overscroll);
                                  }
                                }
                              },
                              child: ListView.builder(
                                  itemCount: 1,
                                  controller: scroller[2],
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index == 0)
                                      return Container(
                                        child: Center(
                                          child: Text(
                                            "No Files",
                                            style:
                                                SettingsHelper.defaultTextStyle(
                                                    fontSize: 18,
                                                    color: SettingsHelper
                                                        .primary_blue),
                                          ),
                                        ),
                                      );
                                    return null;
                                  }),
                            )),
                            Container(
                                child: NotificationListener(
                              onNotification: (noti) {
                                if (noti is OverscrollNotification) {
                                  if (scroller[3]
                                              .position
                                              .userScrollDirection ==
                                          ScrollDirection.forward &&
                                      scroller[3].position.pixels <= 0) {
                                    mainScroller.position.jumpTo(
                                        mainScroller.position.pixels +
                                            (noti as OverscrollNotification)
                                                .overscroll);
                                  }
                                }
                              },
                              child: ListView.builder(
                                  itemCount: 1,
                                  controller: scroller[3],
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index == 0)
                                      return Container(
                                        child: Center(
                                          child: Text(
                                            "No Links",
                                            style:
                                                SettingsHelper.defaultTextStyle(
                                                    fontSize: 18,
                                                    color: SettingsHelper
                                                        .primary_blue),
                                          ),
                                        ),
                                      );
                                    return null;
                                  }),
                            )),
                            Container(
                                child: NotificationListener(
                              onNotification: (noti) {
                                if (noti is OverscrollNotification) {
                                  if (scroller[4]
                                              .position
                                              .userScrollDirection ==
                                          ScrollDirection.forward &&
                                      scroller[4].position.pixels <= 0) {
                                    mainScroller.position.jumpTo(
                                        mainScroller.position.pixels +
                                            (noti as OverscrollNotification)
                                                .overscroll);
                                  }
                                }
                              },
                              child: ListView.builder(
                                  itemCount: 1,
                                  controller: scroller[4],
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (index == 0)
                                      return Container(
                                        child: Center(
                                          child: Text(
                                            "No Audio",
                                            style:
                                                SettingsHelper.defaultTextStyle(
                                                    fontSize: 18,
                                                    color: SettingsHelper
                                                        .primary_blue),
                                          ),
                                        ),
                                      );
                                    return null;
                                  }),
                            )),
                          ],
                        ))
                  ])),
            ],
          )),
      CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        heroTag: "header",
        backgroundColor: SettingsHelper.brightness == Brightness.light
            ? Colors.grey[200].withOpacity(0.5)
            : Colors.grey[900].withOpacity(0.5),
        transitionBetweenRoutes: false,
      ),
      ClipRect(
          child: Container(
        padding: EdgeInsets.fromLTRB(
            10, MediaQuery.of(context).padding.top + 8, 10, 0),
        height: MediaQuery.of(context).padding.top + 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
                tag: chatTag + "back",
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    Ionicons.ios_arrow_back,
                    color: SettingsHelper.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 4),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                              flightShuttleBuilder: _flightShuttleBuilder,
                              tag: chatTag + "name",
                              child: Container(
                                  child: Text(
                                name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "SF-Pro",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        SettingsHelper.brightness == Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                    decoration: TextDecoration.none),
                              ))),
                          Hero(
                              flightShuttleBuilder: _flightShuttleBuilder,
                              tag: chatTag + "status",
                              child: Container(
                                  child: Text(
                                status,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: "SF-Pro",
                                    fontSize: 14,
                                    color:
                                        SettingsHelper.brightness == Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal),
                              ))),
                        ]))),
            Hero(
                tag: chatTag + "options",
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    MaterialCommunityIcons.dots_vertical,
                    color: SettingsHelper.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    size: 30,
                  ),
                  onPressed: () {},
                ))
          ],
        ),
      )),
    ]);
  }
}
