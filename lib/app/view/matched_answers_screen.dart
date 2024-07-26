import 'package:flutter/material.dart';

class MatchedAnswersScreen extends StatelessWidget {
  final List<String> parentAnswers;
  final List<String> childAnswers;

  MatchedAnswersScreen(
      {required this.parentAnswers, required this.childAnswers});

  @override
  Widget build(BuildContext context) {
    List<Widget> answerRows = [];
    for (int i = 0; i < parentAnswers.length; i++) {
      answerRows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(parentAnswers[i], style: TextStyle(fontSize: 18)),
            Text(childAnswers[i], style: TextStyle(fontSize: 18)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Matched Answers'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Parent Answer',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('Child Answer',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Divider(),
              ...answerRows,
            ],
          ),
        ),
      ),
    );
  }
}
