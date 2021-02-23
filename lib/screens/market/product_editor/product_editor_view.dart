import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'widgets/editor_appbar.dart';
import 'widgets/editor_form.dart';
import 'widgets/editor_bottom.dart';
import 'product_editor_model.dart';

class ProductEditorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductEditorModel(),
      builder: (context, child) {
        final isLoading = context.select(
          (ProductEditorModel model) => model.isLoading,
        );

        return Scaffold(
          appBar: EditorAppbar(),
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: EditorForm(),
          ),
          bottomSheet: EditorBottom(),
          floatingActionButton: const SizedBox(height: 1),
          // snackbar가 bottomsheet에 가리는 버그때문에 workaround..
        );
      },
    );
  }
}
