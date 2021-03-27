import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../item_editor_provider.dart';

class EditorAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text('글쓰기'),
      actions: [
        TextButton(
          child: Text('완료'),
          onPressed: Provider.of<ItemEditorProvider>(
            context,
            listen: false,
          ).onSavePressed,
        )
      ],
    );
  }
}
