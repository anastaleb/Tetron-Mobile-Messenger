import 'dart:math';
import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tetron/layout/widgets/toast_widget.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State {
  ScrollController inputs = ScrollController(initialScrollOffset: 0);
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repassword = TextEditingController();
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
    return Container(
            color: SettingsHelper.primary_blue,
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: "background",
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
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
                            padding: EdgeInsets.fromLTRB(25,
                                MediaQuery.of(context).padding.top + 15, 25, 0),
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
                                  onPressed: null,
                                )
                              ],
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width * 5 / 7,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      width: MediaQuery.of(context).size.width *
                                          2.4 /
                                          7,
                                      child: CupertinoTextField(
                                        controller: firstName,
                                        textAlign: TextAlign.center,
                                        placeholder: "First Name",
                                        placeholderStyle: TextStyle(
                                            fontFamily: "SF-Pro",
                                            fontSize: itemHeight / 2.1,
                                            color: Colors.grey),
                                        padding: EdgeInsets.fromLTRB(18,
                                            itemHeight / 4, 18, itemHeight / 4),
                                        style: TextStyle(
                                            fontFamily: "SF-Pro",
                                            fontSize: itemHeight / 2),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      )),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      width: MediaQuery.of(context).size.width *
                                          2.4 /
                                          7,
                                      child: CupertinoTextField(
                                        controller: lastName,
                                        textAlign: TextAlign.center,
                                        placeholder: "Last Name",
                                        placeholderStyle: TextStyle(
                                            fontFamily: "SF-Pro",
                                            fontSize: itemHeight / 2.1,
                                            color: Colors.grey),
                                        padding: EdgeInsets.fromLTRB(18,
                                            itemHeight / 4, 18, itemHeight / 4),
                                        style: TextStyle(
                                            fontFamily: "SF-Pro",
                                            fontSize: itemHeight / 2),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      )),
                                ],
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: CupertinoTextField(
                                    controller: username,
                                    textAlign: TextAlign.center,
                                    placeholder: "Username",
                                    placeholderStyle: TextStyle(
                                        fontFamily: "SF-Pro",
                                        fontSize: itemHeight / 2.1,
                                        color: Colors.grey),
                                    padding: EdgeInsets.fromLTRB(
                                        18, itemHeight / 4, 18, itemHeight / 4),
                                    style: TextStyle(
                                        fontFamily: "SF-Pro",
                                        fontSize: itemHeight / 2),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  )),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: CupertinoTextField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: email,
                                    textAlign: TextAlign.center,
                                    placeholder: "E-mail Address",
                                    placeholderStyle: TextStyle(
                                        fontFamily: "SF-Pro",
                                        fontSize: itemHeight / 2.1,
                                        color: Colors.grey),
                                    padding: EdgeInsets.fromLTRB(
                                        18, itemHeight / 4, 18, itemHeight / 4),
                                    style: TextStyle(
                                        fontFamily: "SF-Pro",
                                        fontSize: itemHeight / 2),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  )),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: CupertinoTextField(
                                    obscureText: true,
                                    controller: password,
                                    textAlign: TextAlign.center,
                                    placeholder: "Password",
                                    placeholderStyle: TextStyle(
                                        fontFamily: "SF-Pro",
                                        fontSize: itemHeight / 2.1,
                                        color: Colors.grey),
                                    padding: EdgeInsets.fromLTRB(
                                        18, itemHeight / 4, 18, itemHeight / 4),
                                    style: TextStyle(
                                        fontFamily: "SF-Pro",
                                        fontSize: itemHeight / 2),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  )),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                  child: CupertinoTextField(
                                    obscureText: true,
                                    controller: repassword,
                                    textAlign: TextAlign.center,
                                    placeholder: "Repaet Password",
                                    placeholderStyle: TextStyle(
                                        fontFamily: "SF-Pro",
                                        fontSize: itemHeight / 2.1,
                                        color: Colors.grey),
                                    padding: EdgeInsets.fromLTRB(
                                        18, itemHeight / 4, 18, itemHeight / 4),
                                    style: TextStyle(
                                        fontFamily: "SF-Pro",
                                        fontSize: itemHeight / 2),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).viewInsets.bottom > 50
                                ? 0
                                : null,
                            padding: EdgeInsets.fromLTRB(0, 0, 0,
                                MediaQuery.of(context).size.height / 8),
                            child: Column(
                              children: <Widget>[
                                Hero(
                                  tag: "signup_btn",
                                  child: CupertinoButton(
                                      disabledColor:
                                          Color.fromARGB(150, 25, 163, 255),
                                      padding:
                                          EdgeInsets.fromLTRB(55, 14, 55, 14),
                                      color: Color.fromARGB(255, 25, 163, 255),
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                            fontFamily: "SF-Pro", fontSize: 20),
                                      ),
                                      onPressed: () {
                                        if (firstName.text == "" ||
                                            email.text == "" ||
                                            password.text == "" ||
                                            username.text == "" ||
                                            repassword.text == "")
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text(
                                                      "Please fill all data"),
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
                                        else if (password.text !=
                                            repassword.text)
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text(
                                                      "Passwords doesn't match"),
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
                                              /*
                                        else if (ClientHelper
                                            .client.connected) {
                                          User user = User();
                                          user.email = email.text;
                                          user.name = firstName.text +
                                              " " +
                                              lastName.text;
                                          user.password = password.text;
                                          user.tag = username.text;
                                          ClientHelper.client.createUser(user);
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
                                          ClientHelper.whenSignup = (errCode) {
                                            if (cancel) return;
                                            responsed = true;
                                            loaading = false;
                                            switch (errCode) {
                                              case User.createUser_Success:
                                                SettingsHelper.myProfile =
                                                    ClientHelper
                                                        .client.currentUser;
                                                SettingsHelper.logged = true;
                                                Navigator.pop(context);
                                                break;
                                              case User
                                                  .createUser_EmailIsNotValid:
                                                Navigator.pop(loader);
                                                showCupertinoDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CupertinoAlertDialog(
                                                        title: Text(
                                                            "This E-mail is not valid"),
                                                        actions: <Widget>[
                                                          CupertinoDialogAction(
                                                            child: Text("Ok"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )
                                                        ],
                                                      );
                                                    });
                                                break;
                                              case User
                                                  .createUser_TagIsNotValid:
                                                Navigator.pop(loader);
                                                showCupertinoDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CupertinoAlertDialog(
                                                        title: Text(
                                                            "Username is not valid"),
                                                        actions: <Widget>[
                                                          CupertinoDialogAction(
                                                            child: Text("Ok"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
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
                                                    child:
                                                        CupertinoPopupSurface(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 20),
                                                          ),
                                                          CupertinoActivityIndicator(
                                                            animating: loaading,
                                                            radius: 15,
                                                          ),
                                                          CupertinoButton(
                                                            padding:
                                                                EdgeInsets.only(
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
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )
                                                        ],
                                                      ),
                                                    ));
                                              });
                                        } else {
                                          connectionToast.show();
                                        }*/
                                      }),
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
