import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Product {
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
  final Map<String, dynamic> tradePoint;

  Product({
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
    this.tradePoint,
  });

  // fromQuery
  static List<Product> fromQuery(QuerySnapshot query) {
    return query.docs.map((docsSnapshot) {
      final doc = docsSnapshot.data();
      return Product(
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
        tradePoint: doc['tradePoint'],
      );
    }).toList();
  }

  static Map<String, dynamic> toJson(Product product) {
    return {
      'title': product.title,
      'category': product.category,
      'price': product.price,
      'description': product.description,
      'imageUrls': product.imageUrls,
      'likeCount': product.likeCount,
      'chatCount': product.chatCount,
      'sellerId': product.sellerId,
      'createdAt': product.createdAt,
      'status': product.status,
      'tradePoint': product.tradePoint,
    };
  }
}
