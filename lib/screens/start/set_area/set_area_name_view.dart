import 'package:flutter/material.dart';

class SetAreaNameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('구역 이름'),
      ),
      body: Form(
        child: Column(
          children: [
            TextFormField(),
          ],
        ),
      ),
    );
  }
}
