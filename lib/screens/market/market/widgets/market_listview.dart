import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../market_provider.dart';
import 'product_item.dart';

class MarketListView extends StatefulWidget {
  @override
  _MarketListViewState createState() => _MarketListViewState();
}

class _MarketListViewState extends State<MarketListView> {
  ScrollController _controller;
  bool oldState = false;
  bool newState = false;
  _scrollListener() async {
    final model = context.read<MarketProvider>();
    if (_controller.position.maxScrollExtent - _controller.position.pixels <
            100 &&
        model.isAppendDone) {
      await model.appendProducts();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MarketProvider>(context);
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
                  return ProductItem(model.list[i]);
                },
              ),
            ),
    );
  }
}
