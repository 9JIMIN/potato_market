import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_detail_provider.dart';

class ItemDetailScreen extends StatelessWidget {
  final i;
  ItemDetailScreen(this.i);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ItemDetailProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('제품이름 : ${model.item.title}'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (var url in model.item.imageUrls) Image.network(url)
              ]),
            ),
          ),
          Text(model.item.title),
          Text(model.item.description),
          Text(model.item.price.toString()),
        ],
      ),
    );
  }
}
