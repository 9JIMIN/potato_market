import 'package:flutter/material.dart';

class EditorForm extends StatefulWidget {
  @override
  _EditorFormState createState() => _EditorFormState();
}

class _EditorFormState extends State<EditorForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(hintText: '제품이름'),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: '제품설명'),
          ),
        ],
      ),
    );
  }
}
