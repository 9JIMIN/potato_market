import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'editor_provider.dart';

class EditorAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  PreferredSizeWidget build(BuildContext context) {
    final model = Provider.of<EditorProvider>(context, listen: false);
    return AppBar(
      title: Text('글쓰기'),
      actions: [
        FlatButton(
          child: Text('완료'),
          onPressed: () async {
            await model.addProduct();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
