import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ProductEditorModel extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _category;
  int _price;
  String _description;
  List<Asset> _imageAssets = List<Asset>(); // 초기화를 안시키면 null 에러가 난다.
  bool isLoading = false;

  GlobalKey get formKey => _formKey;
  String get title => _title;
  int get price => _price;
  String get description => _description;
  List<Asset> get imageAssets => _imageAssets;

  void onTitleSaved(String value) {
    _title = value;
  }

  void onCategorySaved(String value) {
    _category = value;
  }

  void onPriceSaved(String value) {
    _price = int.parse(value);
  }

  void onDescriptionSaved(String value) {
    _description = value;
  }

  void removeImage(int index) {
    _imageAssets.removeAt(index);
    notifyListeners();
  }

  Future<void> addProduct() async {
    isLoading = true;
    notifyListeners();
    _formKey.currentState.save();
    try {
      List<String> _imageUrls = List<String>();
      final DateTime _createdAt = DateTime.now();
      final String _sellerId = FirebaseAuth.instance.currentUser.uid;
      const int _likeCount = 0;
      const int _chatCount = 0;
      const String _status = '판매중';

      final Reference ref = FirebaseStorage.instance.ref().child('products');
      if (_imageAssets.isEmpty) {
        _imageUrls.add(
            'https://firebasestorage.googleapis.com/v0/b/potato-market-4e46b.appspot.com/o/default-images%2Fproduct.png?alt=media&token=78e26f57-b2ea-46e5-be79-3ae3d3931250');
      } else {
        for (var asset in _imageAssets) {
          ByteData byteData = await asset.getByteData(quality: 50);
          List<int> imageData = byteData.buffer.asUint8List();
          final photoRef = ref.child(DateTime.now().toString() + '.jpg');
          final finRef = await photoRef.putData(imageData);
          final String downloadUrl = await finRef.ref.getDownloadURL();
          _imageUrls.add(downloadUrl);
        }
      }

      await FirebaseFirestore.instance.collection('products').add({
        'title': _title,
        'category': _category,
        'price': _price,
        'description': _description,
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
    _title = '';
    _category = '';
    _price = 0;
    _description = '';
    _imageAssets = List<Asset>();
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: _imageAssets,
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
    _imageAssets = resultList;
    notifyListeners();
  }
}
