import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import '../../../models/area.dart';
import '../../../models/profile.dart';
import '../../../models/item.dart';
import '../../../models/spot.dart';
import '../local/local_storage_service.dart';

import 'dart:developer';

class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._();
  DatabaseService._();
  factory DatabaseService() => _singleton;

  final _geo = Geoflutterfire();
  final _instance = FirebaseFirestore.instance;

  // Profile
  Future<void> createUser(Profile profile) async {
    await _instance
        .collection('profile')
        .doc(profile.uid)
        .set(Profile.toJson(profile));
  }

  Future<Profile> getProfile(String uid) async {
    final docs = await _instance.collection('profile').doc(uid).get();
    if (docs.exists) {
      return Profile.fromQuery(docs);
    } else {
      return null;
    }
  }

  // Area
  Future<List<Area>> getAreaList(String uid) async {
    final query =
        await _instance.collection('profile').doc(uid).collection('area').get();

    if (query.docs.isNotEmpty) {
      final areaList = query.docs.map((e) => Area.fromQuery(e)).toList();
      return areaList;
    } else {
      return null;
    }
  }

  Future<void> changeCurrentArea(Area newArea) async {
    final profileId = LocalStorageService().profile.uid;
    final activeAreaId = LocalStorageService().area.id;

    await _instance
        .collection('profile')
        .doc(profileId)
        .collection('area')
        .doc(activeAreaId)
        .update({'active': false});

    await _instance
        .collection('profile')
        .doc(profileId)
        .collection('area')
        .doc(newArea.id)
        .update({'active': true});
  }

  Future<void> addArea(Area area) async {
    final profileId = LocalStorageService().profile.uid;
    final newAreaId = _instance
        .collection('profile')
        .doc(profileId)
        .collection('area')
        .doc()
        .id;
    GeoFirePoint point = _geo.point(
      latitude: area.lat,
      longitude: area.lng,
    );

    await _instance
        .collection('profile')
        .doc(profileId)
        .collection('area')
        .add({
      'id': newAreaId,
      'name': area.name,
      'point': point.data,
      'radius': area.radius,
      'active': area.active,
    });
  }

  Future<Area> getActiveArea() async {
    final profileId = LocalStorageService().profile.uid;
    final query = await _instance
        .collection('profile')
        .doc(profileId)
        .collection('area')
        .where('active', isEqualTo: true)
        .get();

    if (query.docs.isNotEmpty) {
      return Area.fromQuery(query.docs.first);
    } else {
      return null;
    }
  }

  // Spot
  Future<void> addSpot(Spot spot, String uid) async {
    GeoFirePoint point = _geo.point(latitude: spot.lat, longitude: spot.lng);
    await _instance.collection('profile').doc(uid).collection('spot').add({
      'name': spot.name,
      'address': spot.address,
      'usedAt': spot.usedAt,
      'point': point.data,
    });
  }

  Future<Spot> getRecentSpot(String uid) async {
    final query = await _instance
        .collection('profile')
        .doc(uid)
        .collection('spot')
        .orderBy('usedAt')
        .get();

    if (query.docs.isNotEmpty) {
      return Spot.fromQuery(query.docs.first);
    } else {
      return null;
    }
  }

  // Item
  Future<void> createProduct(Item item) async {
    await _instance.collection('item').add(Item.toJson(item));
  }

  Future<List<Item>> getProductList() async {
    final area = LocalStorageService().area;
    final center = _geo.point(latitude: area.lat, longitude: area.lng);
    final radius = area.radius;

    final list =
        _geo.collection(collectionRef: _instance.collection('item')).within(
              center: center,
              radius: radius,
              field: 'spot.point',
            );
    return null;
  }
}
