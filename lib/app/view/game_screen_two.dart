import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/app/view/score_screen.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  final String role; // 'kid' or 'parent'

  GameScreen({required this.role});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _sessionRef;
  late StreamSubscription<DocumentSnapshot> _subscription;
  int _currentQuestionIndex = 0;
  String _currentQuestion = '';
  List<String> _options = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    _sessionRef = _firestore.collection('sessions').doc('currentSession');
    _subscription = _sessionRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        try {
          final data = snapshot.data() as Map<String, dynamic>;
          final questions = data['questions'] as List<dynamic>;

          // Handle current question index based on role
          if (widget.role == 'parent') {
            _currentQuestionIndex = data['parentCurrentQuestionIndex'];
          } else {
            _currentQuestionIndex = data['childCurrentQuestionIndex'];
          }

          if (_currentQuestionIndex < questions.length) {
            final question = questions[_currentQuestionIndex];
            setState(() {
              _currentQuestion = widget.role == 'parent'
                  ? question['parentQuestion']
                  : question['kidQuestion'];
              _options = List<String>.from(question['options']);
              _loading = false;
            });
          } else {
            print(
                'Error: currentQuestionIndex ($_currentQuestionIndex) is out of range for questions array (length: ${questions.length}).');
          }
        } catch (e) {
          print('Error processing snapshot data: $e');
        }
      }
    }, onError: (error) {
      print('Error listening to document snapshots: $error');
    });
  }

  Future<void> _submitAnswer(String answer) async {
    try {
      DocumentSnapshot snapshot = await _sessionRef.get();
      final data = snapshot.data() as Map<String, dynamic>;
      final questions = data['questions'] as List<dynamic>;

      if (widget.role == 'parent') {
        await _sessionRef.update({
          'parentAnswers': FieldValue.arrayUnion([answer]),
          'parentSubmittedAnswer': answer,
        });

        if (_currentQuestionIndex + 1 < questions.length) {
          await _sessionRef.update({
            'parentCurrentQuestionIndex': FieldValue.increment(1),
          });
        } else {
          await _sessionRef.update({
            'parentCompleted': true,
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MatchingScreen(role: widget.role)),
          );
        }
      } else {
        await _sessionRef.update({
          'childAnswers': FieldValue.arrayUnion([answer]),
          'childSubmittedAnswer': answer,
        });

        if (_currentQuestionIndex + 1 < questions.length) {
          await _sessionRef.update({
            'childCurrentQuestionIndex': FieldValue.increment(1),
          });
        } else {
          await _sessionRef.update({
            'kidCompleted': true,
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MatchingScreen(role: widget.role)),
          );
        }
      }
    } catch (e) {
      print('Error submitting answer: $e');
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
            title: Text(
                '${widget.role.toUpperCase()} - Question ${_currentQuestionIndex + 1}')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${widget.role.toUpperCase()} - Question ${_currentQuestionIndex + 1}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_currentQuestion, style: TextStyle(fontSize: 24)),
            SizedBox(height: 24),
            ..._options.map((option) => ElevatedButton(
                  onPressed: () => _submitAnswer(option),
                  child: Text(option),
                )),
          ],
        ),
      ),
    );
  }
}
