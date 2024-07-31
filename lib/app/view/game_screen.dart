import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:get/get.dart';
import 'package:quiz_app/app/controller/game_controller.dart';
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'matching_screen.dart';
>>>>>>> parent of ca4b492 (added stratered grid and popup)
import 'package:percent_indicator/linear_percent_indicator.dart';

class GameScreen extends StatelessWidget {
  final String role;

<<<<<<< HEAD
  GameScreen({super.key, required this.role}) {
    Get.put(GameController());
    final GameController controller = Get.find();
    controller.setRole(role);
=======
  const GameScreen({super.key, required this.role});

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
  int _matchedScore = 0;
  bool _showPopup = false;
  bool _isMatch = false;
  bool _waitingForOtherPlayer = false;
  String _selectedOption = '';

  @override
  void initState() {
    super.initState();
    _initializeSession();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
            _matchedScore = data['parentMatchedScore'] ?? 0;
          } else {
            _currentQuestionIndex = data['childCurrentQuestionIndex'];
            _matchedScore = data['kidMatchedScore'] ?? 0;
          }

          if (_currentQuestionIndex < questions.length) {
            final question = questions[_currentQuestionIndex];
            setState(() {
              _currentQuestion = widget.role == 'parent'
                  ? question['parentQuestion']
                  : question['kidQuestion'];
              _options = List<String>.from(question['options']);
              _loading = false;
              _hasAnswered = false; // Reset for the new question
              _waitingForOtherPlayer = false; // Reset waiting status
              _selectedOption = ''; // Reset selected option
            });
          } else {
            print(
                'Error: currentQuestionIndex ($_currentQuestionIndex) is out of range for questions array (length: ${questions.length}).');
          }

          // Check if both have completed the game
          final parentCompleted = data['parentCompleted'] ?? false;
          final kidCompleted = data['kidCompleted'] ?? false;
          if (parentCompleted && kidCompleted) {
            _completeGame();
          }

          // Show match/not match popup
          if (data['showPopup'] == true) {
            final parentAnswer = data['parentSubmittedAnswer'];
            final childAnswer = data['childSubmittedAnswer'];
            setState(() {
              _isMatch = parentAnswer == childAnswer;
              _showPopup = true;
            });
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                _showPopup = false;
              });
            });
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
    setState(() {
      _hasAnswered = true;
      _selectedOption = answer; // Highlight the selected option
    });

    try {
      DocumentSnapshot snapshot = await _sessionRef.get();
      final data = snapshot.data() as Map<String, dynamic>;
      final questions = data['questions'] as List<dynamic>;

      if (widget.role == 'parent') {
        await _sessionRef.update({
          'parentAnswers': FieldValue.arrayUnion([answer]),
          'parentSubmittedAnswer': answer,
        });
      } else {
        await _sessionRef.update({
          'childAnswers': FieldValue.arrayUnion([answer]),
          'childSubmittedAnswer': answer,
        });
      }

      // Check if both have answered
      snapshot = await _sessionRef.get();
      final updatedData = snapshot.data() as Map<String, dynamic>;

      if (updatedData['parentSubmittedAnswer'] != null &&
          updatedData['childSubmittedAnswer'] != null) {
        // Both have answered, check if they match
        final parentAnswer = updatedData['parentSubmittedAnswer'];
        final childAnswer = updatedData['childSubmittedAnswer'];
        if (parentAnswer == childAnswer) {
          setState(() {
            _isMatch = true;
            _matchedScore++;
          });
          await _sessionRef.update({
            'parentMatchedScore': _matchedScore,
            'kidMatchedScore': _matchedScore,
          });
        } else {
          setState(() {
            _isMatch = false;
          });
        }

        // Show match/not match popup on both devices
        await _sessionRef.update({
          'showPopup': true,
        });
        await Future.delayed(const Duration(seconds: 1));
        await _sessionRef.update({
          'showPopup': false,
        });

        // Clear submitted answers and move to next question
        await _sessionRef.update({
          'parentSubmittedAnswer': null,
          'childSubmittedAnswer': null,
          'parentCurrentQuestionIndex': FieldValue.increment(1),
          'childCurrentQuestionIndex': FieldValue.increment(1),
        });

        if (_currentQuestionIndex + 1 >= questions.length) {
          await _sessionRef.update({
            'parentCompleted': true,
            'kidCompleted': true,
          });
          _completeGame();
        }
      } else {
        setState(() {
          _waitingForOtherPlayer = true;
        });
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

    // Get final scores
    DocumentSnapshot snapshot = await _sessionRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    final int parentScore = data['parentMatchedScore'];
    final int kidScore = data['kidMatchedScore'];

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
>>>>>>> parent of ca4b492 (added stratered grid and popup)
  }

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          role.toUpperCase(),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
<<<<<<< HEAD
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  Obx(() => Text(
                        '${controller.matchedScore.value} match',
                        style: const TextStyle(fontSize: 18),
                      )),
                ],
=======
              child: Text(
                '$_matchedScore Match ',
                style: const TextStyle(fontSize: 18),
>>>>>>> parent of ca4b492 (added stratered grid and popup)
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
<<<<<<< HEAD
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  Obx(() => LinearPercentIndicator(
                        lineHeight: 5.0,
                        percent: 1.0 - controller.remainingTime.value / 20,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.green,
                        animation: true,
                        animateFromLastPercent: true,
                        alignment: MainAxisAlignment.center,
                      )),
                  const SizedBox(height: 24),
                  Obx(() => Text(controller.currentQuestion.value,
                      style: const TextStyle(fontSize: 24))),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Obx(() => GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: controller.options.length,
                          itemBuilder: (context, index) {
                            return Draggable<String>(
                              data: controller.options[index],
                              feedback: Material(
                                color: Colors.transparent,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: Colors.white,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        controller.options[index],
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Card(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.grey[200],
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      controller.options[index],
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: controller.usedOptions
                                            .contains(controller.options[index])
                                        ? Colors.grey
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: controller.usedOptions
                                        .contains(controller.options[index])
                                    ? Colors.grey[200]
                                    : Colors.white,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      controller.options[index],
                                      style: const TextStyle(fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(3, (index) {
                      return DragTarget<String>(
                        onAccept: (data) {
                          controller.selectOption(data, index);
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Obx(() {
                            return Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: controller.selectedOptions[index] != ''
                                      ? Colors.red
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: controller.selectedOptions[index] != ''
                                  ? Colors.red[100]
                                  : Colors.white,
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    controller.selectedOptions[index],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      );
                    }),
                  ),
                  Obx(() {
                    if (controller.waitingForOtherPlayer.value) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Waiting for the other player...',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              );
            }),
=======
            child: Column(
              children: [
                const SizedBox(height: 24),
                LinearPercentIndicator(
                  lineHeight: 5.0,
                  percent: 1.0 - _remainingTime / 60,
                  backgroundColor: Colors.grey,
                  progressColor: Colors.blue,
                  animation: true,
                  animateFromLastPercent: true,
                  alignment: MainAxisAlignment.center,
                ),
                const SizedBox(height: 24),
                Text(_currentQuestion, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _options[index] == _selectedOption
                                ? Colors.red
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: _options[index] == _selectedOption
                            ? Colors.red[100]
                            : Colors.white,
                        child: ListTile(
                          title: Text(_options[index],
                              style: const TextStyle(fontSize: 18)),
                          onTap: () {
                            _submitAnswer(_options[index]);
                          },
                        ),
                      );
                    },
                  ),
                ),
                if (_waitingForOtherPlayer)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Waiting for the other player...',
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
              ],
            ),
>>>>>>> parent of ca4b492 (added stratered grid and popup)
          ),
        ],
      ),
    );
  }
}
