import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowingModel {
  final String id, itemId, itemName;
  final Timestamp? borrowDate;

  const BorrowingModel({
    required this.id,
    required this.itemId,
    required this.itemName,
    this.borrowDate,
  });

  factory BorrowingModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return BorrowingModel(
      id: doc.id,
      itemId: d['item_id'] ?? '',
      itemName: d['item_name'] ?? '',
      borrowDate: d['borrow_date'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {
        'borrow_id': id,
        'item_id': itemId,
        'item_name': itemName,
        'borrow_date': borrowDate ?? FieldValue.serverTimestamp(),
      };
}