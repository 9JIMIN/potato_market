import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/local_model.dart';

class CommunityBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('커뮤니티'),
          RaisedButton(
            child: Text('로컬 데이터 삭제하기'),
            onPressed:
                Provider.of<LocalModel>(context, listen: false).deleteData,
          )
        ],
      ),
    );
  }
}
