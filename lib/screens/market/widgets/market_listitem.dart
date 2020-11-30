import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final title;
  final price;
  final firstImage;
  final likeCount;
  final chatCount;
  ProductItem(
    this.title,
    this.price,
    this.firstImage,
    this.likeCount,
    this.chatCount,
  );
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network('$firstImage'),
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
