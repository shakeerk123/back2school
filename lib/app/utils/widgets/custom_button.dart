import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class CustomButton extends StatefulWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  CustomButton({
    required this.imagePath,
    required this.text,
    required this.onPressed,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPressed = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) async {
    setState(() {
      _isPressed = true;
    });
    await _audioPlayer.setAsset('assets/button_click.mp3');
    _audioPlayer.play();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: _isPressed ? 0.9 : 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                widget.imagePath,
                width: 250,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
