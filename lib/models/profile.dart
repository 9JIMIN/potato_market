import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final name;
  final email;
  final imageUrl;
  final categories;
  final sellCount;

  Profile({
    this.name,
    this.email,
    this.imageUrl,
    this.categories,
    this.sellCount,
  });

  static Profile fromQuery(DocumentSnapshot query) {
    final doc = query.data();
    return Profile(
      name: doc['name'],
      email: doc['email'],
      imageUrl: doc['imageUrl'],
      categories: doc['categories'],
      sellCount: doc['sellCount'],
    );
  }
}
