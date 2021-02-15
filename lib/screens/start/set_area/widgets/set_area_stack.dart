import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../set_area_model.dart';

class SetAreaStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SetAreaModel>(context);

    GoogleMap googleMap() => GoogleMap(
          circles: model.circle,
          markers: model.markers,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            model.setMapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: model.myPosition,
            zoom: 12.0,
          ),
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          tiltGesturesEnabled: false,
          onCameraMoveStarted: model.onCameraMoveStarted,
          onCameraIdle: () {
            model.onCameraIdle(context);
          },
        );

    Widget centerPoint() => Center(
          child: Stack(
            children: [
              Icon(Icons.add_circle_outline),
            ],
          ),
        );

    Widget bottom() => Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: model.areaRadius,
                      onChanged: model.onSliderMove,
                      min: 1000,
                      max: 20000,
                      divisions: 10,
                      label: model.areaRadius.toString(),
                    ),
                    Text('반지름: ${model.areaRadius / 1000} km'),
                    Text(model.isRangeLoading
                        ? '전일 거래량: ...'
                        : '전일 거래량: ${model.pointCount} 건'),
                    Text(model.isRangeLoading
                        ? '현재 매물수: ...'
                        : '현재 매물수: ${model.productCount * 10} 개'),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    model.onNextPressed(context);
                  },
                  child: Text('범위 등록하기'),
                ),
              ],
            ),
          ),
        );
    return Stack(
      alignment: Alignment.center,
      children: [
        googleMap(),
        centerPoint(),
        bottom(),
      ],
    );
  }
}
