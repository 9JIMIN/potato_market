import 'package:flutter/material.dart';
import 'package:potato_market/screens/market/set_trade_point/set_trade_point_model.dart';
import 'package:provider/provider.dart';

import '../../../services/navigation_services.dart';

import 'dart:developer';

class SetTradePointView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SetTradePointModel>(context, listen: false);

    Widget bottom() => Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1'),
                  ],
                ),
                RaisedButton(
                  child: Text('이 위치에서 거래하기'),
                  onPressed: () {},
                )
              ],
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('거래장소 선택'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_location_alt_outlined),
            onPressed: model.isMapLoading
                ? null
                : () {
                    NavigationServices.toAddTradePoint(context);
                  },
          ),
        ],
      ),
      body: FutureBuilder(
        future: model.onMapFutureBuild(context),
        builder: (_, AsyncSnapshot snapshot) {
          log(snapshot.connectionState.toString());
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                model.googleMap(),
                bottom(),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
