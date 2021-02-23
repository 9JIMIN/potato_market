import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../product_detail/product_detail_model.dart';
import '../product_detail/product_detail_screen.dart';
import '../product_editor/product_editor_view.dart';
import '../product_categories/category_setting_screen.dart';

class MarketModel extends ChangeNotifier {
  MarketModel() {
    fetchProducts();
  } // Market모델 인스턴스가 생성될 때, 실행됨.

  List<Product> _list = List<Product>();
  List<Product> get list => _list;

  bool _isAppendDone = true;
  bool get isAppendDone => _isAppendDone;

  Future<void> fetchProducts() async {
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

  void onCategoryIconTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategorySettingScreen(),
      ),
    );
  }

  void onSearchPressed(BuildContext context) {}
}
