import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/app/view/role_selection.dart';

class MatchingScreen extends StatefulWidget {
  final String role; // 'kid' or 'parent'

  MatchingScreen({required this.role});

  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _sessionRef;
  late StreamSubscription<DocumentSnapshot> _subscription;
  bool _waitingForOther = true;

  @override
  void initState() {
    super.initState();
    _sessionRef = _firestore.collection('sessions').doc('currentSession');
    _subscription = _sessionRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final parentCompleted = data['parentCompleted'] ?? false;
        final kidCompleted = data['kidCompleted'] ?? false;

        if (parentCompleted && kidCompleted) {
          setState(() {
            _waitingForOther = false;
          });
        }
      }
    });
  }

  Future<Map<String, int>> _calculateMatches() async {
    final sessionSnapshot = await _sessionRef.get();
    final data = sessionSnapshot.data() as Map<String, dynamic>;

    final parentAnswers = List<String>.from(data['parentAnswers']);
    final childAnswers = List<String>.from(data['childAnswers']);

    int matches = 0;
    for (int i = 0; i < parentAnswers.length; i++) {
      if (parentAnswers[i] == childAnswers[i]) {
        matches++;
      }
    }

    return {'matches': matches, 'total': parentAnswers.length};
  }

  Future<void> _resetGame(BuildContext context) async {
    await _sessionRef.update({
      'parentCurrentQuestionIndex': 0,
      'childCurrentQuestionIndex': 0,
      'parentAnswers': [],
      'childAnswers': [],
      'parentSubmittedAnswer': '',
      'childSubmittedAnswer': '',
      'parentCompleted': false,
      'kidCompleted': false,
      'score': 0,
      'isParentLoggedIn': false,
      'parentReady': false,
      'kidReady': false,
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_waitingForOther) {
      return Scaffold(
        appBar: AppBar(title: Text('Waiting for the other player')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Matches')),
      body: FutureBuilder<Map<String, int>>(
        future: _calculateMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error calculating matches'));
          }

          final matches = snapshot.data!['matches'];
          final total = snapshot.data!['total'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Matches: $matches / $total',
                    style: TextStyle(fontSize: 24)),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _resetGame(context),
                  child: Text('Play Again'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
