import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String title;
  final String description;
  final double price;
  final String condition;
  final String imageUrl;
  final String sellerId;
  final DateTime timestamp;

  const Item({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.condition,
    required this.imageUrl,
    required this.sellerId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'condition': condition,
        'imageUrl': imageUrl,
        'sellerId': sellerId,
        'timestamp': Timestamp.fromDate(timestamp),
      };

  factory Item.fromMap(Map<String, dynamic> map) => Item(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        price: (map['price'] as num).toDouble(),
        condition: map['condition'] as String,
        imageUrl: map['imageUrl'] as String,
        sellerId: map['sellerId'] as String,
        timestamp: (map['timestamp'] as Timestamp).toDate(),
      );

  Item copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? condition,
    String? imageUrl,
    String? sellerId,
    DateTime? timestamp,
  }) =>
      Item(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        condition: condition ?? this.condition,
        imageUrl: imageUrl ?? this.imageUrl,
        sellerId: sellerId ?? this.sellerId,
        timestamp: timestamp ?? this.timestamp,
      );
}
