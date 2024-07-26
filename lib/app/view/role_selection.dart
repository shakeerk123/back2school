import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'waiting_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  Future<void> _loginAsParent(BuildContext context) async {
    DocumentReference sessionRef = FirebaseFirestore.instance.collection('sessions').doc('currentSession');
    DocumentSnapshot sessionSnapshot = await sessionRef.get();

    if (sessionSnapshot.exists && sessionSnapshot['isParentLoggedIn'] == true) {
      // Parent is already logged in
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Parent is already logged in on another device.')));
    } else {
      // Set isParentLoggedIn to true and navigate to WaitingScreen
      await sessionRef.update({'isParentLoggedIn': true});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WaitingScreen(role: 'parent')),
      );
    }
  }

  Future<void> _loginAsKid(BuildContext context) async {
    DocumentReference sessionRef = FirebaseFirestore.instance.collection('sessions').doc('currentSession');
    DocumentSnapshot sessionSnapshot = await sessionRef.get();

    if (sessionSnapshot.exists && sessionSnapshot['isKidLoggedIn'] == true) {
      // Kid is already logged in
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kid is already logged in on another device.')));
    } else {
      // Set isKidLoggedIn to true and navigate to WaitingScreen
      await sessionRef.update({'isKidLoggedIn': true});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WaitingScreen(role: 'kid')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _loginAsParent(context),
              child: Text('Login as Parent'),
            ),
            ElevatedButton(
              onPressed: () => _loginAsKid(context),
              child: Text('Login as Kid'),
            ),
          ],
        ),
      ),
    );
  }
}
