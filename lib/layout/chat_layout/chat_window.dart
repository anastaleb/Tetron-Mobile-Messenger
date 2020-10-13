import 'dart:io';
import 'dart:ui';

import 'package:Tetron/layout/profile_layout/profile_window.dart';
import 'package:flutter/services.dart';
import 'package:Tetron/utilities/richtextboxcontroller.dart';
import 'package:Tetron/utilities/other_tools.dart';
import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../widgets/message_widget.dart';

class ChatWindow extends StatefulWidget {
  final String tag;
  final String image;
  final String title;
  final String status;

  const ChatWindow({Key key, this.tag, this.image, this.title, this.status})
      : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      _ChatWindow(tag: tag, image: image, title: title, status: status);
}

class _ChatWindow extends State<ChatWindow> with TickerProviderStateMixin {
  _ChatWindow({this.tag = "", this.image, this.status = "", this.title = ""});
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: _kbHeight,
    );
    _setAnimation(begin: 0.0, end: 1.0);

    _methodChannel.setMethodCallHandler(this._didRecieveNativeCall);
  }

  _setAnimation({double begin, double end}) {
    _animation = Tween(begin: begin, end: end).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
  }

  _startAnimation([bool forward = true]) {
    //animation starts at 0, but since it's already at 0 when it starts the first frame is just wasted time, so the value in from: makes it skips this while keeping the curve right
    final firstFrameSkip =
        1000000 / (10 * _animationController.duration.inMicroseconds);
    if (forward) {
      _animationController
          .forward(from: firstFrameSkip)
          .whenComplete(() => _setAnimation(begin: 0.0, end: 1.0));
    } else {
      _animationController.reverse(from: 1 - firstFrameSkip);
    }
  }

  Future<void> _didRecieveNativeCall(MethodCall call) async {
    _kbHeight = call.arguments;

    if (call.method == 'kbshow') {
      _setAnimation(begin: 0.0, end: 1.0);
      _startAnimation(true);
      _kbShown = true;
    } else if (call.method == 'kbhide') {
      _startAnimation(false);
      _kbShown = false;
      FocusManager.instance.primaryFocus
          .unfocus(); //failsafe just in case the hide is not triggered by actual keyboard hiding
    }
  }

  final String tag;
  final String image;
  final String title;
  final String status;
  RichTextController messageBoxController = RichTextController(
    TextHelper.mainPatternMap,
    onMatch: (match) {},
  );
  List<Message> messages = <Message>[
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
    Message(text: "Hello Man!", isSent: false),
    Message(text: "Hello World!", isSent: true),
  ];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  bool emojiWidgetisible = false;

  AnimationController _animationController;
  Animation _animation;
  var _kbHeight = 0.0;
  // ignore: unused_field
  var _kbShown = false;
  final _methodChannel = const MethodChannel('kbtestwidget');

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

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Hero(
        tag: tag + "box",
        child: Container(
          decoration: BoxDecoration(
            color: SettingsHelper.brightness == Brightness.light
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      Scaffold(
          backgroundColor: SettingsHelper.brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          resizeToAvoidBottomInset: Platform.isIOS ? false : true,
          body: Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: AnimatedList(
                        key: _listKey,
                        initialItemCount: messages.length + 1,
                        reverse: true,
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (context, index, animation) {
                          if (index == messages.length)
                            return Container(
                              height:
                                  MediaQuery.of(context).padding.top + 60 + 50,
                              width: 10,
                            );
                          return index < messages.length
                              ? SlideTransition(
                                  child: SizeTransition(
                                    child: ScaleTransition(
                                      child: messages[index],
                                      scale: Tween<double>(begin: 0, end: 1)
                                          .animate(CurvedAnimation(
                                              curve: Curves.easeOut,
                                              parent: animation)),
                                    ),
                                    sizeFactor: Tween<double>(begin: 0, end: 1)
                                        .animate(CurvedAnimation(
                                            curve: Curves.easeOut,
                                            parent: animation)),
                                  ),
                                  position: Tween(
                                          begin: Offset(-0.0, 0.5),
                                          end: Offset(0, 0))
                                      .animate(CurvedAnimation(
                                          curve: Curves.easeIn,
                                          parent: animation)),
                                )
                              : null;
                        })),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(10, 5, 15, 5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Hero(
                              tag: tag + "emoji",
                              child: CupertinoButton(
                                padding: EdgeInsets.only(right: 15, left: 10),
                                child: Icon(
                                  MaterialCommunityIcons.sticker_emoji,
                                  size: 30,
                                  color: SettingsHelper.brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    emojiWidgetisible
                                        ? emojiWidgetisible = false
                                        : emojiWidgetisible = true;
                                  });
                                },
                              )),
                          Hero(
                              flightShuttleBuilder: _flightShuttleBuilder,
                              tag: tag + "footer",
                              child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 300,
                                    minHeight: 40,
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color:
                                          SettingsHelper.brightness == Brightness.light
                                              ? Colors.white
                                              : Color.fromRGBO(25, 25, 25, 1),
                                      border: Border.all(
                                          width: 0.5,
                                          color: SettingsHelper.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white)),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        constraints:
                                            BoxConstraints(maxHeight: 300),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                125,
                                        child: CupertinoTextField(
                                          placeholderStyle:
                                              TextStyle(color: Colors.grey),
                                          placeholder: "Write a message",
                                          smartQuotesType:
                                              SmartQuotesType.enabled,
                                          smartDashesType:
                                              SmartDashesType.enabled,
                                          expands: true,
                                          maxLines: null,
                                          minLines: null,
                                          controller: messageBoxController,
                                          decoration: null,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: SettingsHelper.brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white),
                                          onTap: () {
                                            emojiWidgetisible = false;
                                          },
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 1, 3, 1),
                                        minSize: 25,
                                        child: ClipOval(
                                          child: Container(
                                            color:
                                                Color.fromRGBO(25, 165, 255, 1),
                                            padding:
                                                EdgeInsets.fromLTRB(3, 2, 3, 4),
                                            child: Icon(
                                              CupertinoIcons.up_arrow,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            messages.insert(
                                                0,
                                                Message(
                                                    text: messageBoxController
                                                        .text,
                                                    isSent: true));
                                          });
                                          _listKey.currentState.insertItem(0,
                                              duration:
                                                  Duration(milliseconds: 300));
                                          messageBoxController.clear();
                                        },
                                      )
                                    ],
                                  )))
                        ])),
                Material(
                    color:
                        Colors.black, //set the keyboard background color here
                    child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (_, child) {
                          //after Flutter rendered the frame move the native keyboard, still the keyboard may be a frame ahead sometimes (in debug builds anyway), pretty weird
                          if (Platform.isIOS)
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _methodChannel.invokeMethod(
                                  'kbdown',
                                  _kbHeight +
                                      (_animation.value * _kbHeight) * -1);
                            });

                          return Container(
                            color: Colors.black,
                            width: double.infinity,
                            height: _animation.value * _kbHeight,
                          );
                        }))
              ],
            ),
          )),
      CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        heroTag: "header",
        backgroundColor: SettingsHelper.brightness == Brightness.light
            ? Colors.grey[200].withOpacity(0.5)
            : Colors.grey[900].withOpacity(0.5),
        transitionBetweenRoutes: false,
      ),
      PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: ClipRect(
              child: Container(
            padding: EdgeInsets.fromLTRB(
                10, MediaQuery.of(context).padding.top + 8, 10, 8),
            height: MediaQuery.of(context).padding.top + 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                    tag: tag + "back",
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
                Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Hero(
                      tag: tag + "pic",
                      child: ClipOval(
                          child: Image.asset(
                        image,
                        height: 38,
                      )),
                    )),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ProfileWindow(
                                            chatTag: tag,
                                            name: title,
                                            status: status,
                                            chatType: ChatType.Normal,
                                            bio:
                                                "I'm Elon Musk.\nEveryone know me, duh!\nI'm Billionaire",
                                            photo: image,
                                            email: "elon.musk@musk.com",
                                          )));
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Hero(
                                      flightShuttleBuilder:
                                          _flightShuttleBuilder,
                                      tag: tag + "name",
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          child: Text(
                                            title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "SF-Pro",
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: SettingsHelper.brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                                decoration:
                                                    TextDecoration.none),
                                          ))),
                                  Hero(
                                      flightShuttleBuilder:
                                          _flightShuttleBuilder,
                                      tag: tag + "status",
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              200,
                                          child: Text(
                                            status,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "SF-Pro",
                                                fontSize: 12,
                                                color: SettingsHelper.brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal),
                                          )))
                                ])))),
                Hero(
                    tag: tag + "options",
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
          ))),
    ]);
  }
}
