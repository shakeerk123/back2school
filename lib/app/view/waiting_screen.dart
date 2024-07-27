import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/controller/waiting_controller.dart';

class WaitingScreen extends StatelessWidget {
  final WaitingController controller = Get.put(WaitingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/waiting.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        backgroundColor: Colors.blueAccent,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text(
                        controller.isReady.value ? 'Ready!' : 'I\'m Ready',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
