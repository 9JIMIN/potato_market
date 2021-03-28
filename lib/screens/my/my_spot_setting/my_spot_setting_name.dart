import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_spot_setting_provider.dart';

class MySpotSettingName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MySpotSettingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('거래위치 이름 정하기'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: model.nameFormKey,
          child: FutureBuilder(
            future: model.onNameFutureBuild(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    Text('새로 등록할 거래장소의 이름을 입력해주세요'),
                    TextFormField(
                      decoration: InputDecoration(),
                      controller: model.nameFieldController,
                    ),
                    Text('주소: ${model.fullAddress}'),
                    ElevatedButton(
                      child: Text('등록하기'),
                      onPressed: model.onNameSaved,
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
