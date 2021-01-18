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

  Map<String, dynamic> toJson() => {
        'name': name,
        'point': point,
        'address': address,
        'userCount': userCount,
      };
}
