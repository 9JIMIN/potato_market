import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../models/area.dart';
import '../models/profile.dart';
import '../models/product.dart';
import 'local_services.dart';

import 'dart:developer';

class CloudServices {
  static final CloudServices _singleton = CloudServices._();
  CloudServices._();
  factory CloudServices() => _singleton;

  final _geo = Geoflutterfire();
  final _instance = FirebaseFirestore.instance;

  Future<void> addArea(Area area, String uid) async {
    GeoFirePoint point = _geo.point(
      latitude: area.lat,
      longitude: area.lng,
    );
    await _instance.collection('profile').doc(uid).collection('area').add({
      'name': area.name,
      'point': point.data,
      'radius': area.radius,
      'active': area.active,
    });
  }

  Future<Profile> getProfile(String uid) async {
    final docs = await _instance.collection('profile').doc(uid).get();
    if (docs.exists) {
      return Profile.fromQuery(docs);
    } else {
      return null;
    }
  }

  Future<Area> getActiveArea(String uid) async {
    final query = await _instance
        .collection('profile')
        .doc(uid)
        .collection('area')
        .where('active', isEqualTo: true)
        .get();

    if (query.docs.isNotEmpty) {
      return Area.fromQuery(query.docs.first);
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
    await _instance.collection('product').add(Product.toJson(product));
  }

  Future<List<Product>> getProductList() async {
    final area = LocalServices().area;
    final center = _geo.point(latitude: area.lat, longitude: area.lng);
    final radius = area.radius;

    final list =
        _geo.collection(collectionRef: _instance.collection('product')).within(
              center: center,
              radius: radius,
              field: 'tradePoint.point',
            );
    final a = await list.first;
    final b = a.first.data();
    log(b.toString());
    return null;
  }
}
