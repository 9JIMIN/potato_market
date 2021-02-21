import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'set_trade_point_model.dart';

class AddTradePointView extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SetTradePointModel>(context, listen: false);

    Widget centerPoint() => Center(
          child: Icon(Icons.add),
        );

    Widget pointButton() => Center(
          key: model.addPointKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RaisedButton(
                  child: Text('위치 등록하기'),
                  onPressed: () {
                    model.onPointSelected(context);
                  }),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('거래위치 이름 정하기'),
      ),
      body: Stack(
        children: [
          model.googleMap(),
          centerPoint(),
          pointButton(),
        ],
      ),
    );
  }
}
