import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../services/navigation_services.dart';
import '../../../services/location_services.dart';
import '../../../widgets/widget_services.dart';
import '../../../services/local_services.dart';
import '../../../models/spot.dart';
import '../../../secrets.dart';

class SetSpotModel with ChangeNotifier {
  LatLng _initialPosition;
  GoogleMapController _mapController;
  String _fullAddress;
  LatLng _pointCenter;
  bool _isButtonVisible = true;
  GlobalKey _nameFormKey = GlobalKey();
  TextEditingController _nameFieldController = TextEditingController();

  Future<void> onMapFutureBuild(BuildContext context) async {
    final lat = LocalServices().spot.lat;
    final lng = LocalServices().spot.lng;
    if (lat == null && lng == null) {
      _initialPosition = await LocationServices.getMyPosition(context);
    } else {
      _initialPosition = LatLng(lat, lng);
    }
  }

  Future<void> onNameFutureBuild() async {
    _nameFieldController.text = '';
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
      final newSpot = Spot(
        lat: _pointCenter.latitude,
        lng: _pointCenter.longitude,
        name: name,
        address: _fullAddress,
      );
      LocalServices().updateSpot(newSpot);
      // TODO: 에디터 notifyListener(거래장소 업데이트)
      Navigator.of(_nameFormKey.currentContext).pop();
      dispose();
      Navigator.of(_nameFormKey.currentContext).pop(newSpot);
    }
  }

  // 카메라 관련
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
