import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../models/area.dart';
import 'local_model.dart';

class FirestoreModel with ChangeNotifier {
  final _instance = FirebaseFirestore.instance;
  final _geo = Geoflutterfire();

  Future<void> updateArea(Area area, String uid) async {
    GeoFirePoint point = _geo.point(
      latitude: area.latitude,
      longitude: area.longitude,
    );
    await _instance.collection('profile').doc(uid).collection('area').add({
      'name': area.name,
      'point': point.data,
      'radius': area.radius,
      'active': area.active,
    });
  }
}
