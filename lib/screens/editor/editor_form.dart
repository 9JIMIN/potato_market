import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import 'editor_provider.dart';

class EditorForm extends StatefulWidget {
  @override
  _EditorFormState createState() => _EditorFormState();
}

class _EditorFormState extends State<EditorForm> {
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
    final model = Provider.of<EditorProvider>(context, listen: false);
    final node = FocusScope.of(context);
    return Form(
      key: model.formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                InkWell(
                  onTap: model.loadAssets,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.photo_camera),
                        Text('${model.imageAssets.length}/10'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List.generate(model.imageAssets.length, (index) {
                        Asset asset = model.imageAssets[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 15),
                          child: Stack(
                            overflow: Overflow.visible,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: AssetThumb(
                                  quality: 10,
                                  asset: asset,
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      model.imageAssets.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Theme.of(context).errorColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '제품이름',
            ),
            focusNode: _titleNode,
            onEditingComplete: () => node.nextFocus(),
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              model.title = value;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '카테고리',
            ),
            focusNode: _categoryNode,
            onEditingComplete: () => node.nextFocus(),
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              model.category = value;
            },
          ),
          TextFormField(
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
            onSaved: (value) {
              model.price = int.parse(value);
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: '제품설명',
            ),
            focusNode: _descriptionNode,
            onEditingComplete: () => node.unfocus(),
            textInputAction: TextInputAction.done,
            onSaved: (value) {
              model.description = value;
            },
          ),
        ],
      ),
    );
  }
}
