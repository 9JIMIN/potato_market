import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Spot {
  final String id;
  final Map<String, double> point;
  final String name;
  final String address;
  final DateTime usedAt;

  Spot({
    this.id,
    this.point,
    this.name,
    this.address,
    this.usedAt,
  });

  static Map<String, dynamic> toJson(Spot spot) {
    final Map<String, double> point = Geoflutterfire()
        .point(latitude: spot.point['lat'], longitude: spot.point['lng'])
        .data;
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
    final point = doc['point']['geopoint'];
    return Spot(
      id: doc['id'],
      point: {'lat': point.latitude, 'lng': point.longitude},
      name: doc['name'],
      address: doc['address'],
      usedAt: doc['usedAt'],
    );
  }
}
