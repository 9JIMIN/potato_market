import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potato_market/utils/ui/widgets/show_snackbar.dart';

import '../../../utils/services/firebase/auth_service.dart';
import '../../../utils/services/firebase/database_service.dart';
import '../../../utils/services/local/local_storage_service.dart';
import '../../../utils/services/etc/navigation_service.dart';
import '../../../models/profile.dart';

class LoginProvider with ChangeNotifier {
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

  // SMS보내기 함수에 보낼 함수
  void _setCertText(PhoneAuthCredential credential) {
    _certFieldController.text = credential.smsCode;
    _isStartButtonActive = true;
    notifyListeners();
  }

  void _setVerificationId(String verificationId, _) {
    _verificationId = verificationId;
  }

  // 인증번호 보내기 버튼 클릭시
  void onSendButtonPressed() async {
    final phoneText = _phoneFieldController.text;
    if (phoneText.startsWith('01')) {
      ShowSnackbar.snack(key.currentContext, '인증번호를 전송하였습니다.(최대 30초 소요)');
      _phoneFieldFocus.unfocus();

      if (!_isSendButtonPressed) {
        _isSendButtonPressed = true;
        notifyListeners();
      }

      await AuthService().sendCertSMS(
        _key.currentContext,
        phoneText,
        _setCertText,
        _setVerificationId,
      );
    } else {
      ShowSnackbar.snack(_key.currentContext, '전화번호 형태가 잘못되었습니다.');
    }
  }

  // 시작버튼 클릭시
  void onStartButtonPressed() async {
    _isLoading = true;
    _certFieldFocus.unfocus();
    notifyListeners();

    final uid = await AuthService().signIn(
      _key.currentContext,
      _verificationId,
      _certFieldController.text,
    );

    if (uid == null) {
      // 인증실패
      ShowSnackbar.snack(_key.currentContext, '인증번호가 일치하지 않습니다.');
      _isLoading = false;
      notifyListeners();
    } else {
      // 인증성공
      final local = LocalStorageService();
      final myProfile = await DatabaseService().getProfile(uid);
      if (myProfile == null) {
        local.updateProfile(
          Profile(uid: uid, phoneNumber: _phoneFieldController.text),
        );
        NavigationService.toProfileEditor(_key.currentContext);
      } else {
        local.updateProfile(myProfile);
        final activeArea = await DatabaseService().getActiveArea(uid);
        if (activeArea == null) {
          NavigationService.toMyAreaSettingRange(_key.currentContext);
        } else {
          local.updateArea(activeArea);
          final spot = await DatabaseService().getRecentSpot(uid);
          if (spot != null) {
            LocalStorageService().updateSpot(spot);
          }
          NavigationService.toBase(_key.currentContext);
        }
      }
      _isLoading = false;
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
