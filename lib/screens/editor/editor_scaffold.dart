import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'editor_appbar.dart';
import 'editor_form.dart';
import 'editor_provider.dart';

class EditorScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EditorAppbar(),
      body: Consumer<EditorProvider>(
        builder: (context, model, child) {
          return ModalProgressHUD(
            inAsyncCall: model.isLoading,
            child: child,
          );
        },
        child: EditorForm(),
      ),
    );
  }
}
