import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'widget_services.dart';

class AuthServices {
  static final AuthServices _singleton = AuthServices._();
  AuthServices._();
  factory AuthServices() => _singleton;

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
        WidgetServices.showAlertDialog(context, '메세지 전송 실패', e.toString());
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
      log(e.toString());
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
