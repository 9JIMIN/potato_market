import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'set_area_model.dart';

class SetAreaRangeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SetAreaModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('범위 정하기'),
      ),
      body: FutureBuilder(
        // 1. Future
        future: model.onRangeFutureBuild(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final model = Provider.of<SetAreaModel>(context);
            return Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  circles: model.circle,
                  markers: model.markers,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    model.setMapController = controller; // 컨트롤러 부여
                  },
                  initialCameraPosition: CameraPosition(
                    target: model.myPosition,
                    zoom: model.initalZoom,
                  ),
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  onCameraMoveStarted: model.onCameraMoveStarted, // 2. 카메라 움직일때
                  onCameraIdle: () async {
                    // 3. 카메라 멈출 때
                    model.onCameraIdle(context);
                  },
                ),
                Center(
                  child: Stack(
                    children: [
                      Icon(Icons.add_circle_outline),
                    ],
                  ),
                ),
                Positioned(
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
                          mainAxisSize: MainAxisSize.min,
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
                            Text('반지름: ${model.areaRadius}'),
                            Text(model.isRangeLoading
                                ? '전일 거래량: ...'
                                : '전일 거래량: ${model.pointCount}'),
                            Text(model.isRangeLoading
                                ? '현재 매물수: ...'
                                : '현재 매물수: ${model.productCount}'),
                          ],
                        ),
                        RaisedButton(
                          onPressed: () {
                            // 5. 저장버튼 누르면
                            model.onNextPressed(context);
                          },
                          child: Text('범위 등록하기'),
                        ),
                      ],
                    ),
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
    );
  }
}
