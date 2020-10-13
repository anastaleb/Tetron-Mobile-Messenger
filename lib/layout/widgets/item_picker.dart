import 'package:Tetron/utilities/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemPicker extends StatefulWidget {
  final void Function(int) onSelectedChanged;
  final List<Widget> children;
  final FixedExtentScrollController controller;

  const ItemPicker({Key key, this.onSelectedChanged, this.children, this.controller})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ItemPickerState();
}

class _ItemPickerState extends State<ItemPicker> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      color: SettingsHelper.brightness == Brightness.light
          ? Colors.white
          : Color.fromRGBO(20, 20, 20, 1),
      height: 300,
      child: CupertinoPicker(
        scrollController: super.widget.controller,
        itemExtent: 50,
        children: super.widget.children,
        onSelectedItemChanged: (index) {
          super.widget.onSelectedChanged(index);
          setState(() {});
        },
      ),
    );
  }
}
