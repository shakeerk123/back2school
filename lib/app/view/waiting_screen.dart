import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/controller/waiting_controller.dart';

class WaitingScreen extends StatelessWidget {
  final WaitingController controller = Get.put(WaitingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFA629),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xf2fcff), Color(0xf2fcff)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'How to Play:',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1. Each player answers the questions.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    '2. Try to match the answers with your partner.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    '3. The game ends when both players have answered.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    '4. The score is calculated based on matching answers.',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Text(
                  'Waiting for the other player to be ready...',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed:
                          controller.isReady.value ? null : controller.setReady,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        controller.isReady.value ? 'Ready!' : 'I\'m Ready',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 18),
                      ),
                    )),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
