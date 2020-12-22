import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MyAccountModel with ChangeNotifier {
  String name;
  String imageUrl;

  void dropDownMenu(int i) {
    if (i == 1) {
      FirebaseAuth.instance.signOut();
    }
    notifyListeners();
  }
}
