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
  final String status;
  final Timestamp createdAt;

  Product({
    this.title,
    this.category,
    this.price,
    this.description,
    this.imageUrls,
    this.chatCount = 0,
    this.createdAt,
    this.likeCount = 0,
    this.sellerId,
    this.status = '판매중',
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
        chatCount: doc['chatCount'],
        createdAt: doc['createdAt'],
        likeCount: doc['likeCount'],
        sellerId: doc['sellerId'],
        status: doc['status'],
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
      'chatCount': product.chatCount,
      'likeCount': product.likeCount,
      'sellerId': product.sellerId,
      'status': product.status,
    };
  }
}
