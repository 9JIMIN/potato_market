import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Product {
  final title;
  final category;
  final price;
  final description;
  final imageUrls;
  final likeCount;
  final chatCount;
  final sellerId;
  final status;
  final createdAt;

  Product({
    this.title,
    this.category,
    this.price,
    this.description,
    this.imageUrls,
    this.chatCount,
    this.createdAt,
    this.likeCount,
    this.sellerId,
    this.status,
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
}
