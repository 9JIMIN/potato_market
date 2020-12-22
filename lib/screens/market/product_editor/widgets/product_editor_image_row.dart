import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../product_editor_model.dart';

class ProductEditorImageRow extends StatefulWidget {
  @override
  _ProductEditorImageRowState createState() => _ProductEditorImageRowState();
}

class _ProductEditorImageRowState extends State<ProductEditorImageRow> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProductEditorModel>(context, listen: false);
    final imageAssets = context.select(
      (ProductEditorModel model) => model.imageAssets,
    );
    return Row(
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
                Text('${imageAssets.length}/10'),
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
              children: List.generate(imageAssets.length, (index) {
                Asset asset = imageAssets[index];
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
                            model.removeImage(index);
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
    );
  }
}
