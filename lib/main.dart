import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_app/app/controller/role_selection_controller.dart';
import 'package:quiz_app/app/controller/waiting_controller.dart';
import 'package:quiz_app/app/view/game_screen.dart';
import 'package:quiz_app/app/view/role_selection.dart';
import 'package:quiz_app/app/view/waiting_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      initialBinding: BindingsBuilder(() {
        Get.put(RoleSelectionController());
      }),
      getPages: [
        GetPage(name: '/', page: () => RoleSelectionScreen()),
        GetPage(
            name: '/waiting',
            page: () => WaitingScreen(),
            binding: BindingsBuilder(() {
              Get.put(WaitingController());
            })),
        GetPage(name: '/game', page: () => GameScreen(role: Get.arguments)),
      ],
      home: RoleSelectionScreen(),
    );
  }
}
