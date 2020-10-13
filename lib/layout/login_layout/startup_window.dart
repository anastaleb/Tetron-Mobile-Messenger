import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_window.dart';
import 'signup_window.dart';

class LoginWindow extends StatefulWidget {

  const LoginWindow({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LoginWindowState();
}

class LoginWindowState extends State<LoginWindow> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: SettingsHelper.primary_blue,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4,
          padding: EdgeInsets.fromLTRB(
              0, MediaQuery.of(context).padding.top + 30, 0, 30),
          child: Image.asset(
            "assets/icons/Tetron.png",
            height: 110,
            width: 110,
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 4 -
                    MediaQuery.of(context).padding.top),
            child: Hero(
                tag: "background",
                child: Container(
                  margin:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(
                            MediaQuery.of(context).size.width,
                            MediaQuery.of(context).size.width / 3.5)),
                  ),
                ))),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 70, bottom: 15),
                child: Text(
                  "Welcome to",
                  style: SettingsHelper.defaultTextStyle(fontSize: 24,color: Colors.black),
                ),
              ),
              Container(
                  child: Hero(
                      tag: "Tetron",
                      child: Text(
                        "Tetron",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            fontFamily: "LeckerliOne",
                            fontSize: 48,
                            fontWeight: FontWeight.normal),
                      ))),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Hero(
                      tag: "login_btn",
                      child: CupertinoButton(
                        color: Color.fromARGB(255, 25, 163, 255),
                        child: Text("Login",
                            style:
                                TextStyle(fontFamily: "SF-Pro", fontSize: 20)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (context, animation, anime) =>
                                      LoginPage()));
                        },
                      )),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 10, 0, MediaQuery.of(context).size.height / 15),
                      child: Hero(
                          tag: "signup_btn",
                          child: CupertinoButton(
                            padding: EdgeInsets.fromLTRB(55, 14, 55, 14),
                            color: Color.fromARGB(255, 25, 163, 255),
                            child: Text("Sign up",
                                style: TextStyle(
                                    fontFamily: "SF-Pro", fontSize: 20)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation, anime) =>
                                              SignUpPage()));
                            },
                          )))
                ],
              ))
            ],
          ),
        )
      ],
    );
  }
}
