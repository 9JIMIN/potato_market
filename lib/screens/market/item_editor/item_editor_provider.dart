import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:potato_market/config/constants/app_constants.dart';
import 'package:potato_market/utils/ui/widgets/show_dialog.dart';
import 'package:potato_market/utils/ui/widgets/show_snackbar.dart';

import '../../../config/constants/app_constants.dart';
import '../../../utils/services/firebase/database_service.dart';
import '../../../utils/services/firebase/storage_service.dart';
import '../../../utils/services/local/local_storage_service.dart';
import '../../../utils/services/etc/navigation_service.dart';
import '../../../utils/ui/widgets/show_dialog.dart';
import '../../../utils/ui/widgets/show_snackbar.dart';
import '../../../models/item.dart';
import '../../../models/spot.dart';

class ItemEditorProvider with ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  List<Asset> _imageAssets = [];
  List<String> _categoryList = [
    '디지털/가전',
    '가구/인테리어',
    '유아동/유아도서',
    '생활/가공식품',
    '스포츠/레저',
    '여성잡화',
    '여성의류',
    '남성패션/잡화',
    '게임/취미',
    '뷰티/미용',
    '반려동물용품',
    '도서/티켓/음반',
    '식물',
    '기타 중고물품',
  ];
  String _title;
  String _category;
  String _price;
  String _description;
  bool _isLoading = false;
  Spot _spot = LocalStorageService().spot;

  void onImageRemoved(int index) {
    _imageAssets.removeAt(index);
    notifyListeners();
  }

  void onImageAdded() async {
    try {
      _imageAssets = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: _imageAssets,
        materialOptions: MaterialOptions(
          statusBarColor: "#FF4E342E",
          actionBarColor: "#FF6D4C41",
          actionBarTitle: "사진선택",
          allViewTitle: "전체 사진",
          useDetailsView: false,
          selectCircleStrokeColor: "#FF6D4C41",
        ),
      );
      notifyListeners();
    } on Exception catch (e) {
      if (e.toString() != 'The user has cancelled the selection') {
        ShowDialog.alert(
          _formKey.currentContext,
          '이미지 선택에러',
          e.toString(),
        );
      }
    }
  }

  void onCategoryPressed() {
    showDialog(
      context: _formKey.currentContext,
      builder: (_) => Dialog(
        child: ListView.builder(
          itemCount: _categoryList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_categoryList[index]),
              onTap: () {
                _category = _categoryList[index];
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }

  void onPositionPressed() async {
    final spot = await NavigationService.toSetSpot(_formKey.currentContext);
    if (spot != null) {
      _spot = spot;
      notifyListeners();
    }
  }

  void onSavePressed() async {
    _formKey.currentState.save();
    if (_title == '') {
      ShowSnackbar.snack(_formKey.currentContext, '제목을 입력해주세요');
      return;
    }
    if (_category == null) {
      ShowSnackbar.snack(_formKey.currentContext, '카테고리를 선택해주세요');
      return;
    }
    if (_price == '') {
      ShowSnackbar.snack(_formKey.currentContext, '가격을 입력해주세요');
      return;
    }
    if (_description == '') {
      ShowSnackbar.snack(_formKey.currentContext, '설명을 입력해주세요');
      return;
    }
    if (_spot.name == '') {
      ShowSnackbar.snack(_formKey.currentContext, '거래장소를 선택해주세요');
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final createdAt = Timestamp.now();
      final sellerId = LocalStorageService().profile.uid;

      final imageUrls = _imageAssets.isEmpty
          ? [AppConstants.defaultItemImageUrl]
          : await StorageService().storeProductsImage(
              _formKey.currentContext,
              _imageAssets,
            );

      final newProduct = Item(
        title: _title,
        category: _category,
        price: int.parse(_price),
        description: _description,
        imageUrls: imageUrls,
        createdAt: createdAt,
        sellerId: sellerId,
        spot: Spot.toJson(_spot),
      );

      await DatabaseService().createProduct(newProduct);
      Navigator.of(_formKey.currentContext).pop('saved');
    } catch (e) {
      ShowDialog.alert(
        _formKey.currentContext,
        '저장오류',
        e.toString(),
      );
    }
    _isLoading = false;
  }

  // getter, setter
  GlobalKey get formKey => _formKey;
  String get title => _title;
  String get price => _price;
  String get description => _description;
  List<Asset> get imageAssets => _imageAssets;
  String get category => _category;
  bool get isLoading => _isLoading;
  List<String> get categoryList => _categoryList;
  Spot get spot => _spot;

  set setTitle(String title) => _title = title;
  set setPrice(String price) => _price = price;
  set setDescription(String description) => _description = description;
}
