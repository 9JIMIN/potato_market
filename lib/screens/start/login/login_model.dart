import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:provider/provider.dart';

import 'profile_create_view.dart';
import '../../../providers/cloud_services.dart';
import '../../../providers/auth_services.dart';
import '../../../providers/widget_services.dart';
import '../../../providers/local_model.dart';

class LoginModel with ChangeNotifier {
  FocusNode _phoneFieldFocus;
  FocusNode _certFieldFocus;

  final _loginFormKey = GlobalKey<FormState>();
  final _profileFormKey = GlobalKey<FormState>();

  var _phoneFieldController = TextEditingController();
  var _certFieldController = TextEditingController();

  var _isSendButtonDisabled = true;
  var _isStartButtonDisabled = true;
  var _isSendButtonPressed = false;
  var _isLoginLoading = false;
  var _isProfileLoading = false;

  String _verificationId;

  void onLoginInit() {
    _phoneFieldFocus = FocusNode();
    _certFieldFocus = FocusNode();
  }

  void onLoginDispose() {
    _phoneFieldFocus.dispose();
    _certFieldFocus.dispose();
  }

  void phoneFieldOnChanged(String phoneInput) {
    if (phoneInput.length >= 10) {
      _isSendButtonDisabled = false;
      notifyListeners();
    }
  }

  void certFieldOnChanged(String certInput) {
    if (certInput.length == 6) {
      _isStartButtonDisabled = false;
      notifyListeners();
    }
  }

  String certFieldValidator(String certInput) {
    return '잘못된 인증번호';
  }

  void _setCertText(PhoneAuthCredential credential) {
    _certFieldController.text = credential.smsCode;
    _isStartButtonDisabled = false;
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
    _isLoginLoading = true;
    _certFieldFocus.unfocus();
    notifyListeners();

    final uid = await AuthServices().signIn(
      context,
      _verificationId,
      _certFieldController.text,
    );
    if (uid != null) {
      final myProfile = await CloudServices().getUser(uid);
      if (myProfile != null) {
        context.read<LocalModel>().updateProfile(myProfile);
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfileCreateView(),
          ),
        );
      }
    } else {
      _loginFormKey.currentState.validate();
    }
  }

  // 계정생성 버튼 클릭시
  void onProfileButtonPressed() {}

  ////////////////////////////
  ////////////////////////////
  /// getter, setter

  set setPhoneFieldFocus(FocusNode focusNode) => _phoneFieldFocus = focusNode;
  set setCertFieldFocus(FocusNode focusNode) => _certFieldFocus = focusNode;
  FocusNode get phoneFieldFocus => _phoneFieldFocus;
  FocusNode get certFieldFocus => _certFieldFocus;
  GlobalKey get loginFormKey => _loginFormKey;
  GlobalKey get profileFormKey => _profileFormKey;
  TextEditingController get phoneFieldController => _phoneFieldController;
  TextEditingController get certFieldController => _certFieldController;
  bool get isSendButtonDisabled => _isSendButtonDisabled;
  bool get isStartButtonDisabled => _isStartButtonDisabled;
  bool get isSendButtonPressed => _isSendButtonPressed;
  bool get isLoading => _isLoginLoading;
  bool get isProfileLoading => _isProfileLoading;
}
