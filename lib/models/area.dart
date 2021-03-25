import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  final lat;
  final lng;
  final radius;
  final name;
  final active;

  Area({
    this.lat,
    this.lng,
    this.radius,
    this.name,
    this.active = true,
  });

  static Area fromQuery(DocumentSnapshot query) {
    final doc = query.data();
    return Area(
      lat: doc['point']['geopoint'].latitude,
      lng: doc['point']['geopoint'].longitude,
      radius: doc['radius'],
      name: doc['name'],
      active: doc['active'],
    );
  }
}
