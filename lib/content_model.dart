import 'package:flutter/material.dart';

class UnbordingContent {
  String image;
  List<String> texts; // Changed from String to List<String>
  double fontSize;
  String fontFamily;
  Color color;

  UnbordingContent({
    required this.image,
    required this.texts, // Updated to List<String>
    this.fontSize = 16.0,
    this.fontFamily = 'Roboto',
    this.color = Colors.black,
  });
}

List<UnbordingContent> contents = [
  UnbordingContent(
    texts: ['We are inviting you and your family\'s gracious presence and blessing.'],
    image: 'asset/bg.png',
  ),
  UnbordingContent(
    texts: ['Please join us for a memorable evening filled with joy and celebration.'],
    image: 'asset/bg.png',
  ),
  UnbordingContent(
    texts: [
      'Most of us have childhood memories of gaping at our elders in wonder when they narrated to us the amusing fables of Aesop, the picturesque fairy tales, the funny anecdotes, the lyrical short stories, and so on.',
      '',
      'Classic bedtime stories take us into the world of imagination. These short stories are identified with brevity and compact narrative.',
      '',
      'Classic bedtime stories take us into the world of imagination. These short stories are identified with brevity and compact narrative.'
    ],
    image: 'asset/bg.png',
  ),
];