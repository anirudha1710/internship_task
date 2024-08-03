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
    texts: ['We are inviting you and your family\'s gracious presence and blessing.'],
    image: 'asset/bg.png',
  ),
  UnbordingContent(
    texts: [''],
    image: 'asset/bg.png',
  ),
  UnbordingContent(
    texts: [
      'Most of us have childhood memories of gaping at our elders in wonder when they narrated to us the amusing fables of Aesop, the picturesque fairy tales, the funny anecdotes, the lyrical short stories, and so on.','Most of us have childhood memories of gaping at our elders in wonder when they narrated to us the amusing fables of Aesop, the picturesque fairy tales, the funny anecdotes, the lyrical short stories, and so on.',
      ' '
          'the picturesque fairy tales, the funny anecdotes, the lyrical short stories, and so on.',
    ],
    image: 'asset/bg.png',
  ),
];