import 'package:flutter/material.dart';
import 'package:internship_task/onbording.dart'; // Import the color picker package

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
      body: Onbording(),
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
