import 'package:flutter/material.dart';
import 'package:potato_market/screens/market/market/market_model.dart';
import 'package:provider/provider.dart';

class MarketFloatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      Provider.of<MarketModel>(
        context,
        listen: false,
      ).onFloatPressed(context);
    });
  }
}
