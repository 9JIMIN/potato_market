import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/product.dart';

class MarketModel extends ChangeNotifier {
  MarketModel() {
    fetchProducts();
  } // Market모델 인스턴스가 생성될 때, 실행됨.

  List<Product> _list = List<Product>();
  List<Product> get list => _list;

  Future<void> fetchProducts() async {
    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();

    final List<Product> productList = Product.fromQuery(query);
    _list = productList;
    notifyListeners();
  }

  Future<void> appendProducts() async {
    final Timestamp lastDate = _list.last.createdAt;
    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .where('createdAt', isLessThan: lastDate)
        .limit(10)
        .get();

    final List<Product> productList = Product.fromQuery(query);
    _list.addAll(productList);
    notifyListeners();
  }
}
