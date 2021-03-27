import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../item_editor_provider.dart';
import 'item_editor_image_row.dart';

class ItemEditorForm extends StatefulWidget {
  @override
  _EditorFormState createState() => _EditorFormState();
}

class _EditorFormState extends State<ItemEditorForm> {
  FocusNode _titleNode;
  FocusNode _priceNode;
  FocusNode _descriptionNode;

  @override
  void initState() {
    super.initState();
    _titleNode = FocusNode();
    _priceNode = FocusNode();
    _descriptionNode = FocusNode();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _priceNode.dispose();
    _descriptionNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ItemEditorProvider>(context, listen: false);
    final node = FocusScope.of(context);
    Widget titleField() => TextFormField(
          decoration: InputDecoration(
            hintText: '제품이름',
          ),
          focusNode: _titleNode,
          onEditingComplete: () => _priceNode.requestFocus(),
          textInputAction: TextInputAction.next,
          onSaved: (String title) {
            model.setTitle = title;
          },
        );

    Widget categoryField() => ListTile(
          title: Text(model.category == null ? '카테고리' : model.category),
          trailing: Icon(Icons.arrow_drop_down),
          onTap: model.onCategoryPressed,
        );

    Widget priceField() => TextFormField(
          decoration: InputDecoration(
            hintText: '가격',
          ),
          focusNode: _priceNode,
          keyboardType: TextInputType.number,
          onEditingComplete: () => node.nextFocus(),
          textInputAction: TextInputAction.next,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onSaved: (String price) {
            model.setPrice = price;
          },
        );

    Widget descriptionField() => TextFormField(
          decoration: InputDecoration(
            hintText: '제품설명',
          ),
          focusNode: _descriptionNode,
          onEditingComplete: () => node.unfocus(),
          textInputAction: TextInputAction.done,
          onSaved: (String description) {
            model.setDescription = description;
          },
        );
    return Form(
      key: model.formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            ItemEditorImageRow(),
            titleField(),
            categoryField(),
            priceField(),
            descriptionField(),
          ],
        ),
      ),
    );
  }
}
