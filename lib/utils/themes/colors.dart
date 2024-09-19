import 'dart:math';

import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF0961F5);
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color shadowColor = Colors.grey;
const Color boxColor = Color.fromARGB(255, 116, 164, 246);
const Color shimmerBaseColor = Color.fromARGB(255, 229, 226, 226);
const Color shimmerHighLightColor = Color.fromARGB(255, 218, 214, 214);

List<Color> colorList = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.indigo,
  Colors.lime,
  Colors.amber,
];

Color getRandomColor() {
  final random = Random();
  return colorList[random.nextInt(colorList.length)];
}
