import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../product_detail/product_detail_model.dart';
import '../product_detail/product_detail_screen.dart';
import '../product_editor/product_editor_view.dart';
import '../product_categories/category_setting_screen.dart';
import '../../../services/local_model.dart';

import '../../../services/cloud_services.dart';

class MarketModel extends ChangeNotifier {
  MarketModel() {
    fetchProducts();
  }

  List<Product> _list = List<Product>();
  bool _isAppendDone = true;

  // product 업데이트
  Future<void> fetchProducts() async {
    // final QuerySnapshot query =
    // await CloudServices().getProductList();
    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('product')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();
    final List<Product> productList = Product.fromQuery(query);
    _list = productList;
    notifyListeners();
  }

  Future<void> appendProducts() async {
    _isAppendDone = false;
    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('product')
        .orderBy('createdAt', descending: true)
        .where('createdAt', isLessThan: _list.last.createdAt)
        .limit(10)
        .get();

    final List<Product> productList = Product.fromQuery(query);
    _list.addAll(productList);
    _isAppendDone = true;
    notifyListeners();
  }

  // product 선택
  void onItemTap(BuildContext context, int i) {
    Provider.of<ProductDetailModel>(
      context,
      listen: false,
    ).fetchProduct(list[i]);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(i),
      ),
    );
  }

  // 앱바 액션
  void onCategoryIconTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategorySettingScreen(),
      ),
    );
  }

  void onSearchPressed(BuildContext context) {}

  // 에디터 버튼
  void onFloatPressed(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductEditorView(),
      ),
    );
    if (result == 'saved') {
      fetchProducts();
    }
  }

  bool get isAppendDone => _isAppendDone;
  List<Product> get list => _list;
}
