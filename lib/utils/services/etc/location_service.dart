import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../config/constants/api_key.dart';
import '../../ui/widgets/show_dialog.dart';

class LocationService {
  static Future<LatLng> getMyPosition(context) async {
    var permission = await Geolocator.checkPermission();
    var isFirst = true;
    var isForever = false;
    while (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!isFirst) {
        ShowDialog.locationAlert(context);
      }
      if (isForever) {
        permission = await Geolocator.checkPermission();
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        ShowDialog.appSetting(context);
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
    final url = '$path?latlng=$lat,$lng&key=${APIKey.googleAPI}&language=ko';

    final res = await http.get(url);
    final result = jsonDecode(res.body)['results'][0];
    final full = result['formatted_address'];
    final short = result['address_components'][1]['short_name'];
    return {'full': full, 'short': short};
  }
}
