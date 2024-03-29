import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_area_setting_provider.dart';

class MyAreaSettingName extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MyAreaSettingProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('구역 이름 정하기'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text('구역의 이름을 적어주세요.'),
                FutureBuilder(
                  future: model.onNameFutureBuild(),
                  builder: (_, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                              decoration: InputDecoration(),
                              initialValue: model.areaName,
                              onSaved: (String name) {
                                model.onSavePressed(name);
                              }),
                          Text('중심 주소: ${model.fullAddress}'),
                          Text(
                              '반지름 크기: ${(model.areaRadius / 1000).floor()} km'),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              child: Text('등록하기'),
                              onPressed: () {
                                formKey.currentState.save();
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
