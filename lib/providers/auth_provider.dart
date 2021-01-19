import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potato_market/screens/auth/new_place_name/new_place_name_view.dart';
import 'package:potato_market/screens/auth/set_place_range/set_place_range_view.dart';
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
  // 공용
  final firestore = FirebaseFirestore.instance;
  final geo = Geoflutterfire();

  // Splash
  final _splashImage = 'assets/splash_image.jpg';
  String get splashImage => _splashImage;

  Future<Widget> afterSplash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    await fetchGPSCoords();
    log(_myGPSCoords.latitude.toString());
    await updateMarkers();
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

  Future<void> updateMarkers() async {
    //
    var collectionRef = firestore.collection('places');

    var placeStream = geo.collection(collectionRef: collectionRef).within(
        center: geo.point(
          latitude: _myGPSCoords.latitude,
          longitude: _myGPSCoords.longitude,
        ),
        radius: 50,
        field: 'point');

    placeStream.listen((List<DocumentSnapshot> documentList) {
      documentList.forEach((document) {
        final Place place = Place.fromJson(document.data());
        final GeoPoint point = place.point;
        _placeMarkers.add(
          Marker(
            markerId: MarkerId(DateTime.now().toString()),
            position: LatLng(point.latitude, point.longitude),
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              _selectedPlace = place;
              showPlaceWidget();
            },
          ),
        );
        notifyListeners();
      });
    });
  }

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

  void showPlaceWidget() {
    _isPlaceWidgetVisible = true;
    notifyListeners();
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
  LatLng _newPlaceCoords;
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
    _newPlaceCoords = await newPlaceMapController.getLatLng(
      ScreenCoordinate(
        x: _centerWidth,
        y: _centerHeight,
      ),
    );
    _newPlaceMarkers = Set<Marker>();
    _newPlaceMarkers.add(
      Marker(
        markerId: MarkerId("1"),
        position: _newPlaceCoords,
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
  var _isNewPlaceNameLoading = false;
  bool get isNewPlaceNameLoading => _isNewPlaceNameLoading;

  Future<String> _coordsToAddress(LatLng point) async {
    var url = 'https://maps.googleapis.com/maps/api/geocode/json';
    var lat = _newPlaceCoords.latitude;
    var lng = _newPlaceCoords.longitude;
    var lang = 'ko'; // 나중에 옵션으로 바꾸기
    var requestUrl =
        '$url?latlng=$lat,$lng&key=${Secrets.googleAPI}&language=$lang';

    var response = await http.get(requestUrl);
    Map<String, dynamic> res = jsonDecode(response.body);
    return res['results'][0]['formatted_address'].toString();
  }

  GeoFirePoint _coordsToGeoPoint(LatLng point) {
    return geo.point(
      latitude: point.latitude,
      longitude: point.longitude,
    );
  }

  Future<void> _createNewPlace(Place newPlace) async {
    await firestore.collection('places').add(newPlace.toJson());
  }

  void toSetPlaceRange(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SetPlaceRange(),
      ),
    );
  }

  Future<void> onSave(String newPlaceName, BuildContext context) async {
    _isNewPlaceNameLoading = true;
    notifyListeners();

    var newPlaceAddress = await _coordsToAddress(_newPlaceCoords);
    var newPlacePosition = _coordsToGeoPoint(_newPlaceCoords).data;
    var newPlace = Place(
      address: newPlaceAddress,
      name: newPlaceName,
      point: newPlacePosition,
      userCount: 0,
    );
    await _createNewPlace(newPlace);
    _isNewPlaceNameLoading = false;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    toSetPlaceRange(context);
  }

  // SetPlaceRange
  int placeRange;
  int placeCount;
  int userCount;
  int tradeCount;
}
