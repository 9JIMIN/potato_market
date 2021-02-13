import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:potato_market/screens/start/login/widgets/login_form.dart';
import 'package:potato_market/screens/start/login/widgets/login_guide.dart';
import 'package:provider/provider.dart';

import 'login_model.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    final isSended = context.select(
      (LoginModel model) => model.isSendButtonPressed,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('로그인/회원가입'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (!isSended) LoginGuide(),
            if (!isSended) SizedBox(height: 30),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
