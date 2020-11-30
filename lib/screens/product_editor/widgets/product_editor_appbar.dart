import 'package:flutter/material.dart';
import 'package:potato_market/screens/market/market_model.dart';
import 'package:provider/provider.dart';

import '../product_editor_model.dart';

class ProductEditorAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text('글쓰기'),
      actions: [
        FlatButton(
          child: Text('완료'),
          onPressed: () async {
            await context.read<ProductEditorModel>().addProduct();
            await context.read<MarketModel>().fetchProducts();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
