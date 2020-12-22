import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../myaccount_model.dart';

class MyAccountAppbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override
  PreferredSizeWidget build(BuildContext context) {
    final model = Provider.of<MyAccountModel>(context);
    return AppBar(
      title: Text('내 프로필'),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
        DropdownButton(
          items: [
            DropdownMenuItem(
              child: Text('로그아웃'),
              value: 1,
            ),
          ],
          onChanged: model.dropDownMenu,
        )
      ],
    );
  }
}
