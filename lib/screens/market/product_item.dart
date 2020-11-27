import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final title;
  final price;
  final image;
  final likeCount;
  final chatCount;
  ProductItem(
    this.title,
    this.price,
    this.image,
    this.likeCount,
    this.chatCount,
  );
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network('$image'),
      title: Text(title),
      subtitle: Text('$price'),
      trailing: Column(
        children: [
          Text('like: $likeCount'),
          Text('chat: $chatCount'),
        ],
      ),
    );
  }
}
