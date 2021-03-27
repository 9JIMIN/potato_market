import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_area_setting_provider.dart';
import 'widgets/my_area_setting_stack.dart';

class MyAreaSettingRange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MyAreaSettingProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('범위 정하기'),
      ),
      body: FutureBuilder(
        future: model.onRangeFutureBuild(context),
        builder: (_, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MyAreaSettingStack();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
