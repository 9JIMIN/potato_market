import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'widget_services.dart';

class LocationServices {
  static Future<LatLng> getMyPosition(context) async {
    var permission = await Geolocator.checkPermission();
    var count = 0;
    while (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (count > 0) {
        await WidgetServices.showLocationAlertDialog(context);
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else {
        await WidgetServices.showAppSettingDialog(context);
        permission = await Geolocator.checkPermission();
      }

      count++;
    }

    final myPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );
    return LatLng(myPosition.latitude, myPosition.longitude);
  }
}
