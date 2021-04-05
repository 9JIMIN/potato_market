import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  final String id;
  final double lat;
  final double lng;
  final double radius;
  final String name;
  final bool active;

  Area({
    this.id,
    this.lat,
    this.lng,
    this.radius,
    this.name,
    this.active = true,
  });

  static Area fromQuery(DocumentSnapshot query) {
    final doc = query.data();
    return Area(
      id: doc['id'],
      lat: doc['point']['geopoint'].latitude,
      lng: doc['point']['geopoint'].longitude,
      radius: doc['radius'],
      name: doc['name'],
      active: doc['active'],
    );
  }
}
