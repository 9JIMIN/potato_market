import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Card(child: AuthForm()),
        ),
      ),
    );
  }
}

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _name = '';
  var _email = '';
  var _password = '';

  FocusNode _nameFocus;
  FocusNode _emailFocus;
  FocusNode _passwordFocus;

  bool _isLogin = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _register() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState.save();
    try {
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
        'createdDate': DateTime.now(),
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('error'),
          content: Text('${e.message}'),
        ),
      );
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formKey.currentState.save();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('error'),
          content: Text('${e.message}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isLogin)
            TextFormField(
              key: ValueKey(1),
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: '닉네임'),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              validator: (value) {
                if (value.isEmpty) {
                  return '뭐라도 넣으렴.';
                }
                return null;
              },
              onSaved: (value) {
                _name = value;
              },
            ),
          TextFormField(
            key: ValueKey(2),
            focusNode: _emailFocus,
            decoration: InputDecoration(labelText: '이메일'),
            textInputAction: TextInputAction.next,
            onEditingComplete: () => node.nextFocus(),
            validator: (value) {
              Pattern emailPattern =
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
              if (!RegExp(emailPattern).hasMatch(value)) {
                return '이메일 확인 좀..';
              }
              return null;
            },
            onSaved: (value) {
              _email = value;
            },
          ),
          TextFormField(
            key: ValueKey(3),
            focusNode: _passwordFocus,
            decoration: InputDecoration(labelText: '비번'),
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              node.unfocus();
              if (_isLogin) {
                _login();
              } else {
                _register();
              }
            },
            validator: (value) {
              if (value.length < 6) {
                return '6개 이상의 문자를 넣어주길 바람.';
              }
              return null;
            },
            onSaved: (value) {
              _password = value;
            },
          ),
          if (_isLoading) CircularProgressIndicator(),
          if (!_isLoading)
            RaisedButton(
              child: Text(_isLogin ? '로그인' : '가입'),
              onPressed: _isLogin ? _login : _register,
            ),
          if (!_isLoading)
            RaisedButton(
              child: Text(_isLogin ? '새로 만들기' : '이미 계정이 있음'),
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
            )
        ],
      ),
    );
  }
}
