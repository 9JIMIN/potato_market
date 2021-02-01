import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potato_market/screens/start/set_area/set_area_name_view.dart';

import '../../../models/area.dart';
import '../../start/base/base_view.dart';

class SetAreaModel with ChangeNotifier {
  LatLng _myPosition;
  LatLng get myPosition => _myPosition;

  var _initalZoom = 15.0;
  double get initalZoom => _initalZoom;

  GoogleMapController mapController;

  LatLng _areaCenter;
  LatLng get areaCenter => _areaCenter;

  int _areaRadius;
  int get areaRadius => _areaRadius;

  String _areaName;
  String get areaName => _areaName;

  int _pointCount;
  int get pointCount => _pointCount;

  int _productCount;
  int get productCount => _productCount;

  int _tradeCount;
  int get tradeCount => _tradeCount;

  var _markers = Set<Marker>();
  Set<Marker> get markers => _markers;

  var _isCameraIdle = true;
  bool get isCameraIdle => _isCameraIdle;

  // 메서드

  Future<void> fetchMyPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    var myPosition = await Geolocator.getCurrentPosition();
    _myPosition = LatLng(myPosition.latitude, myPosition.longitude);
  }

  Future<void> fetchMarkers() async {} // 지도 카메라 위치에 따라 마커 가져오기..

  Future<void> fetchCount() async {} // 범위내 카운트정보 업데이트..

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void onCameraMoveStarted() {
    _isCameraIdle = false;
    notifyListeners();
  }

  void onCameraIdle() {
    _isCameraIdle = true;
    notifyListeners();
  }

  Future<void> getAreaCenter(BuildContext context) async {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    var mediaSize = MediaQuery.of(context).size;

    _areaCenter = await mapController.getLatLng(
      ScreenCoordinate(
        x: (mediaSize.width * pixelRatio / 2).round(),
        y: (mediaSize.height * pixelRatio / 2).round(),
      ),
    );
  }

  void getAreaRadius() {}

  void getAreaName(String name) {}

  Future<void> saveAreaLocal(Area area) async {} // 디바이스(로컬)에 저장

  Future<void> saveAreaCloud(Area area) async {} // 클라우드 유저 subcollection으로 저장

  void toSetAreaName(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SetAreaNameView()),
    );
  }
}
