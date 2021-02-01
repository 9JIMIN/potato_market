import 'package:hive/hive.dart';

part 'local.g.dart';

@HiveType(typeId: 1)
class Local {
  @HiveField(0)
  String uid;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String imageUrl;
  @HiveField(4)
  String phoneNumber;
  @HiveField(5)
  Map<String, dynamic> place; // {'area1': '가좌동', 'range1': 1, 'area2': ...}
  @HiveField(6)
  Map<String, bool> productCategories;
  @HiveField(7)
  Map<String, bool> postCategories;

  Local({
    this.uid,
    this.name,
    this.email,
    this.imageUrl,
    this.phoneNumber,
    this.place,
    this.productCategories,
    this.postCategories,
  });

  static Local fromBox(Box box) {
    return Local(
      uid: box.get('uid'),
      name: box.get('name'),
      email: box.get('email'),
      imageUrl: box.get('imageUrl'),
      phoneNumber: box.get('phoneNumber'),
      place: box.get('place'),
      productCategories: box.get('productCategories'),
      postCategories: box.get('postCategories'),
    );
  }
}

// flutter packages pub run build_runner build
