import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/profile.dart';
import '../../../config/constants/app_constants.dart';
import '../../../utils/services/firebase/storage_service.dart';
import '../../../utils/services/firebase/database_service.dart';
import '../../../utils/services/local/local_storage_service.dart';
import '../../../utils/services/etc/navigation_service.dart';

class ProfileEditorProvider with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();

  var _nameFieldController = TextEditingController();

  FocusNode _nameFieldFocus;
  String _name;
  File _profileImage;

  var _isRegisterButtonActive = false;
  var _isLoading = false;

  GlobalKey _testkey = GlobalKey();
  GlobalKey get testkey => _testkey;

  void onProfileInit() {
    _nameFieldFocus = FocusNode();
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
    final pickedFile = await ImagePicker().getImage(
      source: source,
      imageQuality: 50,
    );

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
        ? AppConstants.defaultProfileImageUrl
        : await StorageService().storeProfileImage(context, _profileImage);

    final profile = Profile(
      uid: LocalStorageService().profile.uid,
      phoneNumber: LocalStorageService().profile.phoneNumber,
      imageUrl: imageUrl,
      name: _name,
    );
    await DatabaseService().createUser(profile);
    LocalStorageService().updateProfile(profile);
    NavigationService.toSetAreaRange(_formKey.currentContext);
  }

  GlobalKey get formKey => _formKey;
  TextEditingController get nameFieldController => _nameFieldController;
  FocusNode get nameFieldFocus => _nameFieldFocus;
  bool get isRegisterButtonActive => _isRegisterButtonActive;
  bool get isLoading => _isLoading;
  File get profileImage => _profileImage;
}
