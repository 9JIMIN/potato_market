import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_model.dart';

class ProfileCreateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LoginModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 입력'),
        actions: [
          TextButton(
            onPressed: () {
              model.onProfileButtonPressed();
            },
            child: Text('완료'),
          )
        ],
      ),
      body: Column(
        children: [
          Placeholder(
            fallbackHeight: 50,
            fallbackWidth: 50,
          ),
          Form(
            key: model.profileFormKey,
            child: TextFormField(),
          ),
        ],
      ),
    );
  }
}
