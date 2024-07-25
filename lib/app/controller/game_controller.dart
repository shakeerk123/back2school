// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quiz_app/app/view/score_screen.dart';

// class GameController extends GetxController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late DocumentReference sessionRef;
//   var currentQuestionIndex = 0.obs;
//   var currentQuestion = ''.obs;
//   var options = <String>[].obs;
//   var isLoading = true.obs;
//   var isTimerRunning = false.obs;
//   var totalTimerValue = 60.obs;
//   var role = ''.obs;
//   var score = 0.obs;
//   var isParentLoggedIn = false.obs;
//   var isKidLoggedIn = false.obs;
//   var isKidFinished = false.obs;
//   var isParentFinished = false.obs;

//   @override
//   void onInit() {
//     sessionRef = _firestore.collection('sessions').doc('currentSession');
//     super.onInit();
//   }

//   void startGame(String userRole) async {
//     role.value = userRole;
//     DocumentSnapshot snapshot = await sessionRef.get();

//     if (snapshot.exists) {
//       if (userRole == 'parent' && snapshot['isParentLoggedIn'] == true) {
//         isParentLoggedIn.value = true;
//         return;
//       } else if (userRole == 'kid' && snapshot['isKidLoggedIn'] == true) {
//         isKidLoggedIn.value = true;
//         return;
//       }

//       await sessionRef.update(
//           {userRole == 'parent' ? 'isParentLoggedIn' : 'isKidLoggedIn': true});
//     }

//     sessionRef.snapshots().listen((snapshot) {
//       if (snapshot.exists) {
//         final data = snapshot.data() as Map<String, dynamic>;
//         final questions = data['questions'] as List<dynamic>;
//         currentQuestionIndex.value = data['currentQuestionIndex'];
//         if (currentQuestionIndex.value < questions.length) {
//           final question = questions[currentQuestionIndex.value];
//           currentQuestion.value = role.value == 'parent'
//               ? question['parentQuestion']
//               : question['kidQuestion'];
//           options.value = List<String>.from(question['options']);
//           isLoading.value = false;
//           if (data['isParentReady'] && data['isKidReady']) {
//             startTimer();
//           }
//         } else {
//           print('Error: currentQuestionIndex is out of range');
//         }
//       }
//     });
//   }

//   void startTimer() {
//     if (isTimerRunning.value) return;
//     isTimerRunning.value = true;
//     totalTimerValue.value = 60;
//     Future.delayed(Duration(seconds: 1), updateTimer);
//   }

//   void updateTimer() {
//     if (totalTimerValue.value > 0) {
//       totalTimerValue.value--;
//       Future.delayed(Duration(seconds: 1), updateTimer);
//     } else {
//       calculateScore();
//     }
//   }

//   Future<void> submitAnswer(String answer) async {
//     try {
//       if (role.value == 'parent') {
//         await sessionRef.update({
//           'parentAnswers': FieldValue.arrayUnion([answer]),
//         });
//         isParentFinished.value = true;
//       } else {
//         await sessionRef.update({
//           'childAnswers': FieldValue.arrayUnion([answer]),
//         });
//         isKidFinished.value = true;
//       }

//       final data = (await sessionRef.get()).data() as Map<String, dynamic>;
//       final questions = data['questions'] as List<dynamic>;

//       if (currentQuestionIndex.value + 1 < questions.length) {
//         if (isKidFinished.value && isParentFinished.value) {
//           currentQuestionIndex.value++;
//           await sessionRef.update({
//             'currentQuestionIndex': currentQuestionIndex.value,
//             'isKidFinished': false,
//             'isParentFinished': false,
//           });
//           isKidFinished.value = false;
//           isParentFinished.value = false;
//         }
//       } else {
//         calculateScore();
//       }
//     } catch (e) {
//       print('Error submitting answer: $e');
//     }
//   }

//   void calculateScore() async {
//     final data = (await sessionRef.get()).data() as Map<String, dynamic>;
//     final parentAnswers = List<String>.from(data['parentAnswers']);
//     final childAnswers = List<String>.from(data['childAnswers']);

//     score.value = 0;
//     for (int i = 0; i < parentAnswers.length; i++) {
//       if (parentAnswers[i] == childAnswers[i]) {
//         score.value++;
//       }
//     }

//     await sessionRef.update({'score': score.value});

//     Get.off(() => ScoreScreen(score: score.value));
//   }

//   Future<void> resetSession() async {
//     await sessionRef.update({
//       'parentId': '',
//       'childId': '',
//       'isParentLoggedIn': false,
//       'isKidLoggedIn': false,
//       'isParentReady': false,
//       'isKidReady': false,
//       'isParentFinished': false,
//       'isKidFinished': false,
//       'currentQuestionIndex': 0,
//       'parentAnswers': [],
//       'childAnswers': [],
//       'score': 0,
//     });
//     totalTimerValue.value = 60; // Reset the timer to 1 minute
//     currentQuestionIndex.value = 0; // Reset the current question index
//   }
// }
