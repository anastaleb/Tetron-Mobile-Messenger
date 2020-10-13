import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:Tetron/layout/main_layout/chat_item_widget.dart';
import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import '../menu_layout/menu_widget.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  double menuAnimationFactor = 0;

  List<Widget> chats;

  AnimationController _menuAnimationController;
  AnimationController _menuAnimationController2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _menuAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _menuAnimationController2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TODO remove temp chats
    chats = <Widget>[
      ChatItem(
        title: "Elon Musk",
        lastMessage: "whatever",
        newMessages: 9,
        imagePath: "assets/Images/elon.jpg",
        time: DateTime.now(),
        tag: "elon",
      ).build(context),
      ChatItem(
        title: "Anas Taleb",
        lastMessage: "Hmmm, sounds good!",
        imagePath: "assets/Images/anas.png",
        time: DateTime.now(),
        tag: "a1",
      ).build(context),
      ChatItem(
        title: "Anas Taleb",
        lastMessage: "🧒🏻👨🏻‍🦳",
        imagePath: "assets/Images/anas.png",
        time: DateTime.now(),
        tag: "a2",
      ).build(context),
      ChatItem(
        title: "Anas Taleb",
        lastMessage: "Hmmm, sounds good!",
        imagePath: "assets/Images/anas.png",
        time: DateTime.now(),
        tag: "a3",
      ).build(context),
      ChatItem(
        title: "Anas Taleb",
        lastMessage: "Hmmm, sounds good!",
        imagePath: "assets/Images/anas.png",
        time: DateTime.now(),
        tag: "a4",
      ).build(context),
      ChatItem(
        title: "Elon Tusk",
        lastMessage: "Hi, I'm the new version of elon",
        imagePath: "assets/Images/elon.jpg",
        time: DateTime.now(),
        tag: "e1",
      ).build(context)
    ];
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent));

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SettingsHelper.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: WillPopScope(
            onWillPop: () {
              SystemNavigator.pop();
            },
            child: Stack(
              children: <Widget>[
                AnimatedBuilder(
                    animation: _menuAnimationController,
                    builder: (context, child) {
                      return menuAnimationFactor == 1
                          ? ScaleTransition(
                              scale: Tween<double>(begin: 1, end: 0.91).animate(
                                  CurvedAnimation(
                                      curve: Curves.easeOut,
                                      parent: _menuAnimationController)),
                              child: child,
                            )
                          : child;
                    },
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(15 * menuAnimationFactor),
                        child: Stack(children: <Widget>[
                          Scaffold(
                            backgroundColor:
                                SettingsHelper.brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                            resizeToAvoidBottomPadding: false,
                            resizeToAvoidBottomInset: false,
                            body: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              height: MediaQuery.of(context).size.height,
                              color:
                                  SettingsHelper.brightness == Brightness.light
                                      ? Colors.white
                                      : Colors.black,
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemBuilder: (context, index) {
                                    return index <= chats.length
                                        ? index == 0
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .padding
                                                        .top +
                                                    60,
                                              )
                                            : chats[index - 1]
                                        : null;
                                  }),
                            ),
                          ),
                          AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              color:
                                  SettingsHelper.brightness == Brightness.light
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.black.withOpacity(0.5),
                              child: CupertinoNavigationBar(
                                heroTag: "header",
                                brightness: SettingsHelper.brightness ==
                                        Brightness.light
                                    ? Brightness.light
                                    : Brightness.dark,
                                automaticallyImplyLeading: false,
                                backgroundColor: Colors.transparent,
                                transitionBetweenRoutes: false,
                              )),
                          PreferredSize(
                              preferredSize: Size.fromHeight(60),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                height: MediaQuery.of(context).padding.top + 60,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: (MediaQuery.of(context).padding.top +
                                          5),
                                      right: 25,
                                      left: 25),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FloatingActionButton(
                                        heroTag: "menu",
                                        elevation: 0,
                                        highlightElevation: 0,
                                        hoverElevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: Icon(
                                          Ionicons.ios_menu,
                                          color: SettingsHelper.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white,
                                          size: 40,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            menuAnimationFactor = 1;
                                          });
                                          _menuAnimationController
                                              .forward()
                                              .whenComplete(() {
                                            _menuAnimationController2.forward();
                                          });
                                        },
                                      ),
                                      Text(
                                        "Tetron",
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.normal,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.light
                                                ? Colors.black
                                                : Colors.white,
                                            fontFamily: "LeckerliOne",
                                            fontSize: 36),
                                      ),
                                      FloatingActionButton(
                                        heroTag: "stories",
                                        elevation: 0,
                                        highlightElevation: 0,
                                        hoverElevation: 0,
                                        backgroundColor: Colors.transparent,
                                        child: DottedBorder(
                                          child:
                                              Container(height: 26, width: 26),
                                          radius: Radius.circular(10),
                                          borderType: BorderType.Circle,
                                          color: SettingsHelper.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white,
                                          strokeWidth: 4,
                                          dashPattern: [
                                            12,
                                            7,
                                            12,
                                            7,
                                            8,
                                            7,
                                            5,
                                            7,
                                            3,
                                            7,
                                            2,
                                            7,
                                            1,
                                            7,
                                            1,
                                            7
                                          ],
                                          strokeCap: StrokeCap.round,
                                        ),
                                        onPressed: () {},
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ]))),
                Visibility(
                    visible: menuAnimationFactor == 1,
                    child: MenuWindow(
                      homePage: this,
                      onClose: () {
                        return _menuAnimationController
                            .reverse()
                            .whenComplete(() {
                          setState(() {
                            menuAnimationFactor = 0;
                          });
                        });
                      },
                      buildAnimationController: _menuAnimationController2,
                    )),
              ],
            )));
  }
}
