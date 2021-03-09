import 'package:flutter/material.dart';

import 'widgets/market_listview.dart';

class MarketView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MarketListView(),
    );
  }
}
