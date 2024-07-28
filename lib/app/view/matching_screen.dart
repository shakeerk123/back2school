import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/app/view/role_selection.dart';

import 'package:audioplayers/audioplayers.dart';

class MatchingScreen extends StatefulWidget {
  @override
  _MatchingScreenState createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _sessionRef;
  late StreamSubscription<DocumentSnapshot> _subscription;
  bool _waitingForOther = true;
  late AnimationController _controller;
  late Animation<double> _animation;
  AudioPlayer _audioPlayer = AudioPlayer();

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
            _controller.forward(); // Start the animation
            _playSound('success.wav');
          });
        }

        if (data['playAgain'] == true) {
          _resetPlayAgain();
        }
      }
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _resetPlayAgain() async {
    await _sessionRef.update({'playAgain': false});
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
      (route) => false,
    );
  }

  Future<void> _triggerPlayAgain() async {
    await _resetDatabase();
    await _sessionRef.update({'playAgain': true});
  }

  Future<void> _resetDatabase() async {
    await _sessionRef.update({
      'parentCurrentQuestionIndex': 0,
      'childCurrentQuestionIndex': 0,
      'parentMatchedScore': 0,
      'kidMatchedScore': 0,
      'parentAnswers': [],
      'childAnswers': [],
      'parentSubmittedAnswer': null,
      'childSubmittedAnswer': null,
      'parentCompleted': false,
      'kidCompleted': false,
      'isParentLoggedIn': false,
      'isKidLoggedIn': false,
      'parentReady': false,
      'showPopup': false,
      'kidReady': false,
      'playAgain': false, // Reset the playAgain field
    });
  }

  void _playSound(String soundFile) {
    _audioPlayer.play(AssetSource(soundFile));
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_waitingForOther) {
      return Scaffold(
        backgroundColor: Color(0xFFFFA629),
        appBar: AppBar(
            title: const Text('Waiting for the other player'),
            automaticallyImplyLeading: false),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFA629),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Game Over',
                    style:
                        TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _triggerPlayAgain,
                  child: const Text('Play Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
