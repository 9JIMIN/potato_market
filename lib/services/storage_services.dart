import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'widget_services.dart';

class StorageServices {
  static final StorageServices _singleton = StorageServices._();
  StorageServices._();
  factory StorageServices() => _singleton;

  final _instance = FirebaseStorage.instance;

  Future<String> storeProfileImage(
    BuildContext context,
    File imageFile,
  ) async {
    try {
      final imageName = DateTime.now().toString() + '.jpg';

      final finRef = await _instance
          .ref('profile_images')
          .child(imageName)
          .putFile(imageFile);

      final url = await finRef.ref.getDownloadURL();
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

  Future<List<String>> storeProductsImage(
    BuildContext context,
    List<Asset> assets,
  ) async {
    final imageUrls = List<String>();
    try {
      for (var asset in assets) {
        ByteData byteData = await asset.getByteData(quality: 50);
        List<int> imageData = byteData.buffer.asUint8List();

        final imageName = DateTime.now().toString() + '.jpg';
        final finRef = await _instance
            .ref('product_images')
            .child(imageName)
            .putData(imageData);

        final url = await finRef.ref.getDownloadURL();
        imageUrls.add(url);
      }
      return imageUrls;
    } catch (e) {
      WidgetServices.showAlertDialog(context, '스토리지 업로드 에러', e.toString());
      return null;
    }
  }
}
