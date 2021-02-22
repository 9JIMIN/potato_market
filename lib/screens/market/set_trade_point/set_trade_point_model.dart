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
import 'package:provider/provider.dart';
import '../product_editor/product_editor_model.dart';

class SetTradePointModel with ChangeNotifier {
  LatLng _initialPosition;
  GoogleMapController _mapController;
  String _fullAddress;
  LatLng _pointCenter;
  bool _isButtonVisible = true;
  GlobalKey _nameFormKey = GlobalKey();
  TextEditingController _nameFieldController = TextEditingController();

  Future<void> onMapFutureBuild(BuildContext context) async {
    // 이것도 별 의미없는 거 같다.
    // 나중에 없애기
    final lat = LocalServices().tradePoint.lat;
    final lng = LocalServices().tradePoint.lng;
    if (lat == null && lng == null) {
      _initialPosition = await LocationServices.getMyPosition(context);
    } else {
      _initialPosition = LatLng(lat, lng);
    }
  }

  Future<void> onNameFutureBuild() async {
    await _updateAddress();
  }

  // 등록버튼 클릭시
  void onPointButtonPressed(BuildContext context) async {
    await _updateCenter(context);
    NavigationServices.toSetPointName(context);
  }

  // 위치저장버튼 클릭시
  void onNameSaved() {
    final name = _nameFieldController.text;
    if (name == '') {
      WidgetServices.showSnack(_nameFormKey.currentContext, '장소의 이름을 입력해주세요');
    } else {
      final newTradePoint = TradePoint(
        lat: _pointCenter.latitude,
        lng: _pointCenter.longitude,
        name: name,
      );
      LocalServices().updateTradePoint(newTradePoint);
      // TODO: 에디터 notifyListener(거래장소 업데이트)
      Navigator.of(_nameFormKey.currentContext).pop();
      Navigator.of(_nameFormKey.currentContext).pop();
    }
  }

  void onCameraMoved() {
    if (_isButtonVisible) {
      _isButtonVisible = false;
      notifyListeners();
    }
  }

  void onCameraIdle() {
    if (!_isButtonVisible) {
      _isButtonVisible = true;
      notifyListeners();
    }
  }

  // Helper methods
  /////////////////
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

  String get fullAddress => _fullAddress;
  LatLng get initialPosition => _initialPosition;
  set setMapController(controller) => _mapController = controller;
  bool get isButtonVisible => _isButtonVisible;
  GlobalKey get nameFormKey => _nameFormKey;
  TextEditingController get nameFieldController => _nameFieldController;
}
