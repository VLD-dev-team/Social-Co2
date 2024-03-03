import 'package:flutter/material.dart';

const Color primaryCardColor = Color.fromRGBO(249, 239, 219, 1);
const Color secondaryCardColor = Color.fromRGBO(235, 217, 180, 1);
const Color tertiaryCardColor = Color.fromRGBO(176, 162, 133, 1);
const Color shadowColor = Color.fromARGB(64, 0, 0, 0);

const BoxDecoration primaryCard = BoxDecoration(
  color: primaryCardColor,
  /* boxShadow: [
    BoxShadow(
      color: shadowColor,
    ),
    BoxShadow(
        color: secondaryCardColor,
        //blurRadius: 4,
        spreadRadius: 0,
        offset: Offset(0, 4)),
  ], */
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);

const BoxDecoration secondaryCardInnerShadow = BoxDecoration(
    color: secondaryCardColor,
    boxShadow: [
      BoxShadow(
        color: shadowColor,
      ),
      BoxShadow(
          color: secondaryCardColor,
          //blurRadius: 4,
          spreadRadius: 0,
          offset: Offset(0, 4)),
    ],
    borderRadius: BorderRadius.all(Radius.circular(5.0)));
