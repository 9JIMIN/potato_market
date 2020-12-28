import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:potato_market/screens/auth/area/area_view.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'local_provider.dart';
import '../screens/auth/start/start_view.dart';
import '../screens/auth/base/base_screen.dart';

/*
splash 
- @ String splashImage
- @ afterSplash()

start 
- @ toArea()

area
- List areaList, 
- getPosition(), fetchMyCoords(), searchByText(text), searchByGPS(), onAreaTileTap()
- 좌표의 동네를 가져옴. 그리고 

login
- String phoneNumber, int certNumber, String name, String email
- sendCertNumber(phoneNumber), verifyCertNumber(certNumber), login(), register()
- 기타 veridation함수, focus함수...

shared
- Local local
- fetchLocal(), updateLocal(), deleteLocal()

base
- List appbar, List body, List floatingButton, List bottomItem, int selectedIndex
- checkLocalData(), onBottomTap(index), onFloatingPressed(index)
*/

class AuthProvider with ChangeNotifier {
  AuthProvider() {
    fetchMyCoords();
    log('AuthProvider - init');
  }

  // ######## splash, start
  final splashImage = 'assets/splash_image.jpg';

  Future<Widget> afterSplash(BuildContext context) async {
    log('AuthProvider - afterSplash()');
    await Future.delayed(Duration(seconds: 1));
    final localmodel = context.read<LocalProvider>();
    if (localmodel.local.area == null) {
      return StartView();
    } else {
      return BaseScreen();
    }
  }

  void toArea(BuildContext context) {
    log('AuthProvider - toArea()');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AreaView()),
    );
  }

  // ######## area
  LatLng myCoords;
  var inputArea;
  var areaList;
  Completer<GoogleMapController> _controller = Completer();

  Future<void> fetchMyCoords() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    var myPosition = await Geolocator.getCurrentPosition();
    myCoords = LatLng(myPosition.latitude, myPosition.longitude);
    log('fetchMyCoords() ' + myCoords.toString());
  }

  GoogleMap googleMap() {
    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(target: myCoords, zoom: 15),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<void> centerMap() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: myCoords,
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> fetchAreaListByInputText() async {}

  void onAreaTap() {
    // Local 데이터 업데이트
  }
}
