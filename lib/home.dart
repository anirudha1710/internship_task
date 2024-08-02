import 'package:flutter/material.dart';

import 'onbording.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool _isEditing = false; // Track if the text is being edited
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

  List<DraggableText> _draggableTexts = []; // List to manage draggable text widgets

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

  void _addDraggableText() {
    setState(() {
      // Create a draggable text widget with initial position
      _draggableTexts.add(
        DraggableText(
          text: 'Draggable Text',
          position: Offset(100, 100), // Default position, can be changed
          onPositionChanged: (newPosition) {
            setState(() {
              // Update the position of the draggable text
              _draggableTexts.firstWhere((element) => element.text == 'Draggable Text').position = newPosition;
            });
          },
        ),
      );
    });
  }

  void _editTextDialog(DraggableText draggableText) {
    _textController.text = draggableText.text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Text'),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(hintText: 'Enter new text'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  draggableText.text = _textController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
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
          // Image widget or Onbording widget goes here
          Onbording(),
          ..._draggableTexts.map((draggableText) => Positioned(
            left: draggableText.position.dx,
            top: draggableText.position.dy,
            child: Draggable(
              feedback: Material(
                child: Text(
                  draggableText.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              childWhenDragging: Container(), // Empty container while dragging
              child: GestureDetector(
                onTap: () {
                  _editTextDialog(draggableText); // Show dialog to edit text
                },
                child: Text(
                  draggableText.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              onDragEnd: (details) {
                draggableText.onPositionChanged(details.offset);
              },
            ),
          )),
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
        onTap: (index) {
          _onItemTapped(index);
          if (index == 0) {
            _addDraggableText(); // Add draggable text when "Add Text" is clicked
          }
        },
      ),
    );
  }
}

class DraggableText {
  String text;
  Offset position;
  final void Function(Offset) onPositionChanged;

  DraggableText({
    required this.text,
    required this.position,
    required this.onPositionChanged,
  });
}

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}
