import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'widgets/item_editor_appbar.dart';
import 'widgets/item_editor_form.dart';
import 'widgets/item_editor_bottom.dart';
import 'item_editor_provider.dart';

class ItemEditorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemEditorProvider(),
      builder: (context, child) {
        final isLoading = context.select(
          (ItemEditorProvider model) => model.isLoading,
        );

        return Scaffold(
          appBar: EditorAppbar(),
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: ItemEditorForm(),
          ),
          bottomSheet: ItemEditorBottom(),
          floatingActionButton: const SizedBox(height: 1),
          // snackbar가 bottomsheet에 가리는 버그때문에 workaround..
        );
      },
    );
  }
}
