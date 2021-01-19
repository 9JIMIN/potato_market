class Place {
  final name;
  final point;
  final address;
  final userCount;

  Place({
    this.name,
    this.point,
    this.address,
    this.userCount,
  });

  static fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      point: json['point']['geopoint'],
      address: json['address'],
      userCount: json['userCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'point': point,
        'address': address,
        'userCount': userCount,
      };
}
