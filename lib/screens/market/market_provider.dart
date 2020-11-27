import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../models/product.dart';

class MarketProvider extends ChangeNotifier {
  List<Product> _list = List<Product>();
  List<Product> get list => _list;

  Future<void> getProducts() async {
    final QuerySnapshot query = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .get();

    final List<Product> productList = Product.fromQuery(query);
    _list = productList;
    notifyListeners();
  }
}
