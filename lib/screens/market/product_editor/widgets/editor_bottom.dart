import 'package:potato_market/screens/market/product_editor/product_editor_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../product_editor_model.dart';

class EditorBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tradePoint = context.select(
      (ProductEditorModel model) => model.tradePoint,
    );

    return ListTile(
      title: Text(
        tradePoint.name == null ? '거래장소' : tradePoint.name,
      ),
      onTap: Provider.of<ProductEditorModel>(
        context,
        listen: false,
      ).onPositionPressed,
      trailing: Icon(Icons.arrow_drop_down),
    );
  }
}
