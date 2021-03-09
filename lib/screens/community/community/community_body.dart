import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/local_services.dart';

class CommunityBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('커뮤니티'),
          RaisedButton(
            child: Text('로컬 데이터 삭제하기'),
            onPressed: LocalServices().deleteData,
          )
        ],
      ),
    );
  }
}
