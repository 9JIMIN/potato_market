import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'market_provider.dart';
import 'product_item.dart';

class MarketListView extends StatefulWidget {
  @override
  _MarketListViewState createState() => _MarketListViewState();
}

class _MarketListViewState extends State<MarketListView> {
  Future<void> getProducts() async {
    await Provider.of<MarketProvider>(context, listen: false).getProducts();
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // final model = Provider.of<MarketProvider>(context, listen: false);
    return Consumer<MarketProvider>(
      builder: (context, model, _) {
        if (model.list.isEmpty) {
          return Center(
            child: Text('제품이 없습니다.'),
          );
        } else {
          return RefreshIndicator(
            onRefresh: getProducts,
            child: ListView.builder(
              itemCount: model.list.length,
              itemBuilder: (ctx, i) {
                print(model.list[i]);
                return ProductItem(
                  model.list[i].title,
                  model.list[i].price,
                  model.list[i].imageUrls[0],
                  model.list[i].likeCount,
                  model.list[i].chatCount,
                );
              },
            ),
          );
        }
      },
    );
  }
}
