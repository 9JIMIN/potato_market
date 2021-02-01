import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'start_model.dart';

class StartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<StartModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to 감자마켓'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('시작!'),
          onPressed: () {
            model.toPlace(context);
          },
        ),
      ),
    );
  }
}
