import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditorProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String title;
  String category;
  int price;
  String description;
  List<Asset> imageAssets = List<Asset>(); // 초기화를 안시키면 null 에러가 난다.

  bool isLoading = false;

  Future<void> addProducts() async {
    isLoading = true;
    notifyListeners();
    formKey.currentState.save();
    try {
      List<String> _imageUrls = List<String>();
      final DateTime _createdAt = DateTime.now();
      final String _sellerId = FirebaseAuth.instance.currentUser.uid;
      const int _likeCount = 0;
      const int _chatCount = 0;
      const String _status = '판매중';

      final Reference ref = FirebaseStorage.instance.ref().child('products');
      for (var asset in imageAssets) {
        ByteData byteData = await asset.getByteData(quality: 50);
        List<int> imageData = byteData.buffer.asUint8List();
        final photoRef = ref.child(DateTime.now().toString() + '.jpg');
        final finRef = await photoRef.putData(imageData);
        final String downloadUrl = await finRef.ref.getDownloadURL();
        _imageUrls.add(downloadUrl);
      }

      await FirebaseFirestore.instance.collection('products').add({
        'title': title,
        'category': category,
        'price': price,
        'description': description,
        'imageUrls': _imageUrls,
        'createdAt': _createdAt,
        'sellerId': _sellerId,
        'status': _status,
        'likeCount': _likeCount,
        'chatCount': _chatCount,
      });
    } catch (e) {
      print(e);
    }
    isLoading = false;
    title = '';
    category = '';
    price = 0;
    description = '';
    imageAssets = List<Asset>();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: imageAssets,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          statusBarColor: "#FF4E342E",
          actionBarColor: "#FF6D4C41",
          actionBarTitle: "사진선택",
          allViewTitle: "전체 사진",
          useDetailsView: false,
          selectCircleStrokeColor: "#FF6D4C41",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }
    imageAssets = resultList;
    notifyListeners();
  }
}
