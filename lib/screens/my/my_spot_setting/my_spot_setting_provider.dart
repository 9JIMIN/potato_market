import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:potato_market/utils/ui/widgets/show_snackbar.dart';

import '../../../models/spot.dart';
import '../../../utils/services/etc/navigation_service.dart';
import '../../../utils/services/etc/location_service.dart';
import '../../../utils/ui/widgets/show_dialog.dart';
import '../../../utils/services/local/local_storage_service.dart';
import '../../../config/constants/api_key.dart';

class MySpotSettingProvider with ChangeNotifier {
  LatLng _initialPosition;
  GoogleMapController _mapController;
  String _fullAddress;
  LatLng _pointCenter;
  bool _isButtonVisible = true;
  GlobalKey _nameFormKey = GlobalKey();
  TextEditingController _nameFieldController = TextEditingController();

  Future<void> onMapFutureBuild(BuildContext context) async {
    final lat = LocalStorageService().spot.lat;
    final lng = LocalStorageService().spot.lng;
    if (lat == null && lng == null) {
      _initialPosition = await LocationService.getMyPosition(context);
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
    NavigationService.toMySpotSettingName(context);
  }

  // 위치저장버튼 클릭시
  void onNameSaved() {
    final name = _nameFieldController.text;
    if (name == '') {
      ShowSnackbar.snack(_nameFormKey.currentContext, '장소의 이름을 입력해주세요');
    } else {
      final newSpot = Spot(
        lat: _pointCenter.latitude,
        lng: _pointCenter.longitude,
        name: name,
        address: _fullAddress,
      );
      LocalStorageService().updateSpot(newSpot);
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
        '$url?latlng=$lat,$lng&key=${APIKey.googleAPI}&language=ko';

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
