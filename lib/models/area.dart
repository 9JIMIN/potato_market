import 'package:cloud_firestore/cloud_firestore.dart';

class Area {
  final String id;
  final Map<String, double> point;
  final String name;
  final double radius;
  final bool active;

  Area({
    this.id,
    this.point,
    this.name,
    this.radius,
    this.active = true,
  });

  static Area fromQuery(DocumentSnapshot query) {
    final doc = query.data();
    final point = doc['point']['geopoint'];
    return Area(
      id: doc['id'],
      point: {'lat': point.latitude, 'lng': point.longitude},
      name: doc['name'],
      radius: doc['radius'],
      active: doc['active'],
    );
  }
}
