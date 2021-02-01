import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthModel with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  final _initalImage =
      'https://firebasestorage.googleapis.com/v0/b/potato-market-4e46b.appspot.com/o/default-images%2Fuser.png?alt=media&token=1372fdee-be45-4d13-b69c-c67bed788b4d';

  String _name;
  String _email;
  String _password;

  bool _isLogin = false;
  bool _isLoading = false;

  GlobalKey get formKey => _formKey;
  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;

  String onNameValidate(value) {
    if (value.isEmpty) {
      return '뭐라도 넣으렴.';
    }
    return null;
  }

  String onEmailValidate(value) {
    Pattern emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    if (!RegExp(emailPattern).hasMatch(value)) {
      return '이메일 확인 좀..';
    }
    return null;
  }

  String onPasswordValidate(value) {
    if (value.length < 6) {
      return '6개 이상의 문자를 넣어주길 바람.';
    }
    return null;
  }

  void onChange() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void onNameSaved(value) {
    _name = value;
  }

  void onEmailSaved(value) {
    _email = value;
  }

  void onPasswordSaved(value) {
    _password = value;
  }

  Future<void> onSubmit() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_isLogin) {
        await login();
      } else {
        await addUser();
      }
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addUser() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _email,
      password: _password,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'name': _name,
      'email': _email,
      'imageUrl': _initalImage,
      'createdDate': DateTime.now(),
    });
  }

  Future<void> login() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    );
    _isLoading = false;
  }
}
