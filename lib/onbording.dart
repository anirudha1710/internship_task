import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'content_model.dart'; // Import your content model

class Onbording extends StatefulWidget {
  const Onbording({super.key});

  @override
  State<Onbording> createState() => _OnbordingState();
}

class _OnbordingState extends State<Onbording> {
  int _selectedIndex = 0;
  bool _isEditing = false;
  final TextEditingController _textController = TextEditingController();

  final List<String> _fonts = [
    'Roboto',
    'Arial',
    'Courier New',
    'Georgia',
    'Times New Roman',
    'Verdana',
  ];

  void _editText() {
    setState(() {
      _isEditing = true;
      _textController.text = contents[_selectedIndex].text;
    });
  }

  void _updateText() {
    setState(() {
      contents[_selectedIndex].text = _textController.text;
      contents[_selectedIndex].fontSize = _textController.text.isNotEmpty
          ? contents[_selectedIndex].fontSize
          : contents[_selectedIndex].fontSize;
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
                  'Sample Text',
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
      body: PageView.builder(
        itemCount: contents.length,
        itemBuilder: (_, i) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      contents[i].text,
                      style: TextStyle(
                        fontSize: contents[i].fontSize,
                        color: contents[i].color,
                        fontFamily: contents[i].fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
