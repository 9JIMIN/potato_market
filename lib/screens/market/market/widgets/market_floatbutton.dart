import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../market_provider.dart';

class MarketFloatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      Provider.of<MarketProvider>(
        context,
        listen: false,
      ).onFloatPressed(context);
    });
  }
}
