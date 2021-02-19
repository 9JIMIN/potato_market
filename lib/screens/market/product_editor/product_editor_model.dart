import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../../../secrets.dart';
import '../../../services/cloud_services.dart';
import '../../../services/storage_services.dart';
import '../../../services/widget_services.dart';
import '../../../providers/local_model.dart';
import '../../../models/product.dart';
import '../../../models/trade_point.dart';

class ProductEditorModel extends ChangeNotifier {
  ProductEditorModel() {
    log('에디터 모델 생성');
  }
  final _formKey = GlobalKey<FormState>();
  List<Asset> _imageAssets = List<Asset>();
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
  TradePoint _tradePoint;
  bool _isAuction = false;
  bool _isLoading = false;

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
      WidgetServices.showAlertDialog(
        _formKey.currentContext,
        '이미지 선택에러',
        e.toString(),
      );
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

  void onAuctionPressed() {}

  void onPositionPressed() {
    final localModel = _formKey.currentContext.read<LocalModel>();
    showDialog(
        context: _formKey.currentContext,
        builder: (_) {
          final isTradePointExist =
              localModel.tradePoint['tradePointName'] != null;
          if (isTradePointExist) {
            return Dialog(
              child: ListView(
                children: [
                  //
                ],
              ),
            );
          } else {
            return Dialog(
              child: Column(
                children: [],
              ),
            );
          }
        });
  }

  void onSavePressed() async {
    _formKey.currentState.save();
    if (_title == null) {
      WidgetServices.showSnack(_formKey.currentContext, '제목을 입력해주세요');
      return;
    }
    if (_category == null) {
      WidgetServices.showSnack(_formKey.currentContext, '카테고리를 선택해주세요');
      return;
    }
    if (_price == null) {
      WidgetServices.showSnack(_formKey.currentContext, '가격을 입력해주세요');
      return;
    }
    if (_description == null) {
      WidgetServices.showSnack(_formKey.currentContext, '설명을 입력해주세요');
      return;
    }
    if (_tradePoint == null) {
      WidgetServices.showSnack(_formKey.currentContext, '거래장소를 선택해주세요');
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      final createdAt = Timestamp.now();
      final sellerId =
          _formKey.currentContext.read<LocalModel>().profile['uid'];

      final imageUrls = _imageAssets.isEmpty
          ? [Secrets.defaultProductImageUrl]
          : await StorageServices().storeProductsImage(
              _formKey.currentContext,
              _imageAssets,
            );
      final newProduct = Product(
        title: _title,
        category: _category,
        price: int.parse(_price),
        description: _description,
        imageUrls: imageUrls,
        createdAt: createdAt,
        sellerId: sellerId,
        tradePoint: TradePoint.toJson(_tradePoint),
      );

      await CloudServices().createProduct(newProduct);
      // TODO: 마켓 스크린도 업데이트 필요!!
      Navigator.of(_formKey.currentContext).pop();
    } catch (e) {
      WidgetServices.showAlertDialog(
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
  bool get isAuction => _isAuction;
  bool get isLoading => _isLoading;
  List<String> get categoryList => _categoryList;
  TradePoint get tradePoint => _tradePoint;

  set setTitle(String title) => _title = title;
  set setCategory(String category) => _category = category;
  set setPrice(String price) => _price = price;
  set setDescription(String description) => _description = description;
}
