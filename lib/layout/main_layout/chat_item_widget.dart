import 'package:flutter/widgets.dart';
import 'package:Tetron/layout/chat_layout/chat_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tetron/utilities/other_tools.dart';
import 'package:Tetron/utilities/settings.dart';

class ChatItem {
  ChatItem(
      {Key key,
      this.tag = "",
      this.title,
      this.lastMessage,
      this.time,
      this.newMessages = 0,
      this.imagePath});
  final String title;
  final String tag;
  final String lastMessage;
  final DateTime time;
  final int newMessages;
  final String imagePath;
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

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SettingsHelper.setDirectories(),
        builder: (context, snap) => GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (c) => ChatWindow(
                      tag: tag,
                      title: title,
                      status: "online",
                      image: imagePath,
                    ),
                  ));
            },
            child: Stack(children: <Widget>[
              Padding(
                  padding:
                      EdgeInsets.only(right: MediaQuery.of(context).size.width),
                  child: Hero(
                      tag: tag + "back",
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(),
                        onPressed: () {},
                      ))),
              Padding(
                  padding:
                      EdgeInsets.only(left: MediaQuery.of(context).size.width),
                  child: Hero(
                      tag: tag + "options",
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(),
                        onPressed: () {},
                      ))),
              AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  color: SettingsHelper.brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                  height: 75,
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: 50,
                          child: Hero(
                              tag: tag + "pic",
                              child: ClipOval(child: Image.asset(imagePath)))),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(18, 3, 10, 3),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Hero(
                                  flightShuttleBuilder: _flightShuttleBuilder,
                                  tag: tag + "name",
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: "SF-Pro",
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.light
                                                ? Colors.black
                                                : Colors.white,
                                            decoration: TextDecoration.none),
                                      ))),
                              Hero(
                                  flightShuttleBuilder: _flightShuttleBuilder,
                                  tag: tag + "status",
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: RichText(
                                        text: TextHelper.buildTextSpan(
                                            lastMessage,
                                            TextHelper.mainPatternMap,
                                            style: TextStyle(
                                                fontFamily: "SF-Pro",
                                                fontSize: 15,
                                                color:
                                                    SettingsHelper.brightness ==
                                                            Brightness.light
                                                        ? Colors.black
                                                        : Colors.white,
                                                decoration: TextDecoration.none,
                                                fontWeight: FontWeight.normal)),
                                        overflow: TextOverflow.ellipsis,
                                      )))
                            ]),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 4, bottom: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Opacity(
                                opacity: newMessages == 0 ? 0 : 1,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  padding: EdgeInsets.fromLTRB(6.5, 3, 7, 2),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 25, 163, 255)),
                                  child: Text(newMessages.toString(),
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white)),
                                )),
                            Text(
                              time.hour.toString().padLeft(2, '0') +
                                  ":" +
                                  time.minute.toString().padLeft(2, '0'),
                              style: TextStyle(
                                  color: SettingsHelper.brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ])));
  }
}
