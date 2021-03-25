import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'set_trade_point_model.dart';

class SetSpotView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SetSpotModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('거래장소 선택'),
      ),
      body: FutureBuilder(
        future: model.onMapFutureBuild(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final isMoving = context.select(
            (SetSpotModel model) => model.isButtonVisible,
          );

          GoogleMap googleMap() => GoogleMap(
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  model.setMapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: model.initialPosition,
                  zoom: 12.0,
                ),
                onCameraMoveStarted: model.onCameraMoved,
                onCameraIdle: model.onCameraIdle,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                tiltGesturesEnabled: false,
              );

          Widget centerPoint() => Center(
                child: Icon(Icons.add),
              );

          Widget pointButton(BuildContext context) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RaisedButton(
                      child: Text('위치 등록하기'),
                      onPressed: () {
                        model.onPointButtonPressed(context);
                      },
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              );

          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                googleMap(),
                centerPoint(),
                if (isMoving) pointButton(context),
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
