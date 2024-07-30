import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/view/matching_screen.dart';
import 'dart:async';


class GameController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference _sessionRef;
  late StreamSubscription<DocumentSnapshot> _subscription;

  var currentQuestionIndex = 0.obs;
  var currentQuestion = ''.obs;
  var options = <String>[].obs;
  var loading = true.obs;
  var remainingTime = 20.obs; // Set to 20 seconds per question
  var hasAnswered = false.obs;
  var matchedScore = 0.obs;
  var isMatch = false.obs;
  var waitingForOtherPlayer = false.obs;
  var selectedOption = ''.obs;
  var parentCompleted = false.obs;
  var kidCompleted = false.obs;
  var selectedOptions = <String>['', '', ''].obs;
  var usedOptions = <String>[].obs; // Track used options
  String role = '';

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _initializeSession();
  }

  void setRole(String role) {
    this.role = role;
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    remainingTime.value = 20; // Reset timer for each question

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        _timer?.cancel();
        _moveToNextQuestion();
      }
    });
  }

  Future<void> _initializeSession() async {
    _sessionRef = _firestore.collection('sessions').doc('currentSession');
    _subscription = _sessionRef.snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        try {
          final data = snapshot.data() as Map<String, dynamic>;
          final questions = data['questions'] as List<dynamic>;

          // Handle current question index based on role
          if (role == 'parent') {
            currentQuestionIndex.value = data['parentCurrentQuestionIndex'];
            matchedScore.value = data['parentMatchedScore'] ?? 0;
          } else {
            currentQuestionIndex.value = data['childCurrentQuestionIndex'];
            matchedScore.value = data['kidMatchedScore'] ?? 0;
          }

          if (currentQuestionIndex.value < questions.length) {
            final question = questions[currentQuestionIndex.value];
            currentQuestion.value = role == 'parent'
                ? question['parentQuestion']
                : question['kidQuestion'];
            options.value = List<String>.from(question['options'])
                .sublist(0, currentQuestionIndex.value + 4);
            loading.value = false;
            hasAnswered.value = false;
            waitingForOtherPlayer.value = false;
            selectedOption.value = '';
            selectedOptions.value = ['', '', '']; // Reset selected options
            usedOptions.clear(); // Clear used options
            _startTimer(); // Start the timer for the new question
          } else {
            print(
                'Error: currentQuestionIndex (${currentQuestionIndex.value}) is out of range for questions array (length: ${questions.length}).');
          }

          // Check if both have completed the game
          parentCompleted.value = data['parentCompleted'] ?? false;
          kidCompleted.value = data['kidCompleted'] ?? false;
          if (parentCompleted.value && kidCompleted.value) {
            completeGame();
          }
        } catch (e) {
          print('Error processing snapshot data: $e');
        }
      }
    }, onError: (error) {
      print('Error listening to document snapshots: $error');
    });
  }

  void selectOption(String option, int index) {
    if (usedOptions.contains(option)) {
      return; // Option already used, do nothing
    }
    selectedOptions[index] = option;
    usedOptions.add(option); // Mark option as used
    if (selectedOptions.every((element) => element.isNotEmpty)) {
      _submitAnswer();
    }
  }

  Future<void> _submitAnswer() async {
    if (hasAnswered.value) return;
    hasAnswered.value = true;
    _timer?.cancel(); // Cancel the timer when the answer is submitted

    try {
      final sortedAnswers = selectedOptions.toList()..sort();
      final answers = sortedAnswers.join(',');

      if (role == 'parent') {
        await _sessionRef.update({
          'parentAnswers': FieldValue.arrayUnion([answers]),
          'parentSubmittedAnswer': answers,
        });
      } else {
        await _sessionRef.update({
          'childAnswers': FieldValue.arrayUnion([answers]),
          'childSubmittedAnswer': answers,
        });
      }

      // Check if both have answered
      DocumentSnapshot snapshot = await _sessionRef.get();
      final updatedData = snapshot.data() as Map<String, dynamic>;

      final questions = updatedData['questions'] as List<dynamic>;

      if (updatedData['parentSubmittedAnswer'] != null &&
          updatedData['childSubmittedAnswer'] != null) {
        final parentAnswer = updatedData['parentSubmittedAnswer'].split(',').toList()..sort();
        final childAnswer = updatedData['childSubmittedAnswer'].split(',').toList()..sort();
        if (parentAnswer.join(',') == childAnswer.join(',')) {
          isMatch.value = true;
          matchedScore.value++;
          await _sessionRef.update({
            'parentMatchedScore': matchedScore.value,
            'kidMatchedScore': matchedScore.value,
          });
        } else {
          isMatch.value = false;
        }

        await _sessionRef.update({
          'parentSubmittedAnswer': null,
          'childSubmittedAnswer': null,
        });

        _moveToNextQuestion();
      } else {
        waitingForOtherPlayer.value = true;
      }
    } catch (e) {
      print('Error submitting answer: $e');
    }
  }

  void _moveToNextQuestion() async {
    final data = (await _sessionRef.get()).data() as Map<String, dynamic>;
    final questions = data['questions'] as List<dynamic>;

    if (currentQuestionIndex.value + 1 < questions.length) {
      await _sessionRef.update({
        'parentCurrentQuestionIndex': FieldValue.increment(1),
        'childCurrentQuestionIndex': FieldValue.increment(1),
      });
      _initializeSession(); // Reinitialize session to move to the next question
    } else {
       completeGame();
    }
  }

  void completeGame() async {
    if (role == 'parent') {
      await _sessionRef.update({
        'parentCompleted': true,
      });
    } else {
      await _sessionRef.update({
        'kidCompleted': true,
      });
    }

    Get.off(MatchingScreen());
  }

  @override
  void onClose() {
    _subscription.cancel();
    _timer?.cancel();
    super.onClose();
  }
}
