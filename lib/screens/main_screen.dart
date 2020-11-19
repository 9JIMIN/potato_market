import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatelessWidget {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final myId = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('main screen'),
      ),
      body: Center(
        child: FutureBuilder(
          future:
              FirebaseFirestore.instance.collection('users').doc(myId).get(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return Text('hello ' + snapshot.data.data()['name']);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
      ),
    );
  }
}
