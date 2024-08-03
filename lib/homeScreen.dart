import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isEditing = false;
  String _enteredText = 'Click to edit';
  double _textSize = 24.0;
  double _initTextSize = 24.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _enteredText = _controller.text;
      });
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _controller.text = _enteredText;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    });
  }

  void _updateTextSize(Offset position) {
    setState(() {
      double delta = position.dy;
      _textSize = (_initTextSize + delta).clamp(10.0, 100.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('asset/bg.png'), // Update with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isEditing
                  ? TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edit text',
                ),
                autofocus: true,
                onEditingComplete: _toggleEdit,
              )
                  : Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: _textSize,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: GestureDetector(
                          onTap: _toggleEdit,
                          child: Text(
                            _enteredText,
                            style: TextStyle(fontSize: _textSize),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          _updateTextSize(details.localPosition);
                        },
                        child: Container(
                          color: Colors.blue,
                          width: 10,
                          height: 10,
                          child: Center(
                            child: Icon(
                              Icons.drag_handle,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
