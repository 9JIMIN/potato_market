import 'package:geoflutterfire/geoflutterfire.dart';

class TradePoint {
  final lat;
  final lng;
  final name;

  TradePoint({
    this.lat,
    this.lng,
    this.name,
  });

  static Map<String, dynamic> toJson(TradePoint point) {
    return {
      'point': Geoflutterfire()
          .point(latitude: point.lat, longitude: point.lng)
          .data,
      'name': point.name,
    };
  }
}
