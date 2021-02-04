import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:potato_market/models/local.dart';
import 'package:potato_market/providers/local_provider.dart';
import 'package:provider/provider.dart';

import '../../start/set_area/set_area_name_view.dart';
import '../../../models/area.dart';
import '../../../secrets.dart';
import '../../start/base/base_view.dart';

class SetAreaModel with ChangeNotifier {
  LatLng _myPosition;
  LatLng get myPosition => _myPosition;

  var _initalZoom = 12.0;
  double get initalZoom => _initalZoom;

  GoogleMapController mapController;

  LatLng _areaCenter;
  LatLng get areaCenter => _areaCenter;

  double _areaRadius = 5000;
  double get areaRadius => _areaRadius;

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

  var _circles = Set<Circle>();
  Set<Circle> get circle => _circles;

  var _isRangeLoading = false;
  bool get isRangeLoading => _isRangeLoading;

  var _isNameLoading = false;
  bool get isNameLoading => _isNameLoading;

  String _fullAddress;
  String get fullAddress => _fullAddress;

  // **********
  // **** 메서드
  // **********

  Future<void> fetchMyPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    var myPosition = await Geolocator.getCurrentPosition();
    _myPosition = LatLng(myPosition.latitude, myPosition.longitude);
  }

  Future<void> fetchCount() async {
    _isRangeLoading = true;
    notifyListeners();
    // Function 요청
    await Future.delayed(Duration(milliseconds: 500));

    _pointCount = DateTime.now().microsecond.round();
    _productCount = DateTime.now().millisecond.round();
    _tradeCount = DateTime.now().microsecond.round();
    _isRangeLoading = false;
    notifyListeners();
  }

  Future<void> getAreaCenter(BuildContext context) async {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    var mediaSize = MediaQuery.of(context).size;
    var appbarHeight = Scaffold.of(context).appBarMaxHeight;

    _areaCenter = await mapController.getLatLng(
      ScreenCoordinate(
        x: (mediaSize.width * pixelRatio / 2).round(),
        y: ((mediaSize.height - appbarHeight) * pixelRatio / 2).round(),
      ),
    );
  }

  Future<void> fetchAddress() async {
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

  void deleteCircle() {
    _circles = Set<Circle>();
    _markers = Set<Marker>();
    notifyListeners();
  }

  void createCircle() {
    _circles = Set<Circle>();
    _markers = Set<Marker>();
    _circles.add(
      Circle(
        circleId: CircleId('1'),
        center: _areaCenter,
        radius: _areaRadius,
        fillColor: Colors.black45,
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: _areaCenter,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    notifyListeners();
  }

  void changeRadius(double radius) {
    _areaRadius = radius;
    createCircle();
    notifyListeners();
  }

  Future<void> onSaveButtonPressed(String name, BuildContext context) async {
    _areaName = name;
    _isNameLoading = true;
    notifyListeners();

    var area = Area(
      latitude: _areaCenter.latitude,
      longitude: _areaCenter.longitude,
      radius: _areaRadius,
      name: _areaName,
      active: true,
    );
    context.read<LocalProvider>().updateArea(area);
    await saveAreaCloud(area);

    _isNameLoading = false;
    toBase(context);
  }

  Future<void> saveAreaCloud(Area area) async {
    final geo = Geoflutterfire();

    GeoFirePoint point = geo.point(
      latitude: _areaCenter.latitude,
      longitude: _areaCenter.longitude,
    );

    await FirebaseFirestore.instance.collection('area').add({
      'name': _areaName,
      'position': point.data,
      'radius': _areaRadius,
      'active': true,
    });
  } // 클라우드 유저 subcollection으로 저장

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void toSetAreaName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SetAreaNameView()),
    );
  }

  void toBase(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => BaseView()),
    );
  }
}
