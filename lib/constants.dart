import 'package:flutter/material.dart';

const kPrimaryColor = Colors.deepPurple;
const kSecondaryColor = Colors.teal;

const kInputDecoration = InputDecoration(
  hintText: 'Enter',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kSecondaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kSecondaryColor, width: 2.5),
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
  ),
);
