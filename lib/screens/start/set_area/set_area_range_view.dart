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
          if (snapshot.connectionState == ConnectionState.done) {
            final model = Provider.of<SetAreaModel>(context);
            return Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  markers: model.markers,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    model.setMapController(controller); // 컨트롤러 부여
                    model.fetchMarkers(); // 마커 가져오기
                  },
                  initialCameraPosition: CameraPosition(
                    target: model.myPosition,
                    zoom: model.initalZoom,
                  ),
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  onCameraMoveStarted: model.onCameraMoveStarted, // 위젯 숨기기
                  onCameraIdle: model.onCameraIdle, // 위젯 보이기, 카운트 업데이트 하기
                ),
                Center(
                  child: Icon(Icons.ac_unit),
                ),
                Positioned(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        maintainState: true,
                        maintainAnimation: true,
                        maintainSize: true,
                        visible: model.isCameraIdle,
                        child: RaisedButton(
                          child: Text('구역 등록하기'),
                          onPressed: () {
                            // 중심좌표, 반지름 받아서 변수 업데이트
                            // reverse geocoding으로 주소가져오기
                            // 이름받기 페이지로 이동
                          },
                        ),
                      ),
                      Icon(
                        // 커스텀 마커로 바꾸기
                        Icons.pin_drop,
                        size: 50,
                      ),
                    ],
                  ),
                ),
                if (model.isCameraIdle)
                  Positioned(
                    bottom: 0,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('포함된 거래위치 수 : ${model.pointCount}'),
                            Text('전일 거래량 : ${model.tradeCount}'),
                            Text('매물 수 : ${model.productCount}'),
                          ],
                        ),
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
