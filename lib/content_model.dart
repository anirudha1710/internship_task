import 'package:flutter/material.dart';

class UnbordingContent {
  String image;
  String text;
  double fontSize;
  String fontFamily;
  Color color;


  UnbordingContent({required this.image, required this.text, this.fontSize = 24.0,this.fontFamily = 'Roboto',this.color = Colors.black,});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    text: 'we are inviting you and your familys gracious presence and blessing',
    image: 'asset/bg.png',
  ),
  UnbordingContent(
    text: '',
    image: 'asset/bg.png',
  ),
  UnbordingContent(
    text:
        'Most of us have childhood memories of gaping at our elders in wonder when they narrated to us the amusing fables of Aesop, the picturesque fairy tales, the funny anecdotes, the lyrical short stories, and so on. Classic bedtime stories take us into the world of imagination. These short stories are identified with brevity and compact narrative.',
    image: 'asset/bg.png',
  ),
];
