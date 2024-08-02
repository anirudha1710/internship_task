import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the color picker package

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool _isEditing = false; // Track if the text is being edited
  String _displayText = 'Hello, Flutter!'; // Text to display on the image
  String _selectedFont = 'Roboto'; // Default font
  Color _selectedColor = Colors.black; // Default text color
  double _fontSize = 24.0; // Default font size
  final TextEditingController _textController = TextEditingController();

  // List of available fonts
  final List<String> _fonts = [
    'Roboto',
    'Arial',
    'Courier New',
    'Georgia',
    'Times New Roman',
    'Verdana',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goBack() {
    // Implement your back button functionality here
    print('Back button pressed');
  }

  void _goForward() {
    // Implement your forward button functionality here
    print('Forward button pressed');
  }

  void _editText() {
    setState(() {
      _isEditing = true;
      _textController.text = _displayText; // Set the current text for editing
    });
  }

  void _updateText() {
    setState(() {
      _displayText = _textController.text; // Update the display text
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
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _editText();
                },
              ),
              ListTile(
                leading: const Icon(Icons.font_download),
                title: const Text('Font'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _showFontPicker();
                },
              ),
              ListTile(
                leading: const Icon(Icons.format_size),
                title: const Text('Font Size'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  _showFontSizePicker();
                },
              ),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Color'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
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
                    _selectedFont = font;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showFontSizePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Font Size: ${_fontSize.toStringAsFixed(1)}',
                style: TextStyle(fontSize: 18),
              ),
              Slider(
                value: _fontSize,
                min: 10.0,
                max: 100.0,
                divisions: 90,
                onChanged: (size) {
                  setState(() {
                    _fontSize = size;
                  });
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
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
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true, // Center the title
        leadingWidth: 96, // Allocate enough width for the icons
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _goForward,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: _isEditing
                ? Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8, // Limit width of TextField
              ),
              child: TextField(
                controller: _textController,
                autofocus: true,
                onSubmitted: (_) => _updateText(), // Update text on submission
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                ),
                style: TextStyle(
                  fontSize: _fontSize, // Apply selected font size
                  color: _selectedColor, // Apply selected color
                  fontFamily: _selectedFont, // Apply selected font
                ),
              ),
            )
                : GestureDetector(
              onTap: _showOptionsBottomSheet, // Show bottom sheet on tap
              child: Text(
                _displayText,
                style: TextStyle(
                  fontSize: _fontSize, // Apply selected font size
                  color: _selectedColor, // Apply selected color
                  backgroundColor: Colors.transparent,
                  fontFamily: _selectedFont, // Apply selected font
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(_isEditing ? Icons.edit : Icons.text_fields_sharp),
            label: _isEditing ? 'Edit Text' : 'Add Text',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Add Image',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize_outlined),
            label: 'Customize Pages',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}
