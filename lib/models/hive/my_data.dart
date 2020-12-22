import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../profile.dart';

class MyModel with ChangeNotifier {
  MyModel() {
    fetchData();
  }

  Profile me;
  String myId = '';

  Future<void> fetchData() async {
    myId = FirebaseAuth.instance.currentUser.uid;
    final query =
        await FirebaseFirestore.instance.collection('users').doc(myId).get();
    me = Profile.fromQuery(query);
  }
}
