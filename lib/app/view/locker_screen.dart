// // lib/views/locker_detail_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:quiz_app/app/controller/locker_controller.dart';
// import 'package:quiz_app/app/model/locker.dart';
// import 'home_screen.dart';

// class LockerDetailScreen extends StatelessWidget {
//   final Locker locker;

//   LockerDetailScreen({required this.locker});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Locker ${locker.id}'),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: Center(
//         child: locker.hasGift
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(locker.gift!.icon, size: 100, color: Colors.blue),
//                 const  SizedBox(height: 20),
//                   Text(
//                     'You won a ${locker.gift!.name}!',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontFamily: 'FredokaOne',
//                       color: Colors.green,
//                     ),
//                   ),
//                 const  SizedBox(height: 20),
                  
//                   Image.asset(
//                     'assets/images/congrats.png',
//                     width: 150,
//                     height: 150,
//                   ),
//                  const SizedBox(height: 40),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.find<LockerController>().randomizeLockers();
//                       Get.offAll(() => HomeScreen());
//                     },
//                     child: Text('Play Again'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orangeAccent,
//                       textStyle: TextStyle(
//                         fontFamily: 'FredokaOne',
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Better luck next time!',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontFamily: 'FredokaOne',
//                       color: Colors.red,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Image.asset(
//                     'assets/images/sad_face.png',
//                     width: 150,
//                     height: 150,
//                   ),
//                   SizedBox(height: 40),
//                   ElevatedButton(
//                     onPressed: () {
//                       Get.find<LockerController>().randomizeLockers();
//                       Get.offAll(() => HomeScreen());
//                     },
//                     child: Text('Play Again'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orangeAccent,
//                       textStyle: TextStyle(
//                         fontFamily: 'FredokaOne',
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//       backgroundColor: Colors.yellow[100],
//     );
//   }
// }
