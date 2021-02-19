import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../models/area.dart';
import '../models/profile.dart';
import '../models/product.dart';

class CloudServices {
  static final CloudServices _singleton = CloudServices._();
  CloudServices._();
  factory CloudServices() => _singleton;

  final _geo = Geoflutterfire();
  final _instance = FirebaseFirestore.instance;

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

  Future<Profile> getProfile(String uid) async {
    var docs = await _instance.collection('profile').doc(uid).get();
    if (docs.exists) {
      return Profile.fromQuery(docs);
    } else {
      return null;
    }
  }

  Future<void> createUser(Profile profile) async {
    await _instance
        .collection('profile')
        .doc(profile.uid)
        .set(Profile.toJson(profile));
  }

  Future<void> createProduct(Product product) async {
    await _instance.collection('products').add(Product.toJson(product));
  }
}
