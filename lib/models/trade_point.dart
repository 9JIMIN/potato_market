import 'package:geoflutterfire/geoflutterfire.dart';

class TradePoint {
  final GeoFirePoint point;
  final String name;
  final int tradeCount;

  TradePoint({
    this.point,
    this.name,
    this.tradeCount = 0,
  });

  static Map<String, dynamic> toJson(TradePoint tradePoint) {
    return {
      'point': tradePoint.point,
      'name': tradePoint.name,
      'tradeCount': tradePoint.tradeCount,
    };
  }
}
