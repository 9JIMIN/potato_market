import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class AreaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('지역설정'),
      ),
      body: Column(
        children: [
          RaisedButton(
            child: Text('내 좌표'),
            onPressed: () async {
              await model.fetchMyCoords();
            },
          ),
        ],
      ),
    );
  }
}
