import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'waiting_screen.dart';

class RoundScreen extends StatelessWidget {
  final String roundName;
  final bool isInitialRound;

  const RoundScreen({
    Key? key,
    required this.roundName,
    this.isInitialRound = false, required bool isMatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (isInitialRound) {
        Get.off(() => WaitingScreen());
      } else {
        Get.off(() => WaitingScreen()); // Change to the next screen as needed
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFA629),
      body: Center(
        child: Text(
          roundName,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
