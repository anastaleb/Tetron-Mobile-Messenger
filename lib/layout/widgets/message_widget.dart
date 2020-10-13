import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bubble/bubble.dart';
import 'package:Tetron/utilities/other_tools.dart';

class Message extends StatelessWidget {
  final String text;
  final bool isSent;

  Message({this.text, this.isSent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: Bubble(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        radius: Radius.circular(20),
        nipWidth: 4,
        elevation: 0,
        nipOffset: 3,
        padding: BubbleEdges.fromLTRB(15, 6, 15, 6),
        nip: BubbleNip.no,
        color: isSent
            ? Color.fromARGB(255, 25, 163, 255)
            : Color.fromRGBO(180, 180, 180, 0.3),
        child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 180),
            child: RichText(
              text: TextSpan(
                  children: <InlineSpan>[
                    TextHelper.buildTextSpan(text, TextHelper.mainPatternMap)
                  ],
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.3,
                      color: isSent
                          ? Colors.white
                          : SettingsHelper.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white)),
            )),
      ),
    );
  }
}
