import 'package:flutter/material.dart';

import 'editor_form.dart';

class EditorScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글쓰기'),
      ),
      body: EditorForm(),
    );
  }
}
