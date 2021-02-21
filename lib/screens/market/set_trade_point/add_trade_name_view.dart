import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'set_trade_point_model.dart';

class AddTradeNameView extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SetTradePointModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('거래위치 이름 정하기'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: FutureBuilder(
            future: model.onNameFutureBuild(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Text('새로 등록할 거래장소의 이름을 입력해주세요'),
                    TextFormField(
                      decoration: InputDecoration(),
                      onSaved: (String name) {
                        model.onNameSaved(context, name);
                      },
                    ),
                    Text('주소: ${model.fullAddress}'),
                    RaisedButton(
                      child: Text('등록하기'),
                      onPressed: () {
                        formKey.currentState.save();
                      },
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
