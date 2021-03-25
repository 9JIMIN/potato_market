import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Spot {
  final lat;
  final lng;
  final name;
  final address;
  final usedAt;

  Spot({
    this.lat,
    this.lng,
    this.name,
    this.address,
    this.usedAt,
  });

  static Map<String, dynamic> toJson(Spot spot) {
    return {
      'point':
          Geoflutterfire().point(latitude: spot.lat, longitude: spot.lng).data,
      'name': spot.name,
      'address': spot.address,
      'usedAt': spot.usedAt,
    };
  }

  static Spot fromQuery(DocumentSnapshot query) {
    final doc = query.data();
    return Spot(
      lat: doc['point']['geopoint'].latitude,
      lng: doc['point']['geopoint'].longitude,
      name: doc['name'],
      address: doc['address'],
      usedAt: doc['usedAt'],
    );
  }
}
