import 'package:cloud_firestore/cloud_firestore.dart';

/// Status progression: pending → accepted / rejected → completed.
enum BarterStatus { pending, accepted, rejected, completed }

class Barter {
  final String id;
  final String itemId;
  final String offerItemId; // item offered in exchange (empty if cash offer)
  final String requesterId; // user who initiated the barter
  final String ownerId; // item owner
  final String message; // optional note from requester
  final BarterStatus status;
  final DateTime createdAt;

  const Barter({
    required this.id,
    required this.itemId,
    required this.offerItemId,
    required this.requesterId,
    required this.ownerId,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'itemId': itemId,
        'offerItemId': offerItemId,
        'requesterId': requesterId,
        'ownerId': ownerId,
        'message': message,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory Barter.fromMap(Map<String, dynamic> map) => Barter(
        id: map['id'] as String,
        itemId: map['itemId'] as String,
        offerItemId: map['offerItemId'] as String,
        requesterId: map['requesterId'] as String,
        ownerId: map['ownerId'] as String,
        message: map['message'] as String,
        status: BarterStatus.values.byName(map['status'] as String),
        createdAt: (map['createdAt'] as Timestamp).toDate(),
      );

  Barter copyWith({
    String? id,
    String? itemId,
    String? offerItemId,
    String? requesterId,
    String? ownerId,
    String? message,
    BarterStatus? status,
    DateTime? createdAt,
  }) =>
      Barter(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        offerItemId: offerItemId ?? this.offerItemId,
        requesterId: requesterId ?? this.requesterId,
        ownerId: ownerId ?? this.ownerId,
        message: message ?? this.message,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
}
