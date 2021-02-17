import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/cloud_services.dart';
import '../../../services/auth_services.dart';
import '../../../services/widget_services.dart';
import '../../../providers/local_model.dart';
import '../../../services/navigation_services.dart';

class LoginModel with ChangeNotifier {
  FocusNode _phoneFieldFocus;
  FocusNode _certFieldFocus;

  final _key = GlobalKey<FormState>();

  var _phoneFieldController = TextEditingController();
  var _certFieldController = TextEditingController();

  var _isSendButtonActive = false;
  var _isStartButtonActive = false;
  var _isSendButtonPressed = false;
  var _isLoading = false;

  String _verificationId;

  void onLoginInit() {
    _phoneFieldFocus = FocusNode();
    _certFieldFocus = FocusNode();
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
    return '인증번호가 일치하지 않습니다.';
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
  void onSendButtonPressed() async {
    if (_phoneFieldController.text.startsWith('01')) {
      WidgetServices.showSnack(key.currentContext, '인증번호를 전송하였습니다.(최대 30초 소요)');
      _phoneFieldFocus.unfocus();

      if (!_isSendButtonPressed) {
        _isSendButtonPressed = true;
        notifyListeners();
      }

      await AuthServices().sendCertSMS(
        _key.currentContext,
        _phoneFieldController.text,
        _setCertText,
        _setVerificationId,
      );
    } else {
      WidgetServices.showSnack(_key.currentContext, '전화번호 형태가 잘못되었습니다.');
    }
  }

  // 시작버튼 클릭시
  void onStartButtonPressed() async {
    _isLoading = true;
    _certFieldFocus.unfocus();
    notifyListeners();

    final signInResult = await AuthServices().signIn(
      _key.currentContext,
      _verificationId,
      _certFieldController.text,
    );

    if (signInResult == null) {
      _key.currentState.validate();
      await Future.delayed(Duration(seconds: 3));
      _key.currentState.reset();
    } else {
      final uid = signInResult;
      final myProfile = await CloudServices().getProfile(uid);
      if (myProfile == null) {
        _key.currentContext.read<LocalModel>().updateUidAndPhoneNumber(
              uid,
              _phoneFieldController.text,
            );
        NavigationServices.toProfileEditor(_key.currentContext);
      } else {
        _key.currentContext.read<LocalModel>().updateProfile(myProfile);
        NavigationServices.toBase(_key.currentContext);
      }
    }
  }

  ////////////////////////////
  ////////////////////////////
  /// getter, setter

  set setPhoneFieldFocus(FocusNode focusNode) => _phoneFieldFocus = focusNode;
  set setCertFieldFocus(FocusNode focusNode) => _certFieldFocus = focusNode;
  FocusNode get phoneFieldFocus => _phoneFieldFocus;
  FocusNode get certFieldFocus => _certFieldFocus;
  GlobalKey get key => _key;
  TextEditingController get phoneFieldController => _phoneFieldController;
  TextEditingController get certFieldController => _certFieldController;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isStartButtonActive => _isStartButtonActive;
  bool get isSendButtonPressed => _isSendButtonPressed;
  bool get isLoading => _isLoading;
  String get phoneNumber => _phoneFieldController.text;
}
