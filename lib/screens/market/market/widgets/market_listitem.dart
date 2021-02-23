import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../market_model.dart';

class ProductItem extends StatelessWidget {
  final i;
  final title;
  final price;
  final firstImage;
  final likeCount;
  final chatCount;
  ProductItem(
    this.i,
    this.title,
    this.price,
    this.firstImage,
    this.likeCount,
    this.chatCount,
  );
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MarketModel>(context);
    return ListTile(
        leading: Image.network('$firstImage'),
        title: Text(title),
        subtitle: Text('$price'),
        trailing: Column(
          children: [
            Text('like: $likeCount'),
            Text('chat: $chatCount'),
          ],
        ),
        onTap: () {
          model.onItemTap(context, i);
        });
  }
}
