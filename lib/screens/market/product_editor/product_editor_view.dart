import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'widgets/editor_appbar.dart';
import 'widgets/editor_form.dart';
import 'product_editor_model.dart';

class ProductEditorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductEditorModel(),
      builder: (context, child) {
        final model = Provider.of<ProductEditorModel>(context, listen: false);
        final isLoading = context.select(
          (ProductEditorModel model) => model.isLoading,
        );

        return Scaffold(
          appBar: EditorAppbar(),
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: EditorForm(),
            ),
          ),
          bottomSheet: ListTile(
            title: Text(
              model.tradePoint.name == null ? '거래장소' : model.tradePoint.name,
            ),
            onTap: model.onPositionPressed,
            trailing: Icon(Icons.arrow_drop_down),
          ),
          // snackbar가 bottomsheet에 가리는 버그때문에 workaround..
          floatingActionButton: const SizedBox(height: 1),
        );
      },
    );
  }
}
