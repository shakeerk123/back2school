import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'matching_screen.dart';

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
  late Timer _timer;
  int _remainingTime = 60;
  bool _hasAnswered = false;
  String? _draggedAnswer;

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel();
          _completeGame();
        }
      });
    });
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
              _currentQuestion = widget.role == 'parent' ? question['parentQuestion'] : question['kidQuestion'];
              _options = List<String>.from(question['options']);
              _loading = false;
              _hasAnswered = false; // Reset for the new question
            });
          } else {
            print('Error: currentQuestionIndex ($_currentQuestionIndex) is out of range for questions array (length: ${questions.length}).');
          }

          // Check if both have completed the game
          final parentCompleted = data['parentCompleted'] ?? false;
          final kidCompleted = data['kidCompleted'] ?? false;
          if (parentCompleted && kidCompleted) {
            _completeGame();
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
    if (_hasAnswered) return; // Prevent multiple answers for the same question
    _hasAnswered = true;

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
          _completeGame();
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
          _completeGame();
        }
      }
    } catch (e) {
      print('Error submitting answer: $e');
    }
  }

  void _completeGame() async {
    if (widget.role == 'parent') {
      await _sessionRef.update({
        'parentCompleted': true,
      });
    } else {
      await _sessionRef.update({
        'kidCompleted': true,
      });
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MatchingScreen()),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.role.toUpperCase()} - Question ${_currentQuestionIndex + 1}'),
          automaticallyImplyLeading: false, // Remove the back button
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.role.toUpperCase()} - Question ${_currentQuestionIndex + 1}'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Time: $_remainingTime',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_currentQuestion, style: TextStyle(fontSize: 24)),
            SizedBox(height: 24),
            Expanded(
              child: Column(
                children: _options.map((option) {
                  return Draggable<String>(
                    data: option,
                    child: AnswerCard(answer: option),
                    feedback: Material(
                      child: AnswerCard(answer: option),
                      elevation: 5.0,
                    ),
                    childWhenDragging: AnswerCard(answer: option, isDragging: true),
                  );
                }).toList(),
              ),
            ),
            DragTarget<String>(
              onAccept: (receivedAnswer) {
                setState(() {
                  _draggedAnswer = receivedAnswer;
                });
                _submitAnswer(receivedAnswer);
              },
              builder: (context, acceptedData, rejectedData) {
                return Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.blue[100],
                  child: Center(
                    child: _draggedAnswer == null
                        ? Text('Drag answer here', style: TextStyle(fontSize: 18))
                        : Text('Selected: $_draggedAnswer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerCard extends StatelessWidget {
  final String answer;
  final bool isDragging;

  AnswerCard({required this.answer, this.isDragging = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isDragging ? Colors.grey : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(answer, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
