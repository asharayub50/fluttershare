import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false, String titleText, removeBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeBackButton ? false : true,
    title: Text(
      isAppTitle ? 'Flutter Social App' : titleText,
      style: TextStyle(
        fontFamily: isAppTitle ? 'Signatra' : "",
        fontSize: isAppTitle ? 50 : 22,
      ),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    centerTitle: true,
  );
}
