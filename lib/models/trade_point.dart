class TradePoint {
  final lat;
  final lng;
  final name;
  final tradeCount;
  final productCount;

  TradePoint({
    this.lat,
    this.lng,
    this.name,
    this.tradeCount = 0,
    this.productCount = 0,
  });

  static Map<String, dynamic> toJson(TradePoint point) {
    return {
      'lat': point.lat,
      'lng': point.lng,
      'name': point.name,
      'tradeCount': point.tradeCount,
      'productCount': point.productCount,
    };
  }
}
