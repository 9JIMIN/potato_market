import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer';
import 'package:provider/provider.dart';

import '../profile_editor/profile_editor_view.dart';
import '../../../providers/cloud_services.dart';
import '../../../providers/auth_services.dart';
import '../../../providers/storage_services.dart';
import '../../../providers/widget_services.dart';
import '../../../providers/local_model.dart';

import '../../../models/profile.dart';

class LoginModel with ChangeNotifier {
  FocusNode _phoneFieldFocus;
  FocusNode _certFieldFocus;

  final _formKey = GlobalKey<FormState>();

  var _phoneFieldController = TextEditingController();
  var _certFieldController = TextEditingController();

  var _isSendButtonActive = false;
  var _isStartButtonActive = false;
  var _isSendButtonPressed = false;
  var _isLoading = false;

  String _uid;
  String _verificationId;

  void onLoginInit() {
    _phoneFieldFocus = FocusNode();
    _certFieldFocus = FocusNode();
  }

  void onLoginDispose() {
    _phoneFieldFocus.dispose();
    _certFieldFocus.dispose();
  }

  void onPhoneFieldChanged(String phoneInput) {
    if (phoneInput.length >= 10) {
      _isSendButtonActive = true;
      notifyListeners();
    } else {
      if (_isSendButtonActive) {
        _isSendButtonActive = false;
        notifyListeners();
      }
    }
  }

  void onCertFieldChanged(String certInput) {
    if (certInput.length == 6) {
      _isStartButtonActive = true;
      notifyListeners();
    } else {
      if (_isStartButtonActive) {
        _isStartButtonActive = false;
        notifyListeners();
      }
    }
  }

  String certFieldValidator(String certInput) {
    return '잘못된 인증번호';
  }

  void _setCertText(PhoneAuthCredential credential) {
    _certFieldController.text = credential.smsCode;
    _isStartButtonActive = true;
    notifyListeners();
  }

  void _setVerificationId(String verificationId, int resendToken) {
    _verificationId = verificationId;
  }

  // 인증번호 보내기 버튼 클릭시
  void onSendButtonPressed(BuildContext context) async {
    _isSendButtonPressed = true;
    _phoneFieldFocus.unfocus();
    WidgetServices.showSnack(context, '인증번호를 전송하였습니다.');
    notifyListeners();

    await AuthServices().sendCertSMS(
      context,
      _phoneFieldController.text,
      _setCertText,
      _setVerificationId,
    );
  }

  // 시작버튼 클릭시
  void onStartButtonPressed(BuildContext context) async {
    _isLoading = true;
    _certFieldFocus.unfocus();
    notifyListeners();

    _uid = await AuthServices().signIn(
      context,
      _verificationId,
      _certFieldController.text,
    );
    if (_uid != null) {
      final myProfile = await CloudServices().getProfile(_uid);
      if (myProfile != null) {
        context.read<LocalModel>().updateProfile(myProfile);
        Navigator.of(context).pop(); // 마켓화면으로 이동
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileEditorView(),
          ),
        );
      }
    } else {
      _formKey.currentState.validate();
    }
  }

  ////////////////////////////
  ////////////////////////////
  /// getter, setter

  set setPhoneFieldFocus(FocusNode focusNode) => _phoneFieldFocus = focusNode;
  set setCertFieldFocus(FocusNode focusNode) => _certFieldFocus = focusNode;
  FocusNode get phoneFieldFocus => _phoneFieldFocus;
  FocusNode get certFieldFocus => _certFieldFocus;
  GlobalKey get formKey => _formKey;
  TextEditingController get phoneFieldController => _phoneFieldController;
  TextEditingController get certFieldController => _certFieldController;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isStartButtonActive => _isStartButtonActive;
  bool get isSendButtonPressed => _isSendButtonPressed;
  bool get isLoading => _isLoading;
  String get uid => _uid;
  String get phoneNumber => _phoneFieldController.text;
}
