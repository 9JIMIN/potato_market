import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'set_area_model.dart';
import 'widgets/set_area_stack.dart';

class SetAreaRangeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('범위 정하기'),
      ),
      body: FutureBuilder(
        future: Provider.of<SetAreaModel>(context, listen: false)
            .onRangeFutureBuild(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SetAreaStack();
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
