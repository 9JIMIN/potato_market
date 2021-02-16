import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'widget_services.dart';

class LocationServices {
  static Future<LatLng> getMyPosition(context) async {
    var permission = await Geolocator.checkPermission();
    var isFirst = true;
    var isForever = false;
    while (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!isFirst) {
        await WidgetServices.showLocationAlertDialog(context);
      }
      if (isForever) {
        permission = await Geolocator.checkPermission();
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        await WidgetServices.showAppSettingDialog(context);
        isForever = true;
      } else {
        continue;
      }

      isFirst = false;
    }

    final myPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );
    return LatLng(myPosition.latitude, myPosition.longitude);
  }
}
