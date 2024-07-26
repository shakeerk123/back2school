import 'package:flutter/material.dart';

class MatchedAnswersScreen extends StatelessWidget {
  final List<String> parentAnswers;
  final List<String> childAnswers;

  MatchedAnswersScreen({
    required this.parentAnswers,
    required this.childAnswers,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure we iterate only up to the length of the shorter list
    int minLength = parentAnswers.length < childAnswers.length
        ? parentAnswers.length
        : childAnswers.length;

    List<Widget> answerRows = [];
    for (int i = 0; i < minLength; i++) {
      answerRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                parentAnswers[i],
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                childAnswers[i],
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Matched Answers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Parent Answer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Child Answer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Divider(),
            Expanded(
              child: ListView(
                children: answerRows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
