import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../item_editor_provider.dart';

class ItemEditorImageRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ItemEditorProvider>(context);
    return Row(
      children: [
        GestureDetector(
          onTap: model.onImageAdded,
          child: SizedBox(
            height: 70,
            width: 70,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera),
                  Text('${model.imageAssets.length}/10'),
                ],
              ),
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
              children: List.generate(model.imageAssets.length, (index) {
                Asset asset = model.imageAssets[index];
                return Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: AssetThumb(
                          quality: 80,
                          asset: asset,
                          width: 70,
                          height: 70,
                          spinner: SizedBox(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: -10,
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () {
                            model.onImageRemoved(index);
                          },
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
