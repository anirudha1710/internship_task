import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'content_model.dart'; // Import your content model

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  State<Onbording> createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int currentIndex = 0;
  int _selectedIndex = 0;
  bool _isEditing = false;
  final TextEditingController _textController = TextEditingController();
  late PageController _controller;

  final List<String> _fonts = [
    'Roboto', 'Dancing Script', 'Lobster Two', 'Mochiy Pop One', // Add more fonts as needed
  ];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
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
              SizedBox(height: 10),
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
              SizedBox(height: 10),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Font Size: ${contents[_selectedIndex].fontSize.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Slider(
                value: contents[_selectedIndex].fontSize,
                min: 10.0,
                max: 100.0,
                divisions: 90,
                onChanged: (size) {
                  setState(() {
                    contents[_selectedIndex].fontSize = size;
                  });
                },
              ),
              SizedBox(height: 10),
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
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(contents[i].image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: _isEditing && _selectedIndex == i
                        ? Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: TextField(
                        controller: _textController,
                        autofocus: true,
                        onSubmitted: (_) => _updateText(),
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                        ),
                        style: TextStyle(
                          fontSize: contents[i].fontSize,
                          color: contents[i].color,
                          fontFamily: contents[i].fontFamily,
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = i;
                        });
                        _showOptionsBottomSheet();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(55.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            contents[i].texts.join('\n'), // Join texts for display
                            style: TextStyle(
                              fontSize: contents[i].fontSize,
                              color: contents[i].color,
                              fontFamily: contents[i].fontFamily,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
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
              icon: Icon(Icons.arrow_left, color: Colors.black, size: 50),
              onPressed: () {
                if (currentIndex > 0) {
                  _controller.previousPage(
                    duration: Duration(milliseconds: 300),
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
              icon: Icon(Icons.arrow_right, color: Colors.black, size: 50),
              onPressed: () {
                if (currentIndex < contents.length - 1) {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
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
      margin: EdgeInsets.only(right: 5, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }
}
