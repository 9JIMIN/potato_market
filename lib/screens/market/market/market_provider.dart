import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/item.dart';
import '../item_detail/item_detail_provider.dart';
import '../item_detail/item_detail_screen.dart';
import '../item_editor/item_editor_screen.dart';
import '../item_category_setting/item_category_setting_screen.dart';

class MarketProvider extends ChangeNotifier {
  MarketProvider() {
    fetchProducts();
  }

  List<Item> _list = [];
  bool _isAppendDone = true;

  // product 업데이트
  Future<void> fetchProducts() async {
    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('product')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();
    final List<Item> productList = Item.fromQuery(query);
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

    final List<Item> productList = Item.fromQuery(query);
    _list.addAll(productList);
    _isAppendDone = true;
    notifyListeners();
  }

  // product 선택
  void onItemTap(BuildContext context, int i) {
    Provider.of<ItemDetailProvider>(
      context,
      listen: false,
    ).fetchProduct(list[i]);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(i),
      ),
    );
  }

  // 앱바 액션
  void onCategoryIconTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemCategorySettingScreen(),
      ),
    );
  }

  void onSearchPressed(BuildContext context) {}

  // 에디터 버튼
  void onFloatPressed(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemEditorScreen(),
      ),
    );
    if (result == 'saved') {
      fetchProducts();
    }
  }

  bool get isAppendDone => _isAppendDone;
  List<Item> get list => _list;
}
