import 'dart:math';
import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tetron/layout/widgets/toast_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    var connectionToast = Toast(
        duration: Duration(seconds: 5),
        background: Color.fromRGBO(50, 50, 50, 0.6),
        content: Text(
          "Unable to connect to server",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "SF-Pro",
              fontSize: 18,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none),
        ),
        top: MediaQuery.of(context).size.height / 5);

    double itemHeight = sqrt(MediaQuery.of(context).size.height) / 0.82;
    itemHeight = itemHeight > 36 ? 36 : itemHeight;

    TextEditingController email = TextEditingController();
    TextEditingController pass = TextEditingController();
    return Container(
        color: Color.fromARGB(255, 25, 163, 255),
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "background",
              child: Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(
                            MediaQuery.of(context).size.width, 120))),
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            25, MediaQuery.of(context).padding.top + 15, 25, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CupertinoButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontFamily: "SF-Pro",
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Hero(
                              tag: "Tetron",
                              child: Text(
                                "Tetron",
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontFamily: "LeckerliOne",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 48),
                              ),
                            ),
                            CupertinoButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontFamily: "SF-Pro",
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {},
                            )
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 7,
                          0,
                          MediaQuery.of(context).size.width / 7,
                          0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: CupertinoTextField(
                                textAlign: TextAlign.center,
                                placeholder: "E-mail Address",
                                placeholderStyle: TextStyle(
                                    fontFamily: "SF-Pro",
                                    fontSize: itemHeight / 2,
                                    color: Colors.grey),
                                padding: EdgeInsets.fromLTRB(
                                    18, itemHeight / 4, 18, itemHeight / 4),
                                style: TextStyle(
                                    fontFamily: "SF-Pro",
                                    fontSize: itemHeight / 2),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(25)),
                              )),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: CupertinoTextField(
                                textAlign: TextAlign.center,
                                placeholder: "Password",
                                placeholderStyle: TextStyle(
                                    fontFamily: "SF-Pro",
                                    fontSize: itemHeight / 2,
                                    color: Colors.grey),
                                padding: EdgeInsets.fromLTRB(
                                    18, itemHeight / 4, 18, itemHeight / 4),
                                style: TextStyle(
                                    fontFamily: "SF-Pro",
                                    fontSize: itemHeight / 2),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(25)),
                              ))
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, 0, MediaQuery.of(context).size.height / 11),
                        child: Column(
                          children: <Widget>[
                            Hero(
                              tag: "login_btn",
                              child: CupertinoButton(
                                color: Color.fromARGB(255, 25, 163, 255),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontFamily: "SF-Pro", fontSize: 20),
                                ),
                                onPressed: () {
                                  SettingsHelper.logged = true;
                                  Navigator.pushNamed(context, "/home");
                                  return;
                                  /*
                                  if (ClientHelper.client.connected) {
                                    User user = User();
                                    user.email = email.text;
                                    user.password = pass.text;
                                    ClientHelper.client.loginUser(user);
                                    bool responsed = false;
                                    bool cancel = false;
                                    bool loaading = true;
                                    BuildContext loader;
                                    // ignore: unused_local_variable
                                    Timer logging =
                                        Timer(Duration(seconds: 10), () {
                                      if (!responsed && !cancel) {
                                        Navigator.pop(loader);
                                        connectionToast.show();
                                      }
                                    });
                                    ClientHelper.whenLogin = (errCode) {
                                      if (cancel) return;
                                      responsed = true;
                                      loaading = false;
                                      switch (errCode) {
                                        case User.loginUser_Success:
                                          SettingsHelper.myProfile =
                                              ClientHelper.client.currentUser;
                                          SettingsHelper.logged = true;
                                          Navigator.pop(context);
                                          break;
                                        default:
                                          Navigator.pop(loader);
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text(
                                                      "Username or Password is incorrect"),
                                                  actions: <Widget>[
                                                    CupertinoDialogAction(
                                                      child: Text("Ok"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              });
                                          break;
                                      }
                                    };
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          loader = context;
                                          return Container(
                                              width: 100,
                                              height: 100,
                                              child: CupertinoPopupSurface(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 20),
                                                    ),
                                                    CupertinoActivityIndicator(
                                                      animating: loaading,
                                                      radius: 15,
                                                    ),
                                                    CupertinoButton(
                                                      padding: EdgeInsets.only(
                                                          bottom: 80),
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "SF-Pro",
                                                            fontSize: 18,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ),
                                                      onPressed: () {
                                                        cancel = true;
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ));
                                        });
                                  } else {
                                    connectionToast.show();
                                  }*/
                                },
                              ),
                            ),
                            CupertinoButton(
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    fontFamily: "SF-Pro",
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                              ),
                              onPressed: () {},
                            )
                          ],
                        ))
                  ],
                )),
            connectionToast
          ],
        ));
  }
}
