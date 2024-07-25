import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/app/view/game_screen_two.dart';

class WaitingScreen extends StatefulWidget {
  final String role; // 'kid' or 'parent'

  WaitingScreen({required this.role});

  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _sessionRef;
  bool _isReady = false;
  late StreamSubscription<DocumentSnapshot> _subscription;

  @override
  void initState() {
    super.initState();
    _sessionRef = _firestore.collection('sessions').doc('currentSession');
    _subscription = _sessionRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final parentReady = data['parentReady'] ?? false;
        final kidReady = data['kidReady'] ?? false;

        if (parentReady && kidReady) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GameScreen(role: widget.role)),
          );
        }
      }
    });
  }

  Future<void> _setReady() async {
    if (widget.role == 'parent') {
      await _sessionRef.update({'parentReady': true});
    } else {
      await _sessionRef.update({'kidReady': true});
    }
    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waiting for the other player')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Waiting for the other player to be ready...'),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isReady ? null : _setReady,
              child: Text(_isReady ? 'Ready!' : 'I\'m Ready'),
            ),
          ],
        ),
      ),
    );
  }
}
