import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSampleQuestions extends StatelessWidget {
  void _addSampleQuestions() async {
    final questions = [
      {
        'kidQuestion': 'What is your favorite animal?',
        'parentQuestion': 'What is your kid\'s favorite animal?',
        'options': ['Dog', 'Cat', 'Elephant', 'Lion'],
      },
      {
        'kidQuestion': 'What is your favorite hobby?',
        'parentQuestion': 'What is your kid\'s favorite hobby?',
        'options': ['Reading', 'Playing Sports', 'Drawing', 'Watching TV'],
      },
      {
        'kidQuestion': 'What is your favorite season?',
        'parentQuestion': 'What is your kid\'s favorite season?',
        'options': ['Summer', 'Winter', 'Spring', 'Fall'],
      },
      {
        'kidQuestion': 'What is your favorite subject in school?',
        'parentQuestion': 'What is your kid\'s favorite subject in school?',
        'options': ['Math', 'Science', 'History', 'Art'],
      }
      // Add more questions as needed
    ];

    DocumentReference sessionRef =
        FirebaseFirestore.instance.collection('sessions').doc('currentSession');

    await sessionRef.update({
      'questions': FieldValue.arrayUnion(questions
          .map((q) => {
                'kidQuestion': q['kidQuestion'],
                'parentQuestion': q['parentQuestion'],
                'options': q['options']
              })
          .toList()),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Sample Questions')),
      body: Center(
        child: ElevatedButton(
          onPressed: _addSampleQuestions,
          child: Text('Add Sample Questions'),
        ),
      ),
    );
  }
}
