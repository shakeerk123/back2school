// lib/models/locker.dart
import 'package:flutter/material.dart';

class Gift {
  final String name;
  final IconData icon;

  Gift({required this.name, required this.icon});
}

class Locker {
  final int id;
  final bool hasGift;
  final Color color;
  final Gift? gift;

  Locker(
      {required this.id,
      required this.hasGift,
      required this.color,
      this.gift});
}
