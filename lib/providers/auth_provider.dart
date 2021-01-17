import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potato_market/screens/auth/new_place_name/new_place_name_view.dart';
import 'package:potato_market/secrets.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'local_provider.dart';
import '../models/place.dart';
import '../screens/auth/place/place_view.dart';
import '../screens/auth/start/start_view.dart';
import '../screens/auth/base/base_screen.dart';
import '../screens/auth/new_place_target/new_place_target_view.dart';
import '../secrets.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider() {
    fetchGPSCoords();
  }

  // Splash
  final _splashImage = 'assets/splash_image.jpg';
  String get splashImage => _splashImage;

  Future<Widget> afterSplash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    if (context.read<LocalProvider>().local.area == null) {
      return StartView();
    } else {
      return BaseScreen();
    }
  }

  // Start
  final _startImage = 'assets/start_image.jpg';
  String get startImage => _startImage;

  void toPlace(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PlaceView()),
    );
  }

  // Place
  LatLng _myGPSCoords;
  GoogleMapController _mapController;
  Place _selectedPlace;
  var _placeMarkers = Set<Marker>();
  var _isPlaceWidgetVisible = false;
  final _initalCameraZoom = 15.0;

  LatLng get myGPSCoords => _myGPSCoords;
  GoogleMapController get mapController => _mapController;
  Place get selectedPlace => _selectedPlace;
  Set<Marker> get placeMarkers => _placeMarkers;
  bool get isPlaceWidgetVisible => _isPlaceWidgetVisible;
  double get initalCameraZoom => _initalCameraZoom;

  Future<void> fetchGPSCoords() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    var myPosition = await Geolocator.getCurrentPosition();
    _myGPSCoords = LatLng(myPosition.latitude, myPosition.longitude);
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void hidePlaceWidget() {
    if (_isPlaceWidgetVisible) {
      _isPlaceWidgetVisible = false;
      notifyListeners();
    }
  }

  void toNewPlaceTarget(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPlaceTarget(),
      ),
    );
  }

  // NewPlaceTarget
  LatLng newPlaceCoords;
  bool _isRegisterButtonVisible = true;
  GoogleMapController _newPlaceMapController;
  var _newPlaceMarkers = Set<Marker>();

  bool get isRegisterButtonVisible => _isRegisterButtonVisible;
  GoogleMapController get newPlaceMapController => _newPlaceMapController;
  Set<Marker> get newPlaceMarkers => _newPlaceMarkers;

  void setNewPlaceController(GoogleMapController controller) {
    _newPlaceMapController = controller;
  }

  void hideRegisterButton() {
    _isRegisterButtonVisible = false;
    notifyListeners();
  }

  void showRegisterButton() {
    _isRegisterButtonVisible = true;
    notifyListeners();
  }

  void registerNewPlace(BuildContext context) async {
    var pixelRatio = MediaQuery.of(context).devicePixelRatio;
    var mediaSize = MediaQuery.of(context).size;
    var _centerHeight = (mediaSize.height * pixelRatio / 2).round();
    var _centerWidth = (mediaSize.width * pixelRatio / 2).round();
    newPlaceCoords = await newPlaceMapController.getLatLng(
      ScreenCoordinate(
        x: _centerWidth,
        y: _centerHeight,
      ),
    );
    _newPlaceMarkers = Set<Marker>();
    _newPlaceMarkers.add(
      Marker(
        markerId: MarkerId("1"),
        position: newPlaceCoords,
      ),
    );
    notifyListeners();
    _toNewPlaceName(context);
  }

  void _toNewPlaceName(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPlaceName(),
      ),
    );
  }

  // NewPlaceName
  String _newPlaceName;
  String _newPlaceAddress;

  String get newPlaceAddress => _newPlaceAddress;

  Future<void> _changeToAddress(LatLng point) async {
    // HTTP 요청 보내기
    // JSON 에서 주소 정보 가져오기
    var url = 'https://maps.googleapis.com/maps/api/geocode/json';
    var lat = newPlaceCoords.latitude;
    var lng = newPlaceCoords.longitude;
    var requestUrl = '$url?latlng=$lat,$lng&key=${Secrets.googleAPI}';

    var response = await http.get(requestUrl);
    log(response.toString());
  }

  Future<void> _createNewPlace(Place newPlace) {}

  void onSave(String string) async {
    await _changeToAddress(newPlaceCoords);
  }

  void _toSetPlaceRange(BuildContext context) {}
}
