import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:potato_market/providers/my_model.dart';
import 'package:potato_market/screens/product_detail/product_detail_model.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../market/market/market_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final i;
  ProductDetailScreen(this.i);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProductDetailModel>(context);
    final id = Provider.of<MyModel>(context).myId;
    log(id);
    return Scaffold(
      appBar: AppBar(
        title: Text('제품이름 : ${model.product.title}'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (var url in model.product.imageUrls) Image.network(url)
              ]),
            ),
          ),
          Text(model.product.title),
          Text(model.product.description),
          Text(model.product.price.toString()),
        ],
      ),
    );
  }
}
