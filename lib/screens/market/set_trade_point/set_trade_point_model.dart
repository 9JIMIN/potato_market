import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potato_market/services/local_model.dart';
import 'package:potato_market/services/location_services.dart';
import 'package:http/http.dart' as http;

import '../../../secrets.dart';
import '../../../services/navigation_services.dart';
import '../../../services/widget_services.dart';
import '../../../models/trade_point.dart';

import 'dart:developer';

class SetTradePointModel with ChangeNotifier {
  LatLng _initialPosition;
  GoogleMapController _mapController;
  String _fullAddress;
  TradePoint _tradePoint;

  GlobalKey _addPointKey = GlobalKey<ScaffoldState>();

  LatLng _pointCenter;
  bool _isMapLoading = false;

  var _markers = Set<Marker>();

  Future<void> onMapFutureBuild(BuildContext context) async {
    _isMapLoading = true;
    final lat = LocalServices().tradePoint.lat;
    final lng = LocalServices().tradePoint.lng;
    if (lat == null && lng == null) {
      _initialPosition = await LocationServices.getMyPosition(context);
    } else {
      _initialPosition = LatLng(lat, lng);
    }
    _isMapLoading = false;
  }

  Future<void> onNameFutureBuild() async {
    await _updateAddress();
  }

  void onAddPointPressed() {}

  void onMarkerSelected() {}

  void onPointSelected(BuildContext context) async {
    await _updateCenter(_addPointKey.currentContext);
    NavigationServices.toAddTradeName(context);
  }

  void onNameSaved(BuildContext context, String name) {
    if (name == '') {
      WidgetServices.showSnack(context, '장소의 이름을 입력해주세요');
    } else {
      _tradePoint = TradePoint(
        lat: _pointCenter.latitude,
        lng: _pointCenter.longitude,
        name: name,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  Future<void> _updateAddress() async {
    var url = 'https://maps.googleapis.com/maps/api/geocode/json';
    var lat = _pointCenter.latitude;
    var lng = _pointCenter.longitude;
    var requestUrl =
        '$url?latlng=$lat,$lng&key=${Secrets.googleAPI}&language=ko';

    var response = await http.get(requestUrl);
    Map<String, dynamic> res = jsonDecode(response.body)['results'][0];
    _fullAddress = res['formatted_address'];
  }

  Future<void> _updateCenter(BuildContext context) async {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    var mediaSize = MediaQuery.of(context).size;
    var appbarHeight = Scaffold.of(context).appBarMaxHeight;

    _pointCenter = await _mapController.getLatLng(
      ScreenCoordinate(
        x: (mediaSize.width * pixelRatio / 2).round(),
        y: ((mediaSize.height - appbarHeight) * pixelRatio / 2).round(),
      ),
    );
  }

  GoogleMap googleMap() {
    return GoogleMap(
      markers: _markers,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 12.0,
      ),
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      tiltGesturesEnabled: false,
    );
  }

  String get fullAddress => _fullAddress;
  LatLng get myPosition => _initialPosition;
  Set<Marker> get markers => _markers;
  GlobalKey get addPointKey => _addPointKey;
  bool get isMapLoading => _isMapLoading;
  TradePoint get tradePoint => _tradePoint;
}
