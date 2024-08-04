import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'content_model.dart'; // Import your content model

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentIndex = 0;
  int _selectedIndex = 0;
  bool _isEditing = false;
  final TextEditingController _textController = TextEditingController();
  late PageController _controller;
  double _initTextSize = 16.0;
  double _scaleFactor = 1.0; // Track the scale factor

  late bool isTapped = false;
  int _currentPage = 0;


  final List<String> _fonts = [
    'Roboto', 'Dancing Script', 'Lobster Two',
    'Mochiy Pop One', // Add more fonts as needed
  ];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!.round();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _editText() {
    setState(() {
      _isEditing = true;
      // Combine texts into a single string with line breaks
      _textController.text = contents[_selectedIndex].texts.join('\n');
    });
  }

  void _updateText() {
    setState(() {
      // Split the text by line breaks into a list
      contents[_selectedIndex].texts = _textController.text.split('\n');
      _isEditing = false;
    });
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Text'),
                onTap: () {
                  Navigator.of(context).pop();
                  _editText();
                },
              ),
              ListTile(
                leading: const Icon(Icons.font_download),
                title: const Text('Font'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showFontPicker();
                },
              ),
              ListTile(
                leading: const Icon(Icons.format_size),
                title: const Text('Font Size'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showFontSizePicker();
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Color'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showColorPicker();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFontPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Font'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _fonts.map((font) {
              return ListTile(
                title: Text(
                  font,
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  setState(() {
                    contents[_selectedIndex].fontFamily = font;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Color', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              ColorPicker(
                pickerColor: contents[_selectedIndex].color,
                onColorChanged: (color) {
                  setState(() {
                    contents[_selectedIndex].color = color;
                  });
                },
                showLabel: false,
                pickerAreaHeightPercent: 0.6,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFontSizePicker() {
    double sliderval = contents[_selectedIndex].fontSize;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return StatefulBuilder(builder: (context, sets) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Font Size: ${contents[_selectedIndex].fontSize.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Slider(
                  value: sliderval,
                  min: 10.0,
                  max: 100.0,
                  divisions: 90,
                  onChanged: (size) {
                    sets(() {
                      sliderval = size;
                      contents[_selectedIndex].fontSize = size;
                      _initTextSize = size;
                    });
                    setState(() {
                      contents[_selectedIndex].fontSize = size;
                    });
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
      },
    );
  }


  double? _textSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: contents.length,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, i) {
              bool isPageTwo = i == 2;
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 38.0, vertical: 38.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(contents[i].image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: contents[i].dx,
                    top: contents[i].dy,
                    child: _isEditing && _selectedIndex == i
                        ? Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            child: TextField(
                              maxLines: null,
                              onTapOutside: (event) {
                                print('onTapOutside');
                                FocusManager.instance.primaryFocus?.unfocus();
                                _updateText();
                              },
                              controller: _textController,
                              autofocus: false,
                              onSubmitted: (_) => _updateText(),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                fillColor: Colors.transparent,
                                filled: true,
                              ),
                              style: TextStyle(
                                fontSize: contents[i].fontSize,
                                color: contents[i].color,
                                fontFamily: contents[i].fontFamily,
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = i;
                                  });
                                  _showOptionsBottomSheet();
                                },
                                onScaleUpdate: (details) {
                                  setState(() {
                                    _textSize = _initTextSize +
                                        (_initTextSize * (details.scale * .35));
                                    contents[i].fontSize = _textSize!;
                                  });
                                },
                                onScaleEnd: (ScaleEndDetails details) {
                                  setState(() {
                                    contents[i].fontSize = _textSize!;
                                  });
                                },
                                child: Draggable(
                                  feedback: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width -
                                          38 * 2,
                                      child: Container(
                                        // color: Colors.yellow,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.black,
                                        )),
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          contents[i].texts.join('\n'),
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: contents[i].fontSize,
                                            color: contents[i].color,
                                            fontFamily:
                                                contents[i].fontFamily,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Container(),
                                  child: DottedBorder(
                                    padding: EdgeInsets.all(0.8),
                                    color: Colors.transparent, // Border color
                                    strokeWidth: 2, // Border width
                                    dashPattern: [
                                      4,
                                      2
                                    ], // Pattern of dashes and gaps
                                    borderType: BorderType.RRect,
                                    child: SizedBox(
                                      width: isPageTwo
                                          ? null
                                          : MediaQuery.of(context).size.width - 40 * 2,
                                      child: Text(
                                        contents[i].texts.join('\n'),
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: contents[i].fontSize,
                                          color: contents[i].color,
                                          fontFamily: contents[i].fontFamily,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  onDragEnd: (details) {
                                    setState(() {
                                      contents[i].dx = details.offset.dx;
                                      contents[i].dy = details.offset.dy - 80;

                                      if (contents[i].dx < 38) {
                                        contents[i].dx = 38;
                                      }
                                      if (contents[i].dx > MediaQuery.of(context).size.width - 38) {
                                        contents[i].dx = MediaQuery.of(context).size.width - 38;
                                      }
                                      if (contents[i].dy < 38) {
                                        contents[i].dy = 38;
                                      }
                                      if (contents[i].dy > MediaQuery.of(context).size.height - 38) {
                                        contents[i].dy = MediaQuery.of(context).size.height - 38;
                                      }
                                    });
                                  },
                                  onDragUpdate: (details) {
                                    setState(() {
                                      contents[i].dx = details.delta.dx;
                                      contents[i].dy = details.delta.dy;
                                      contents[i].dy = details.delta.dy;
                                    });
                                  },
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: GestureDetector(
                                  onPanUpdate: (details) {
                                    setState(() {
                                      _scaleFactor += details.delta.dy * 0.01;
                                      _scaleFactor =
                                          _scaleFactor.clamp(0.5, 6.0);
                                      contents[i].fontSize =
                                          _initTextSize * _scaleFactor;
                                    });
                                  },
                                  onPanEnd: (details) {
                                    _initTextSize = contents[i].fontSize;
                                  },
                                  onTap: () {
                                    isTapped = !isTapped;
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: isTapped ? Colors.white : Colors.transparent,
                                    //color: Colors.white ,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            left: -10,
            top: MediaQuery.of(context).size.height * 0.4,
            child: IconButton(
              icon: const Icon(Icons.arrow_left, color: Colors.black, size: 50),
              onPressed: () {
                if (currentIndex > 0) {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            right: -10,
            top: MediaQuery.of(context).size.height * 0.4,
            child: IconButton(
              icon:
                  const Icon(Icons.arrow_right, color: Colors.black, size: 50),
              onPressed: () {
                if (currentIndex < contents.length - 1) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.5 - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
    );
  }
}
