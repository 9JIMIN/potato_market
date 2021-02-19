import 'package:flutter/material.dart';
import 'package:potato_market/screens/market/market/market_model.dart';
import 'package:provider/provider.dart';

import '../product_editor_model.dart';

class EditorAppbar extends StatelessWidget implements PreferredSizeWidget {
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
            Provider.of<ProductEditorModel>(context, listen: false)
                .onSavePressed();
          },
        )
      ],
    );
  }
}
