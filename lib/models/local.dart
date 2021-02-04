import 'package:hive/hive.dart';

class Local {
  String uid;
  String name;
  String email;
  String imageUrl;
  String phoneNumber;
  Map<String, dynamic> area;
  Map<String, bool> productCategories;
  Map<String, bool> postCategories;

  Local({
    this.uid,
    this.name,
    this.email,
    this.imageUrl,
    this.phoneNumber,
    this.area,
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
      area: box.get('area'),
      productCategories: box.get('productCategories'),
      postCategories: box.get('postCategories'),
    );
  }
}

// flutter packages pub run build_runner build
