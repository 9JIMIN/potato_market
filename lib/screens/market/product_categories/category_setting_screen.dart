import 'package:flutter/material.dart';

class CategorySettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카테고리 설정'),
      ),
      body: Column(
        children: [
          Text('관심 카테고리를 고르세요'),
        ],
      ),
    );
  }
}
