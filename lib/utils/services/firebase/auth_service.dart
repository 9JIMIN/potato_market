import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import '../../ui/widgets/show_dialog.dart';

class AuthService {
  static final AuthService _singleton = AuthService._();
  AuthService._();
  factory AuthService() => _singleton;

  final _instance = FirebaseAuth.instance;

  Future<void> sendCertSMS(
    BuildContext context,
    String phoneNumber,
    Function setCertText,
    Function setVerificationId,
  ) async {
    await _instance.verifyPhoneNumber(
      phoneNumber: '+82 $phoneNumber',
      verificationCompleted: setCertText,
      verificationFailed: (FirebaseAuthException e) {
        ShowDialog.alert(context, '메세지 전송 실패', e.toString());
      },
      codeSent: setVerificationId,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<String> signIn(
    BuildContext context,
    String verificationId,
    String smsCode,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      final uid = (await _instance.signInWithCredential(credential)).user.uid;
      return uid;
    } on FirebaseAuthException catch (e) {
      ShowDialog.alert(context, '로그인 실패', e.toString());
      log(e.toString());
      return null;
    } catch (e) {
      ShowDialog.alert(context, '로그인 실패', e.toString());
      log(e.toString());
      return null;
    }
  }
}
