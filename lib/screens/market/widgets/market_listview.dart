import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../market_model.dart';
import 'market_listitem.dart';

class MarketListView extends StatefulWidget {
  @override
  _MarketListViewState createState() => _MarketListViewState();
}

class _MarketListViewState extends State<MarketListView> {
  ScrollController _controller;
  _scrollListener() async {
    if (_controller.position.maxScrollExtent - _controller.position.pixels <
        50) {
      print('끝');
      await context.read<MarketModel>().appendProducts();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    print('Market Screen init');
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Market Screen Build');
    final model = Provider.of<MarketModel>(context);
    return Builder(
      builder: (context) => model.list.isEmpty
          ? Center(
              child: Text('리스트가 비었음'),
            )
          : RefreshIndicator(
              onRefresh: model.fetchProducts,
              child: ListView.builder(
                controller: _controller,
                itemCount: model.list.length,
                itemBuilder: (ctx, i) {
                  return ProductItem(
                    model.list[i].title,
                    model.list[i].price,
                    model.list[i].imageUrls[0],
                    model.list[i].likeCount,
                    model.list[i].chatCount,
                  );
                },
              ),
            ),
    );
  }
}