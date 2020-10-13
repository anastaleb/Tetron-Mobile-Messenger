import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ContactListItem extends StatefulWidget {
  final String name;
  final String username;
  final String photo;
  final SelectionController controller;

  const ContactListItem(
      {Key key, this.name, this.username, this.photo, this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ContactItemState(this.name, this.username, this.photo, this.controller);
}

class _ContactItemState extends State<ContactListItem> with Selectable {
  final String name;
  final String username;
  final String photo;
  final SelectionController controller;

  int _selected = 0;

  _ContactItemState(this.name, this.username, this.photo, this.controller) {
    controller.attach(this);
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      color: isSelected
          ? SettingsHelper.brightness == Brightness.light
              ? Colors.grey[300].withOpacity(0.5)
              : Colors.grey[800].withOpacity(0.5)
          : Colors.transparent,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: 50,
              margin: EdgeInsets.only(left: 30, right: 20),
              child: GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      _selected = 0;
                      isSelected = false;
                      setState(() {});
                    } else {
                      _selected = 1;
                      isSelected = true;
                      setState(() {});
                    }
                  },
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                    ClipOval(
                      child: Image.asset(
                        photo,
                        height: 50,
                        width: 50,
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInCubic,
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 25.0 * _selected,
                            color: SettingsHelper.brightness == Brightness.light
                                ? Colors.grey[200].withOpacity(0.8)
                                : Colors.grey[900].withOpacity(0.8),
                          ),
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    Visibility(
                        visible: isSelected,
                        child: Icon(
                          Ionicons.ios_checkmark,
                          size: 50,
                          color: SettingsHelper.primary_blue,
                        ))
                  ]))),
          Expanded(
              child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: SettingsHelper.defaultTextStyle(
                      color: SettingsHelper.brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  "@" + username,
                  style: SettingsHelper.defaultTextStyle(
                      color: SettingsHelper.brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 12),
                )
              ],
            ),
          )),
          Container(
            width: 35,
            margin: EdgeInsets.only(right: 30, left: 20),
            child: CupertinoButton(
              minSize: 35,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(30),
              color: SettingsHelper.primary_blue,
              onPressed: () {},
              child: Icon(
                Ionicons.ios_chatbubbles,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void reset() {
    isSelected = false;
    _selected = 0;
    try {
      setState(() {});
    } catch (e) {}
  }
}

abstract class Selectable {
  bool _isSelected = false;
  bool get isSelected => _isSelected;
  set isSelected(bool value) {
    _isSelected = value;
    onChanged(this);
  }

  void reset() {
    isSelected = false;
  }

  void Function(Selectable) onChanged;
}

class SelectionController {
  void Function() onChanged;
  SelectionController({this.onChanged});

  List<Selectable> _items = List<Selectable>();
  List<Selectable> get items => _items;

  int get selectedCount {
    return items.where((element) => element.isSelected).length;
  }

  int get unselectedCount {
    return items.where((element) => !element.isSelected).length;
  }

  void attach(Selectable item) {
    item.onChanged = _itemChanged;
    _items.add(item);
  }

  void reset() {
    _items.forEach((element) {
      element.reset();
    });
  }

  void _itemChanged(Selectable item) {
    onChanged();
  }
}
