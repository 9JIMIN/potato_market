import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Spot {
  final String id;
  final double lat;
  final double lng;
  final String name;
  final String address;
  final DateTime usedAt;

  Spot({
    this.id,
    this.lat,
    this.lng,
    this.name,
    this.address,
    this.usedAt,
  });

  static Map<String, dynamic> toJson(Spot spot) {
    final Map<String, double> point =
        Geoflutterfire().point(latitude: spot.lat, longitude: spot.lng).data;
    return {
      'id': spot.id,
      'point': point,
      'name': spot.name,
      'address': spot.address,
      'usedAt': spot.usedAt,
    };
  }

  static Spot fromQuery(DocumentSnapshot query) {
    final doc = query.data();
    return Spot(
      id: doc['id'],
      lat: doc['point']['geopoint'].latitude,
      lng: doc['point']['geopoint'].longitude,
      name: doc['name'],
      address: doc['address'],
      usedAt: doc['usedAt'],
    );
  }
}
