import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  CustomButton({
    required this.imagePath,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(40.0), // Adjust the radius as needed
            child: Image.asset(
              imagePath,
              width: 250,
              height: 100,
              fit: BoxFit
                  .cover, // Ensure the image covers the widget's dimensions
            ),
          ),
          Text(
            text,
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
