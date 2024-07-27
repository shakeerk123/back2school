import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quiz_app/app/utils/widgets/custom_button.dart';

class RoleSelectionScreen extends StatefulWidget {
  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loginAsParent(BuildContext context) async {
    DocumentReference sessionRef =
        FirebaseFirestore.instance.collection('sessions').doc('currentSession');
    DocumentSnapshot sessionSnapshot = await sessionRef.get();

    if (sessionSnapshot.exists && sessionSnapshot['isParentLoggedIn'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Parent is already logged in on another device.')));
    } else {
      await sessionRef.update({'isParentLoggedIn': true});
      Get.toNamed('/waiting', arguments: 'parent');
    }
  }

  Future<void> _loginAsKid(BuildContext context) async {
    DocumentReference sessionRef =
        FirebaseFirestore.instance.collection('sessions').doc('currentSession');
    DocumentSnapshot sessionSnapshot = await sessionRef.get();

    if (sessionSnapshot.exists && sessionSnapshot['isKidLoggedIn'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Kid is already logged in on another device.')));
    } else {
      await sessionRef.update({'isKidLoggedIn': true});
      Get.toNamed('/waiting', arguments: 'kid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 150,
            left: 50,
            right: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  imagePath: 'assets/images/button.png',
                  text: 'Play as Kid',
                  onPressed: () => _loginAsKid(context),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  imagePath: 'assets/images/button.png',
                  text: 'Play as Parent',
                  onPressed: () => _loginAsParent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
