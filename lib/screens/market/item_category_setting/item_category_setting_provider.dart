import 'package:flutter/material.dart';

import '../../../utils/services/local/local_storage_service.dart';

class ItemCategorySettingProvider with ChangeNotifier {
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
  List<bool> _categoryIsCheck = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];

  void fetchCategory() {
    _categoryIsCheck = LocalStorageService().itemCategories.values;
  }

  void onCategoryTap(int index) {
    // LocalServices().updateProductCategories();
  }

  List<String> get categoryList => _categoryList;
  List<bool> get categoryIsCheck => _categoryIsCheck;
}
