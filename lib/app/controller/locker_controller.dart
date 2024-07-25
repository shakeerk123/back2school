// lib/controllers/locker_controller.dart
import 'package:get/get.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quiz_app/app/model/locker.dart';

class LockerController extends GetxController {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.brown,
  ];

  final List<Gift> gifts = [
    Gift(name: 'Toy Car', icon: Icons.directions_car),
    Gift(name: 'Doll', icon: Icons.emoji_people),
    Gift(name: 'Bike', icon: Icons.bike_scooter),
    Gift(name: 'Book', icon: Icons.book),
    Gift(name: 'Puzzle', icon: Icons.extension),
  ];

  var lockers = <Locker>[].obs;

  LockerController() {
    initializeLockers();
  }

  void initializeLockers() {
    lockers.value = List.generate(
      24,
      (index) {
        bool hasGift = Random().nextDouble() < 0.5;
        return Locker(
          id: index,
          hasGift: hasGift,
          color: colors[Random().nextInt(colors.length)],
          gift: hasGift ? gifts[Random().nextInt(gifts.length)] : null,
        );
      },
    );
  }

  void openLocker(int id) {
    // Logic for opening a locker
    lockers[id] = Locker(
      id: id,
      hasGift: lockers[id].hasGift,
      color: lockers[id].color,
      gift: lockers[id].gift,
    );
  }

  void randomizeLockers() {
    initializeLockers();
  }
}
