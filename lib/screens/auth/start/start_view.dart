import 'package:flutter/material.dart';
import 'package:potato_market/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class StartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to 감자마켓'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('시작!'),
          onPressed: () {
            model.toArea(context);
          },
        ),
      ),
    );
  }
}
