import 'package:flutter/material.dart';

import '../../../../services/navigation_services.dart';

class LoginDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('로그인 하시겠습니까?'),
      content: Text('로그인 없이도 이용은 가능합니다.'),
      actions: [
        FlatButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text('로그인 하기'),
          onPressed: () {
            NavigationServices.toLogin(context);
          },
        ),
      ],
    );
  }
}
