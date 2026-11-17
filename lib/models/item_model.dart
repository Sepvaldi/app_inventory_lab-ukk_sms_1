import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id, name, category, code, status, image, spesification;
  final Timestamp? createdAt;

  const ItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.code,
    required this.status,
    required this.image,
    required this.spesification,
    this.createdAt,
  });

  factory ItemModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return ItemModel(
      id: doc.id,
      name: d['item_name'] ?? '',
      category: d['category'] ?? '',
      code: d['code'] ?? '',
      status: d['status'] ?? 'Available',
      image: d['image'] ?? '',
      spesification: d['spesification'] ?? '',
      createdAt: d['created_at'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {
        'item_id': id,
        'item_name': name,
        'category': category,
        'code': code,
        'status': status,
        'image': image,
        'spesification': spesification,
        'created_at': createdAt ?? FieldValue.serverTimestamp(),
      };
}