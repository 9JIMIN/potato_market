import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../product_editor_model.dart';
import './product_editor_image_row.dart';

class ProductEditorForm extends StatefulWidget {
  @override
  _ProductEditorFormState createState() => _ProductEditorFormState();
}

class _ProductEditorFormState extends State<ProductEditorForm> {
  FocusNode _titleNode;
  FocusNode _categoryNode;
  FocusNode _priceNode;
  FocusNode _descriptionNode;

  @override
  void initState() {
    super.initState();
    _titleNode = FocusNode();
    _categoryNode = FocusNode();
    _priceNode = FocusNode();
    _descriptionNode = FocusNode();
  }

  @override
  void dispose() {
    _titleNode.dispose();
    _categoryNode.dispose();
    _priceNode.dispose();
    _descriptionNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProductEditorModel>(context);
    final node = FocusScope.of(context);

    Widget titleField() => TextFormField(
          decoration: InputDecoration(
            hintText: '제품이름',
          ),
          focusNode: _titleNode,
          onEditingComplete: () => node.nextFocus(),
          textInputAction: TextInputAction.next,
          onSaved: model.onTitleSaved,
        );

    Widget categoryField() => TextFormField(
          decoration: InputDecoration(
            hintText: '카테고리',
          ),
          focusNode: _categoryNode,
          onEditingComplete: () => node.nextFocus(),
          textInputAction: TextInputAction.next,
          onSaved: model.onCategorySaved,
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
          onSaved: model.onPriceSaved,
        );

    Widget descriptionField() => TextFormField(
          decoration: InputDecoration(
            hintText: '제품설명',
          ),
          focusNode: _descriptionNode,
          onEditingComplete: () => node.unfocus(),
          textInputAction: TextInputAction.done,
          onSaved: model.onDescriptionSaved,
        );
    return Form(
      key: model.formKey,
      child: Column(
        children: [
          ProductEditorImageRow(),
          titleField(),
          categoryField(),
          priceField(),
          descriptionField(),
        ],
      ),
    );
  }
}
