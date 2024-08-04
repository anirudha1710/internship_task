import 'package:flutter/material.dart';

class UnbordingContent {
  String image;
  List<String> texts;
  double fontSize;
  String fontFamily;
  Color color;
  double dx;
  double dy;

  UnbordingContent({
    required this.image,
    required this.texts,
    this.fontSize = 16.0,
    this.fontFamily = 'Roboto',
    this.color = Colors.black,
    this.dx = 38.0,
    this.dy = 38.0,
  });
}

List<UnbordingContent> contents = [
  UnbordingContent(
    texts: ['We are inviting you.'],
    image: 'asset/bg.png',
  ),
  UnbordingContent(
    texts: [],
    image: 'asset/bg.png',
  ),
  UnbordingContent(
    texts: [
      'Most of us.',
      ' '
          'the picturesque fairy tales.',
    ],
    image: 'asset/bg.png',
  ),
];