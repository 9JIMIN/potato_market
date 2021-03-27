import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../item_editor_provider.dart';

class ItemEditorBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spot = context.select(
      (ItemEditorProvider model) => model.spot,
    );

    return ListTile(
      title: Text(
        spot.name == null ? '거래장소' : spot.name,
      ),
      onTap: Provider.of<ItemEditorProvider>(
        context,
        listen: false,
      ).onPositionPressed,
      trailing: Icon(Icons.arrow_drop_down),
    );
  }
}
