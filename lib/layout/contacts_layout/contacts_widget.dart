import 'package:Tetron/layout/contacts_layout/contact_item_widget.dart';
import 'package:Tetron/layout/widgets/animated_flip_counter.dart';
import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ContactsWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContactsWindowState();
}

class _ContactsWindowState extends State<ContactsWindow>
    with TickerProviderStateMixin {
  _ContactsWindowState() {
    selectionController = SelectionController(onChanged: () {
      if (selectionController.selectedCount == 1)
        appBarAnimation.forward();
      else if (selectionController.selectedCount == 0)
        appBarAnimation.reverse();
      setState(() {});
    });
    appBarAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  SelectionController selectionController;
  AnimationController appBarAnimation;
  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          SettingsHelper.brightness == Brightness.light ? Colors.white : Colors.black,
      child: Stack(
        children: <Widget>[
          Container(
            child: ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                // ignore: missing_return
                itemBuilder: (context, index) {
                  if (index == 0)
                    return Container(
                      height: MediaQuery.of(context).padding.top + 60,
                    );
                  if (index < 30)
                    return ContactListItem(
                      name: "Anas Taleb",
                      photo: "assets/Images/anas.png",
                      username: "a" + index.toString(),
                      controller: selectionController,
                    );
                }),
          ),
          CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            backgroundColor: SettingsHelper.brightness == Brightness.light
                ? Colors.grey[200].withOpacity(0.5)
                : Colors.grey[900].withOpacity(0.5),
            transitionBetweenRoutes: false,
          ),
          SlideTransition(
              position: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1))
                  .animate(CurvedAnimation(
                      curve: Curves.easeInCubic, parent: appBarAnimation)),
              child: PreferredSize(
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
                            tag: "back",
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
                        Container(
                          padding: EdgeInsets.only(top: 2),
                          child: Text(
                            "Contacts",
                            style: SettingsHelper.defaultTextStyle(
                                color: SettingsHelper.brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Hero(
                            tag: "options",
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
                  )))),
          SlideTransition(
              position: Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0))
                  .animate(CurvedAnimation(
                      curve: Curves.easeInCubic, parent: appBarAnimation)),
              child: PreferredSize(
                  preferredSize: Size.fromHeight(60),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        15, MediaQuery.of(context).padding.top + 8, 15, 8),
                    height: MediaQuery.of(context).padding.top + 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CupertinoButton(
                          padding: EdgeInsets.only(bottom: 2),
                          onPressed: () {
                            selectionController.reset();
                          },
                          child: Icon(
                            EvilIcons.close_o,
                            size: 30,
                            color: SettingsHelper.primary_blue,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(bottom: 1, left: 0),
                            child: AnimatedFlipCounter(
                              duration: Duration(milliseconds: 200),
                              value: selectionController.selectedCount,
                              size: 24,
                              style:
                                  SettingsHelper.defaultTextStyle(fontSize: 20),
                            )),
                        Expanded(
                          child: Container(),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.only(bottom: 2),
                          onPressed: () {
                          },
                          child: Icon(
                            EvilIcons.trash,
                            size: 30,
                            color: Color.fromRGBO(255, 70, 60, 1),
                          ),
                        ),
                      ],
                    ),
                  ))),
        ],
      ),
    );
  }
}
