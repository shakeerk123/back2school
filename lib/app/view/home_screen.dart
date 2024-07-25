// // lib/views/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:quiz_app/app/controller/locker_controller.dart';
// import 'package:quiz_app/app/view/locker_screen.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final LockerController controller = Get.find();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mall Kids Game'),
//         backgroundColor: Colors.orangeAccent,
//       ),
//       body: Obx(() {
//         return GridView.builder(
//           gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
//           itemCount: controller.lockers.length,
//           itemBuilder: (context, index) {
//             final locker = controller.lockers[index];
//             return GestureDetector(
//               onTap: () {
//                 controller.openLocker(locker.id);
//                 Get.to(() => LockerDetailScreen(locker: locker));
//               },
//               child: Card(
//                 color: locker.color,
//                 child: Center(
//                   child: Text(
//                     'Locker ${locker.id}',
//                     style: TextStyle(
//                       fontFamily: 'FredokaOne',
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       backgroundColor: Colors.yellow[100],
//     );
//   }
// }
