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
        // - 내 위치 가져오기
        future: model.fetchMyPosition(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          log('build');
          if (snapshot.connectionState == ConnectionState.done) {
            final model = Provider.of<SetAreaModel>(context);
            return Stack(
              alignment: Alignment.center,
              children: [
                // 1. 구글 맵
                GoogleMap(
                  circles: model.circle,
                  markers: model.markers,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    model.setMapController(controller); // 컨트롤러 부여
                  },
                  initialCameraPosition: CameraPosition(
                    target: model.myPosition,
                    zoom: model.initalZoom,
                  ),
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  onCameraMoveStarted: model.deleteCircle,
                  onCameraIdle: () async {
                    await model.getAreaCenter(context); // 위젯 보이기, 카운트 업데이트 하기
                    model.createCircle();
                    await model.fetchCount();
                  },
                ),

                // 2. 지도 중심 원
                Center(
                  child: Stack(
                    children: [
                      Icon(Icons.add_circle_outline),
                      // TODO: 항상 보이는 원
                    ],
                  ),
                ),

                // 3. 아래 구역 정보
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
                              onChanged: (double radius) async {
                                model.changeRadius(radius);
                                await model.fetchCount();
                              },
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
                            model.toSetAreaName(context);
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
