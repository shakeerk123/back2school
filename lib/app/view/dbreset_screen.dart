import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DbReset extends StatelessWidget {
  const DbReset({super.key});

  Future<void> _resetDatabase() async {
    DocumentReference sessionRef = FirebaseFirestore.instance.collection('sessions').doc('currentSession');
    await sessionRef.update({
      'parentCurrentQuestionIndex': 0,
      'childCurrentQuestionIndex': 0,
      'parentMatchedScore': 0,
      'kidMatchedScore': 0,
      'parentSelections': [],
      'kidSelections': [],
      'parentSubmittedAnswer': null,
      'childSubmittedAnswer': null,
      'parentCompleted': false,
      'kidCompleted': false,
      'isParentLoggedIn': false,
      'isKidLoggedIn': false,
      'parentReady': false,
      'kidReady': false,
      'playAgain': false,
      'kidCurrentRound': 1,
      'parentCurrentRound': 1,
      'kidSubmitted': false,
      'parentSubmitted': false,
      
      
    });
  }

  void _navigateToRoleSelection() {
    Get.offAllNamed('/role-selection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Database'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _resetDatabase();
            _navigateToRoleSelection();
          },
          child: const Text('Reset Database and Go to Role Selection'),
        ),
      ),
    );
  }
}
