import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/app/view/role_selection.dart';

class DbResetScreen extends StatelessWidget {
  Future<void> _resetDatabase(BuildContext context) async {
    DocumentReference sessionRef =
        FirebaseFirestore.instance.collection('sessions').doc('currentSession');

    await sessionRef.update({
      'parentCurrentQuestionIndex': 0,
      'childCurrentQuestionIndex': 0,
      'parentAnswers': [],
      'childAnswers': [],
      'parentSubmittedAnswer': '',
      'childSubmittedAnswer': '',
      'parentCompleted': false,
      'kidCompleted': false,
      'isParentLoggedIn': false,
      'isKidLoggedIn': false,
      'parentReady': false,
      'kidReady': false,
      'playAgain': false,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database has been reset')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Database'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _resetDatabase(context),
          child: Text('Reset Database'),
        ),
      ),
    );
  }
}
