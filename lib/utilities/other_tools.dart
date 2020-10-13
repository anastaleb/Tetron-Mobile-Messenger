import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
class ClientHelper {
  static Client client;
  static Function(int) whenLogin;
  static Function(int) whenSignup;

  ClientHelper() {
    client =
        Client("/storage/emulated/0/Android/data/com.tetra.mobile/log.txt");
    client.onConnect = ClientHelper.onConnect;
    client.onLoginResult = ClientHelper.onLoginResult;
    client.onCreateUser = ClientHelper.onCreateUser;
    client.onMessageReceive = ClientHelper.onMessageRecieve;
    client.onUserInfoResult = ClientHelper.onUserInfoResult;
    client.connect();
  }

  static void onConnect(SecureSocket socket) {}
  static void onCreateUser(int errCode) {
    whenSignup(errCode);
  }

  static void onLoginResult(int errCode) {
    whenLogin(errCode);
  }

  static void onUserInfoResult(User user) {}
  static void onMessageRecieve(TeMsg.Message message) {}
}
*/

class TextHelper {
  static Map<RegExp, TextStyle> mainPatternMap = {
    RegExp(r"[*]\S+[*]"): TextStyle(fontWeight: FontWeight.bold),
    RegExp(r"[-]\S+[-]"): TextStyle(decoration: TextDecoration.lineThrough),
    RegExp(r"[#]\S+"): TextStyle(color: CupertinoColors.link),
    RegExp(r"[^\u0000-\u1000]*[^\u0000-\u1000]"): TextStyle(letterSpacing: 1.5),
  };

  static TextSpan buildTextSpan(String text, Map<RegExp, TextStyle> patternMap,
      {TextStyle style}) {
    List<TextSpan> children = [];
    RegExp allRegex;
    allRegex = RegExp(patternMap.keys.map((e) => e.pattern).join('|'));

    text.splitMapJoin(
      allRegex,
      onMatch: (Match m) {
        RegExp k = patternMap.entries.singleWhere((element) {
          return element.key.allMatches(m[0]).isNotEmpty;
        }).key;
        children.add(
          TextSpan(
            text: m[0],
            style: patternMap[k],
          ),
        );
        return m[0];
      },
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
    );
    return TextSpan(children: children, style: style);
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: Tween<double>(begin: -1.9, end: 1).animate(animation),
            child: child,
          ),
        );
}

enum ChatType { Normal, Group }
