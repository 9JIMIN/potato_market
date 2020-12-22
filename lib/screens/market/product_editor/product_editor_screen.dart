import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'widgets/product_editor_appbar.dart';
import 'widgets/product_editor_form.dart';
import 'product_editor_model.dart';

class ProductEditorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (ProductEditorModel model) => model.isLoading,
    );
    return Scaffold(
      appBar: ProductEditorAppbar(),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: ProductEditorForm(),
      ),
    );
  }
}
