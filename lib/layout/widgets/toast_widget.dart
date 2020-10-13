import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class Toast extends StatefulWidget {
  final Widget content;
  final Color background;
  final double top;
  final Duration duration;

  Toast({this.duration, this.top, this.content, this.background});

  void show() {
    _show();
  }


  Function _show = () {};

  @override
  State<StatefulWidget> createState() => _Toast(
      top: top, content: content, background: background, duration: duration);
}

class _Toast extends State<Toast> {
  final Widget content;
  final Color background;
  final double top;
  final Duration duration;
  double height = 0;

  _Toast({this.duration, this.top, this.content, this.background});
  double currentTop = 0;

  @override
  void initState() {
    super.initState();
    super.widget._show = showUp;
  }

  void showUp() {
    currentTop = top;
    height = 80;
    setState(() {});
    // ignore: unused_local_variable
    Timer ender = Timer(duration, () {
      hidee();
    });
  }

  void hidee() {
    currentTop = 0;
    height = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      bottom: currentTop,
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), color: background),
        padding: EdgeInsets.fromLTRB(15, 8, 15, 10),
        child: content,
      )),
    );
  }
}
