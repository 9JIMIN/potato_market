import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import 'widget_services.dart';

class StorageServices {
  static final StorageServices _singleton = StorageServices._();
  StorageServices._();
  factory StorageServices() => _singleton;

  final _instance = FirebaseStorage.instance;

  Future<String> storeImage(BuildContext context, File imageFile) async {
    try {
      final imageName = DateTime.now().toString();

      await _instance.ref('profile_images').child(imageName).putFile(imageFile);
      final url = await _instance
          .ref('profile_images')
          .child(imageName)
          .getDownloadURL();
      return url;
    } catch (e) {
      WidgetServices.showAlertDialog(
        context,
        '스토리지 업로드 에러',
        e.toString(),
      );
      return null;
    }
  }
}
