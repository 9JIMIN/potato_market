import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/widget_services.dart';
import '../secrets.dart';

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

  static Future<Map<String, String>> getAddress(LatLng areaCenter) async {
    final path = 'https://maps.googleapis.com/maps/api/geocode/json';
    final lat = areaCenter.latitude;
    final lng = areaCenter.longitude;
    final url = '$path?latlng=$lat,$lng&key=${Secrets.googleAPI}&language=ko';

    final res = await http.get(url);
    final result = jsonDecode(res.body)['results'][0];
    final full = result['formatted_address'];
    final short = result['address_components'][1]['short_name'];
    return {'full': full, 'short': short};
  }
}
