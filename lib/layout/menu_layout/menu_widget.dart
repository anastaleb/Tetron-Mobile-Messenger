import 'package:Tetron/layout/contacts_layout/contacts_widget.dart';
import 'package:Tetron/layout/profile_layout/managed_profile.dart';
import 'package:Tetron/layout/widgets/item_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:Tetron/layout/main_layout/main_window.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MenuScrollPhysics extends BouncingScrollPhysics {
  MenuScrollPhysics({parent}) : super(parent: parent);
  @override
  double get minFlingVelocity => 0;
  @override
  double get maxFlingVelocity => double.infinity;
  @override
  double get minFlingDistance => 0;
  @override
  double frictionFactor(double overscrollFraction) {
    return 1;
  }

  @override
  MenuScrollPhysics applyTo(ScrollPhysics physics) {
    return MenuScrollPhysics(parent: physics);
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              '$runtimeType.applyBoundaryConditions() was called redundantly.'),
          ErrorDescription(
              'The proposed new position, $value, is exactly equal to the current position of the '
              'given ${position.runtimeType}, ${position.pixels}.\n'
              'The applyBoundaryConditions method should only be called when the value is '
              'going to actually change the pixels, otherwise it is redundant.'),
          DiagnosticsProperty<ScrollPhysics>(
              'The physics object in question was', this,
              style: DiagnosticsTreeStyle.errorProperty),
          DiagnosticsProperty<ScrollMetrics>(
              'The position object in question was', position,
              style: DiagnosticsTreeStyle.errorProperty)
        ]);
      }
      return true;
    }());
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) // overscroll
      return value - position.pixels;
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) // hit bottom edge
      return value - position.maxScrollExtent;
    return 0;
  }
}

class MenuWindow extends StatefulWidget {
  final MyHomePageState homePage;
  final AnimationController buildAnimationController;
  final Future<void> Function() onClose;

  const MenuWindow({
    Key key,
    this.homePage,
    this.buildAnimationController,
    this.onClose,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MenuWindow();
}

class _MenuWindow extends State<MenuWindow> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ScrollController page = ScrollController();
    return WillPopScope(
        onWillPop: () {
          super.widget.buildAnimationController.reverse().whenComplete(() {
            super.widget.onClose();
          });
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    super
                        .widget
                        .buildAnimationController
                        .reverse()
                        .whenComplete(() {
                      super.widget.onClose();
                    });
                  },
                  child: Container(
                    color: Color.fromARGB(50, 0, 0, 0),
                  ),
                ),
                AnimatedBuilder(
                  animation: super.widget.buildAnimationController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                          .animate(CurvedAnimation(
                              curve: Curves.easeOut,
                              parent: super.widget.buildAnimationController)),
                      child: Listener(
                          onPointerUp: (d) {
                            if (page.position.pixels <= -150)
                              super
                                  .widget
                                  .buildAnimationController
                                  .reverse()
                                  .whenComplete(() {
                                super.widget.onClose();
                              });
                          },
                          child: ListView(
                            padding: EdgeInsets.zero,
                            controller: page,
                            physics: MenuScrollPhysics(),
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  super
                                      .widget
                                      .buildAnimationController
                                      .reverse()
                                      .whenComplete(() {
                                    super.widget.onClose();
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                ),
                              ),
                              AnimatedContainer(
                                width: MediaQuery.of(context).size.width,
                                height: 760,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                    color: SettingsHelper.brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Color.fromRGBO(20, 20, 20, 1),
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                child: Column(children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Color.fromARGB(
                                                  128, 128, 128, 128)),
                                          height: 4,
                                          width: 36,
                                          margin: EdgeInsets.only(top: 8),
                                        )
                                      ]),
                                  Container(
                                    height: 58,
                                    padding: EdgeInsets.fromLTRB(42, 0, 30, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Have a nice day!",
                                          style:
                                              SettingsHelper.defaultTextStyle(
                                                  color: SettingsHelper
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                  decoration:
                                                      TextDecoration.none),
                                        ),
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          child: Icon(CupertinoIcons.clear,
                                              size: 40,
                                              color:
                                                  SettingsHelper.brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : Colors.white),
                                          onPressed: () {
                                            super
                                                .widget
                                                .buildAnimationController
                                                .reverse()
                                                .whenComplete(() {
                                              super.widget.onClose();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 3,
                                    alignment: Alignment.center,
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                              90),
                                      height: 1,
                                      color: SettingsHelper.brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    child: CupertinoButton(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 25, 0),
                                      child: Row(
                                        children: <Widget>[
                                          ClipOval(
                                              child: Image.asset(
                                            "assets/Images/anas.png",
                                            width: 45,
                                          )),
                                          Padding(
                                            padding: EdgeInsets.only(left: 25),
                                            child: Text(
                                              "My Profile",
                                              style: TextStyle(
                                                  color: SettingsHelper
                                                              .brightness ==
                                                          Brightness.light
                                                      ? Colors.black
                                                      : Colors.white,
                                                  fontFamily: "SF-Pro",
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        super
                                            .widget
                                            .buildAnimationController
                                            .reverse()
                                            .whenComplete(() {
                                          super
                                              .widget
                                              .onClose()
                                              .whenComplete(() {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (c) =>
                                                        ManagedProfileWindow(
                                                          name: "Anas Taleb",
                                                          chatTag: "AnasT9",
                                                          bio:
                                                              "God Bless America",
                                                          email:
                                                              "anast9@usa.gov",
                                                          photo:
                                                              "assets/Images/anas.png",
                                                        )));
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    child: CupertinoButton(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 25, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Ionicons.ios_contacts,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
                                            size: 45,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 25),
                                            child: Text("Contacts",
                                                style: TextStyle(
                                                    color: SettingsHelper
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontFamily: "SF-Pro",
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        super
                                            .widget
                                            .buildAnimationController
                                            .reverse()
                                            .whenComplete(() {
                                          super
                                              .widget
                                              .onClose()
                                              .whenComplete(() {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (c) =>
                                                        ContactsWindow()));
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 70,
                                    child: CupertinoButton(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 25, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            SettingsHelper.brightness ==
                                                    Brightness.light
                                                ? Ionicons.ios_sunny
                                                : Ionicons.ios_moon,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
                                            size: 45,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 25),
                                            child: Text("Brightness",
                                                style: TextStyle(
                                                    color: SettingsHelper
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontFamily: "SF-Pro",
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (c) => ItemPicker(
                                                  controller: FixedExtentScrollController(
                                                      initialItem: SettingsHelper
                                                              .autoDark
                                                          ? 0
                                                          : SettingsHelper
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? 1
                                                              : 2),
                                                  children: <Widget>[
                                                    Center(
                                                        child: Text(
                                                      "Auto Light/Dark",
                                                      style: SettingsHelper
                                                          .defaultTextStyle(
                                                              fontSize: 24),
                                                    )),
                                                    Center(
                                                        child: Text(
                                                      "Light",
                                                      style: SettingsHelper
                                                          .defaultTextStyle(
                                                              fontSize: 24),
                                                    )),
                                                    Center(
                                                        child: Text(
                                                      "Dark",
                                                      style: SettingsHelper
                                                          .defaultTextStyle(
                                                              fontSize: 24),
                                                    )),
                                                  ],
                                                  onSelectedChanged: (index) {
                                                    switch (index) {
                                                      case 0:
                                                        SettingsHelper
                                                            .autoDark = true;
                                                        break;
                                                      case 1:
                                                        SettingsHelper
                                                                .brightness =
                                                            Brightness.light;
                                                        SettingsHelper
                                                            .autoDark = false;
                                                        break;
                                                      case 2:
                                                        SettingsHelper
                                                                .brightness =
                                                            Brightness.dark;
                                                        SettingsHelper
                                                            .autoDark = false;
                                                        break;
                                                    }
                                                    setState(() {});
                                                    super
                                                        .widget
                                                        .homePage
                                                        .setState(() {});
                                                  },
                                                ));
                                        /*
                                        SettingsHelper.brightness ==
                                                Brightness.light
                                            ? SettingsHelper.brightness =
                                                Brightness.dark
                                            : SettingsHelper.brightness =
                                                Brightness.light;
                                        setState(() {});
                                        super.widget.homePage.setState(() {});
                                        */
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 370,
                                  ),
                                  Container(
                                    height: 70,
                                    child: CupertinoButton(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 25, 0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Ionicons.ios_log_out,
                                            color: SettingsHelper.brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
                                            size: 45,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 25),
                                            child: Text("Log Out",
                                                style: TextStyle(
                                                    color: SettingsHelper
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontFamily: "SF-Pro",
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        super
                                            .widget
                                            .buildAnimationController
                                            .reverse()
                                            .whenComplete(() {
                                          super.widget.onClose();
                                        });
                                        SettingsHelper.logged = false;
                                        setState(() {});
                                        super.widget.homePage.setState(() {});
                                      },
                                    ),
                                  ),
                                  Container(
                                    color: SettingsHelper.brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : Colors.black,
                                    height:
                                        MediaQuery.of(context).padding.bottom,
                                  ),
                                ]),
                              ),
                            ],
                          )),
                    );
                  },
                )
              ],
            )));
  }
}
