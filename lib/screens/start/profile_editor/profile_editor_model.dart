import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:potato_market/screens/start/login/login_model.dart';
import 'package:potato_market/secrets.dart';
import 'package:provider/provider.dart';

import '../../../services/storage_services.dart';
import '../../../services/cloud_services.dart';
import '../../../models/profile.dart';
import '../../../providers/local_model.dart';

class ProfileEditorModel with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();

  var _nameFieldController = TextEditingController();

  FocusNode _nameFieldFocus;
  String _name;
  File _profileImage;

  var _isRegisterButtonActive = false;
  var _isLoading = false;

  void onProfileInit() {
    _nameFieldFocus = FocusNode();
  }

  void onProfileDispose() {
    _nameFieldFocus.dispose();
  }

  void onNameFieldChanged(String nameInput) {
    if (nameInput.length != 0) {
      _isRegisterButtonActive = true;
      notifyListeners();
    } else {
      if (_isRegisterButtonActive) {
        _isRegisterButtonActive = false;
        notifyListeners();
      }
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // 카메라 버튼 클릭시
  void onCameraButtonPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('카메라'),
            onTap: () async {
              await getImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('갤러리'),
            onTap: () async {
              await getImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  // 계정생성 버튼 클릭시
  void onProfileButtonPressed(BuildContext context) async {
    _isLoading = true;

    notifyListeners();

    _name = _nameFieldController.text;
    final imageUrl = _profileImage == null
        ? Secrets.defaultUserImageUrl
        : await StorageServices().storeImage(context, _profileImage);

    if (imageUrl != null) {
      final profile = Profile(
        uid: context.read<LoginModel>().uid,
        imageUrl: imageUrl,
        name: _name,
        phoneNumber: context.read<LoginModel>().phoneNumber,
      );
      await CloudServices().createUser(profile);
      context.read<LocalModel>().updateProfile(profile);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  GlobalKey get formKey => _formKey;
  TextEditingController get nameFieldController => _nameFieldController;
  FocusNode get nameFieldFocus => _nameFieldFocus;
  bool get isRegisterButtonActive => _isRegisterButtonActive;
  bool get isLoading => _isLoading;
  File get profileImage => _profileImage;
}
