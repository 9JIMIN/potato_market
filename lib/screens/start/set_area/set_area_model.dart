import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../start/set_area/set_area_name_view.dart';
import '../../start/base/base_view.dart';
import '../../../providers/local_model.dart';
import '../../../models/area.dart';
import '../../../secrets.dart';

class SetAreaModel with ChangeNotifier {
  LatLng _myPosition;

  var _initalZoom = 12.0;

  GoogleMapController _mapController;

  var _markers = Set<Marker>();

  var _circles = Set<Circle>();

  LatLng _areaCenter;

  double _areaRadius = 5000;

  String _areaName;

  int _pointCount;

  int _productCount;

  int _tradeCount;

  var _isRangeLoading = false;

  String _fullAddress;

  Area _newArea;

  LatLng get myPosition => _myPosition;
  double get initalZoom => _initalZoom;
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

  // **********
  // **** 메서드
  // **********

  // 1. FutureBuilder
  Future<void> onRangeFutureBuild() async {
    await _updateMyPosition();
  }

  Future<void> onNameFutureBuild() async {
    await _updateAreaName();
  }

  // 2. 카메라 움직일 때
  void onCameraMoveStarted() async {
    _deleteCircle();

    notifyListeners();
  }

  // 3. 카메라 멈출 때
  Future<void> onCameraIdle(BuildContext context) async {
    _isRangeLoading = true;
    notifyListeners();

    await _updateAreaCenter(context);
    _createCircle();
    notifyListeners();

    await _updateCount();
    _isRangeLoading = false;
    notifyListeners();
  }

  // 4. 슬라이더 움직이면
  Future<void> onSliderMove(double radius) async {
    _areaRadius = radius;
    _isRangeLoading = true;
    _createCircle();
    notifyListeners();

    await _updateCount();

    _isRangeLoading = false;
    notifyListeners();
  }

  // 5. 다음버튼 클릭
  void onNextPressed(BuildContext context) {
    _toSetAreaName(context);
  }

  // 6. 저장버튼 클릭
  Future<void> onSavePressed(BuildContext context, String name) async {
    _areaName = name;
    _updateArea();
    context.read<LocalModel>().updateArea(_newArea);

    _toBase(context);
  }

  Future<void> _updateMyPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    log(permission.toString());

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    var myPosition = await Geolocator.getCurrentPosition();
    _myPosition = LatLng(myPosition.latitude, myPosition.longitude);
  }

  Future<void> _updateCount() async {
    await Future.delayed(Duration(milliseconds: 500));

    _pointCount = DateTime.now().microsecond.round();
    _productCount = DateTime.now().millisecond.round();
    _tradeCount = DateTime.now().microsecond.round();
  }

  Future<void> _updateAreaCenter(BuildContext context) async {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    var mediaSize = MediaQuery.of(context).size;
    var appbarHeight = Scaffold.of(context).appBarMaxHeight;

    _areaCenter = await _mapController.getLatLng(
      ScreenCoordinate(
        x: (mediaSize.width * pixelRatio / 2).round(),
        y: ((mediaSize.height - appbarHeight) * pixelRatio / 2).round(),
      ),
    );
  }

  Future<void> _updateAreaName() async {
    var url = 'https://maps.googleapis.com/maps/api/geocode/json';
    var lat = _areaCenter.latitude;
    var lng = _areaCenter.longitude;
    var requestUrl =
        '$url?latlng=$lat,$lng&key=${Secrets.googleAPI}&language=ko';

    var response = await http.get(requestUrl);
    Map<String, dynamic> res = jsonDecode(response.body)['results'][0];
    _fullAddress = res['formatted_address'];
    _areaName = res['address_components'][1]['short_name'];
  }

  void _updateArea() {
    _newArea = Area(
      latitude: _areaCenter.latitude,
      longitude: _areaCenter.longitude,
      radius: _areaRadius,
      name: _areaName,
      active: true,
    );
  }

  void _deleteCircle() {
    _circles = Set<Circle>();
  }

  void _createCircle() {
    _circles = Set<Circle>();
    _circles.add(
      Circle(
        circleId: CircleId('1'),
        center: _areaCenter,
        radius: _areaRadius,
        fillColor: Colors.black45,
      ),
    );
  }

  void _toSetAreaName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SetAreaNameView()),
    );
  }

  void _toBase(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => BaseView()),
    );
  }
}
