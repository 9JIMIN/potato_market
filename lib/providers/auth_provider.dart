import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
- getMyCoords, searchByText(text), searchByGPS(), onAreaTileTap()

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
    log('AuthProvider - init');
  }

  // properties
  final splashImage = 'assets/splash_image.jpg';
  var myCoords;

  // methods
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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> fetchMyCoords() async {
    myCoords = await determinePosition();
    log(myCoords.toString());
  }
}
