import 'package:flutter/material.dart';

var formDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.yellow[200]),
    borderRadius: BorderRadius.circular(10.0),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Colors.white,
      width: 2.0,
    ),
  ),
  labelStyle: TextStyle(color: Colors.red[300]),
);
