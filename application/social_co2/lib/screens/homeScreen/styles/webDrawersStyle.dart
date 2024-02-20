import 'package:flutter/material.dart';

const LinearGradient drawerBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 108, 163, 94),
      Color.fromARGB(255, 99, 136, 137)
    ]);

const BoxDecoration drawerTileShadow = BoxDecoration(
  borderRadius:
      BorderRadius.horizontal(right: Radius.circular(25), left: Radius.zero),
  boxShadow: [
    BoxShadow(color: Color.fromARGB(99, 66, 66, 66)),
    BoxShadow(
      color: Colors.white,
      offset: Offset(0, 2),
      blurRadius: 1,
      spreadRadius: -1,
    )
  ],
);
