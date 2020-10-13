import 'package:flutter/material.dart';

class MyPopUpMenueItem<T> extends PopupMenuItem<T> {
  final Function onClic;
  final Widget child;

  MyPopUpMenueItem({@required this.child, @required this.onClic})
      : super(child: child);

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopUpmenueState();
  }
}

class MyPopUpmenueState<T, PopupMenuItem>
    extends PopupMenuItemState<T, MyPopUpMenueItem<T>> {
  @override
  void handleTap() {
    widget.onClic();
  }
}
