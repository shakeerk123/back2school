import 'package:flutter/material.dart';

class Question {
  final String kidQuestion;
  final String parentQuestion;
  final List<String> kidOptions;
  final List<String> parentOptions;
  final List<IconData> kidIcons;
  final List<IconData> parentIcons;

  Question({
    required this.kidQuestion,
    required this.parentQuestion,
    required this.kidOptions,
    required this.parentOptions,
    required this.kidIcons,
    required this.parentIcons,
  });
}

List<Question> questions = [
  Question(
    kidQuestion: 'What\'s your favorite fruit?',
    parentQuestion: 'What\'s your son\'s favorite fruit?',
    kidOptions: ['Apple', 'Banana', 'Grapes', 'Orange', 'Pineapple', 'Strawberry'],
    parentOptions: ['Apple', 'Banana', 'Grapes', 'Orange', 'Pineapple', 'Strawberry'],
    kidIcons: [Icons.apple, Icons.car_crash, Icons.grain, Icons.home, Icons.local_pizza, Icons.local_florist],
    parentIcons: [Icons.apple, Icons.car_crash, Icons.grain, Icons.home, Icons.local_pizza, Icons.local_florist],
  ),
  Question(
    kidQuestion: 'What\'s your favorite snack?',
    parentQuestion: 'What\'s your son\'s favorite snack?',
    kidOptions: ['Chips', 'Cookies', 'Candy', 'Popcorn', 'Pretzels', 'Nuts'],
    parentOptions: ['Chips', 'Cookies', 'Candy', 'Popcorn', 'Pretzels', 'Nuts'],
    kidIcons: [Icons.fastfood, Icons.cookie, Icons.holiday_village, Icons.local_movies, Icons.bakery_dining, Icons.emoji_food_beverage],
    parentIcons: [Icons.fastfood, Icons.cookie, Icons.holiday_village, Icons.local_movies, Icons.bakery_dining, Icons.emoji_food_beverage],
  ),
  // Add more questions here...
];
