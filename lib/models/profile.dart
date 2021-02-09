import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final uid;
  final name;
  final phoneNumber;
  final imageUrl;

  Profile({
    this.uid,
    this.name,
    this.phoneNumber,
    this.imageUrl,
  });

  static Profile fromQuery(DocumentSnapshot query) {
    final doc = query.data();
    return Profile(
      uid: doc['uid'],
      name: doc['name'],
      phoneNumber: doc['phoneNumber'],
      imageUrl: doc['imageUrl'],
    );
  }
}
