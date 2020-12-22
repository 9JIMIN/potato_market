import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../market_model.dart';

class MarketAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  PreferredSizeWidget build(BuildContext context) {
    final model = Provider.of<MarketModel>(context);
    return AppBar(
      title: Text('products'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.tune),
          onPressed: () {
            model.onCategoryIconTap(context);
          },
        ),
      ],
    );
  }
}
