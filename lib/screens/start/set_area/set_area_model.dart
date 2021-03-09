import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/navigation_services.dart';
import '../../../services/location_services.dart';
import '../../../services/local_services.dart';
import '../../../models/area.dart';

class SetAreaModel with ChangeNotifier {
  LatLng _myPosition;
  GoogleMapController _mapController;
  GlobalKey _key = GlobalKey();

  var _markers = Set<Marker>();
  var _circles = Set<Circle>();

  LatLng _areaCenter;
  double _areaRadius = 5000;
  String _areaName;

  int _pointCount;
  int _productCount;
  int _tradeCount;

  var _isRangeLoading = true;

  String _fullAddress;
  Area _newArea;

  // **********
  // **** 메서드
  // **********

  // 1. FutureBuilder
  Future<void> onRangeFutureBuild(context) async {
    _myPosition = await LocationServices.getMyPosition(context);
  }

  Future<void> onNameFutureBuild() async {
    final result = await LocationServices.getAddress(_areaCenter);
    _fullAddress = result['full'];
    _areaName = result['short'];
  }

  // 2. 카메라 움직일 때
  void onCameraMoveStarted() {
    _circles.clear();
    notifyListeners();
  }

  // 3. 카메라 멈출 때
  void onCameraIdle() async {
    _isRangeLoading = true;

    await _updateAreaCenter();
    _createCircle();
    notifyListeners();

    await _updateCount();
    _isRangeLoading = false;
    notifyListeners();
  }

  // 4. 슬라이더 움직이면
  void onSliderMove(double radius) async {
    _areaRadius = radius;
    _isRangeLoading = true;

    _createCircle();
    notifyListeners();

    await _updateCount();
    _isRangeLoading = false;
    notifyListeners();
  }

  // 5. 다음버튼 클릭
  void onNextPressed() {
    NavigationServices.toSetAreaName(_key.currentContext);
  }

  // 6. 저장버튼 클릭
  void onSavePressed(String name) async {
    if (name != null) {
      _areaName = name;
    }
    _updateArea();
    LocalServices().updateArea(_newArea);
    NavigationServices.toBase(_key.currentContext);
  }

  Future<void> _updateCount() async {
    await Future.delayed(Duration(milliseconds: 500));

    _pointCount = DateTime.now().microsecond.round();
    _productCount = DateTime.now().millisecond.round();
    _tradeCount = DateTime.now().microsecond.round();
  }

  Future<void> _updateAreaCenter() async {
    final pixelRatio = MediaQuery.of(_key.currentContext).devicePixelRatio;
    final mediaSize = MediaQuery.of(_key.currentContext).size;
    final appbarHeight = Scaffold.of(_key.currentContext).appBarMaxHeight;

    _areaCenter = await _mapController.getLatLng(
      ScreenCoordinate(
        x: (mediaSize.width * pixelRatio / 2).round(),
        y: ((mediaSize.height - appbarHeight) * pixelRatio / 2).round(),
      ),
    );
  }

  void _updateArea() {
    _newArea = Area(
      lat: _areaCenter.latitude,
      lng: _areaCenter.longitude,
      radius: _areaRadius,
      name: _areaName,
      active: true,
    );
  }

  void _createCircle() {
    _circles.clear();
    _circles.add(
      Circle(
        circleId: CircleId('1'),
        center: _areaCenter,
        radius: _areaRadius,
        fillColor: Colors.black45,
      ),
    );
  }

  LatLng get myPosition => _myPosition;
  set setMapController(GoogleMapController controller) =>
      _mapController = controller;
  Set<Marker> get markers => _markers;
  Set<Circle> get circle => _circles;
  LatLng get areaCenter => _areaCenter;
  double get areaRadius => _areaRadius;
  String get areaName => _areaName;
  int get pointCount => _pointCount;
  int get productCount => _productCount;
  int get tradeCount => _tradeCount;
  bool get isRangeLoading => _isRangeLoading;
  String get fullAddress => _fullAddress;
  GlobalKey get key => _key;
}
