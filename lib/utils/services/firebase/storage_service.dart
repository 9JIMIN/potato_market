import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../ui/widgets/show_dialog.dart';

class StorageService {
  static final StorageService _singleton = StorageService._();
  StorageService._();
  factory StorageService() => _singleton;

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
      ShowDialog.alert(context, '스토리지 업로드 에러', e.toString());
      return null;
    }
  }

  Future<List<String>> storeProductsImage(
    BuildContext context,
    List<Asset> assets,
  ) async {
    final imageUrls = [];
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
      ShowDialog.alert(context, '스토리지 업로드 에러', e.toString());
      return null;
    }
  }
}
