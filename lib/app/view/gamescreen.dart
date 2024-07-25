// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:async';

// class GameScreen extends StatefulWidget {
//   final String role; // 'kid' or 'parent'

//   GameScreen({required this.role});

//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late DocumentReference _sessionRef;
//   late StreamSubscription<DocumentSnapshot> _subscription;
//   int _currentQuestionIndex = 0;
//   String _currentQuestion = '';
//   List<String> _options = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _initializeSession();
//   }

//   Future<void> _initializeSession() async {
//     _sessionRef = _firestore.collection('sessions').doc('currentSession');
//     _subscription = _sessionRef.snapshots().listen((snapshot) {
//       if (snapshot.exists) {
//         try {
//           final data = snapshot.data() as Map<String, dynamic>;
//           final questions = data['questions'] as List<dynamic>;
//           _currentQuestionIndex = data['currentQuestionIndex'];

//           if (_currentQuestionIndex < questions.length) {
//             final question = questions[_currentQuestionIndex];
//             setState(() {
//               _currentQuestion = widget.role == 'parent'
//                   ? question['parentQuestion']
//                   : question['kidQuestion'];
//               _options = List<String>.from(question['options']);
//               _loading = false;
//             });
//           } else {
//             print(
//                 'Error: currentQuestionIndex ($_currentQuestionIndex) is out of range for questions array (length: ${questions.length}).');
//           }
//         } catch (e) {
//           print('Error processing snapshot data: $e');
//         }
//       }
//     }, onError: (error) {
//       print('Error listening to document snapshots: $error');
//     });
//   }

//   Future<void> _submitAnswer(String answer) async {
//     try {
//       if (widget.role == 'parent') {
//         await _sessionRef.update({
//           'parentAnswers': FieldValue.arrayUnion([answer]),
//         });
//       } else {
//         await _sessionRef.update({
//           'childAnswers': FieldValue.arrayUnion([answer]),
//         });
//       }

//       final data = (await _sessionRef.get()).data() as Map<String, dynamic>;
//       final questions = data['questions'] as List<dynamic>;

//       if (_currentQuestionIndex + 1 < questions.length) {
//         await _sessionRef.update({
//           'currentQuestionIndex': _currentQuestionIndex + 1,
//         });
//       } else {
//         // Calculate score and show it
//         final parentAnswers = List<String>.from(data['parentAnswers']);
//         final childAnswers = List<String>.from(data['childAnswers']);

//         int score = 0;
//         for (int i = 0; i < parentAnswers.length; i++) {
//           if (parentAnswers[i] == childAnswers[i]) {
//             score++;
//           }
//         }

//         await _sessionRef.update({'score': score});

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => ScoreScreen(score: score)),
//         );
//       }
//     } catch (e) {
//       print('Error submitting answer: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Scaffold(
//         appBar: AppBar(
//             title: Text(
//                 '${widget.role.toUpperCase()} - Question ${_currentQuestionIndex + 1}')),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//           title: Text(
//               '${widget.role.toUpperCase()} - Question ${_currentQuestionIndex + 1}')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(_currentQuestion, style: TextStyle(fontSize: 24)),
//             SizedBox(height: 24),
//             ..._options.map((option) => ElevatedButton(
//                   onPressed: () => _submitAnswer(option),
//                   child: Text(option),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ScoreScreen extends StatelessWidget {
//   final int score;

//   ScoreScreen({required this.score});

//   Future<void> _resetSession(BuildContext context) async {
//     DocumentReference sessionRef =
//         FirebaseFirestore.instance.collection('sessions').doc('currentSession');
//     await sessionRef.update({
//       'parentId': '',
//       'childId': '',
//       'isParentLoggedIn': false,
//       'currentQuestionIndex': 0,
//       'parentAnswers': [],
//       'childAnswers': [],
//       'score': 0,
//     });

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Score')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Your score: $score', style: TextStyle(fontSize: 24)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _resetSession(context),
//               child: Text('Play Again'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class RoleSelectionScreen extends StatelessWidget {
//   Future<void> _loginAsParent(BuildContext context) async {
//     DocumentReference sessionRef =
//         FirebaseFirestore.instance.collection('sessions').doc('currentSession');
//     DocumentSnapshot sessionSnapshot = await sessionRef.get();

//     if (sessionSnapshot.exists && sessionSnapshot['isParentLoggedIn'] == true) {
//       // Parent is already logged in
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Parent is already logged in on another device.')));
//     } else {
//       // Set isParentLoggedIn to true and navigate to GameScreen
//       await sessionRef.update({'isParentLoggedIn': true});
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => GameScreen(role: 'parent')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Select Role')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => _loginAsParent(context),
//               child: Text('Login as Parent'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => GameScreen(role: 'kid')));
//               },
//               child: Text('Login as Kid'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
