import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/controller/game_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class GameScreen extends StatelessWidget {
  final String role;

  GameScreen({super.key, required this.role}) {
    Get.put(GameController());
    final GameController controller = Get.find();
    controller.setRole(role);
  }

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          role.toUpperCase(),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  Obx(() => Text(
                        '${controller.matchedScore.value} match',
                        style: const TextStyle(fontSize: 18),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  Obx(() => LinearPercentIndicator(
                        lineHeight: 5.0,
                        percent: 1.0 - controller.remainingTime.value / 20,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.green,
                        animation: true,
                        animateFromLastPercent: true,
                        alignment: MainAxisAlignment.center,
                      )),
                  const SizedBox(height: 24),
                  Obx(() => Text(controller.currentQuestion.value,
                      style: const TextStyle(fontSize: 24))),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Obx(() => GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: controller.options.length,
                          itemBuilder: (context, index) {
                            return Draggable<String>(
                              data: controller.options[index],
                              feedback: Material(
                                color: Colors.transparent,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        controller.options[index],
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Card(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.grey[200],
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      controller.options[index],
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: controller.usedOptions
                                            .contains(controller.options[index])
                                        ? Colors.grey
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: controller.usedOptions
                                        .contains(controller.options[index])
                                    ? Colors.grey[200]
                                    : Colors.white,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      controller.options[index],
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      return DragTarget<String>(
                        onAccept: (data) {
                          controller.selectOption(data, index);
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Obx(() {
                            return Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: controller.selectedOptions[index] != ''
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: controller.selectedOptions[index] != ''
                                  ? Colors.red[100]
                                  : Colors.white,
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    controller.selectedOptions[index],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      );
                    }),
                  ),
                  Obx(() {
                    if (controller.waitingForOtherPlayer.value) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Waiting for the other player...',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
