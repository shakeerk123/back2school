import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
      body: Container(
        color: const Color(0xFFFFA629), // Set background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome\nBack 2 School',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              padding: const EdgeInsets.all(20),
              children: [
                _buildAnimatedButton(
                  text: 'Parent',
                  onPressed: () => _loginAsParent(context),
                ),
                _buildAnimatedButton(
                  text: 'Kid',
                  onPressed: () => _loginAsKid(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(
      {required String text, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.orange.withOpacity(0.2),
          highlightColor: Colors.orange.withOpacity(0.1),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
