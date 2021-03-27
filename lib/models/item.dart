import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Item {
  final String title;
  final String category;
  final int price;
  final String description;
  final List<dynamic> imageUrls;
  final int likeCount;
  final int chatCount;
  final String sellerId;
  final Timestamp createdAt;
  final String status;
  final Map<String, dynamic> spot;

  Item({
    this.title,
    this.category,
    this.price,
    this.description,
    this.imageUrls,
    this.likeCount = 0,
    this.chatCount = 0,
    this.sellerId,
    this.createdAt,
    this.status = '판매중',
    this.spot,
  });

  // fromQuery
  static List<Item> fromQuery(QuerySnapshot query) {
    return query.docs.map((docsSnapshot) {
      final doc = docsSnapshot.data();
      return Item(
        title: doc['title'],
        category: doc['category'],
        price: doc['price'],
        description: doc['description'],
        imageUrls: doc['imageUrls'],
        likeCount: doc['likeCount'],
        chatCount: doc['chatCount'],
        sellerId: doc['sellerId'],
        createdAt: doc['createdAt'],
        status: doc['status'],
        spot: doc['Spot'],
      );
    }).toList();
  }

  static Map<String, dynamic> toJson(Item item) {
    return {
      'title': item.title,
      'category': item.category,
      'price': item.price,
      'description': item.description,
      'imageUrls': item.imageUrls,
      'likeCount': item.likeCount,
      'chatCount': item.chatCount,
      'sellerId': item.sellerId,
      'createdAt': item.createdAt,
      'status': item.status,
      'Spot': item.spot,
    };
  }
}
