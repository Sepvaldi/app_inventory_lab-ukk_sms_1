import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_strings.dart';
import '../models/item_model.dart';

class ItemService {
  final _col = FirebaseFirestore.instance.collection(AppStrings.colItems);

  // Real-time
  Stream<List<ItemModel>> streamItems() => _col
      .orderBy('created_at', descending: true)
      .snapshots()
      .map((s) => s.docs.map(ItemModel.fromDoc).toList());

  Stream<ItemModel?> streamItem(String id) => _col
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? ItemModel.fromDoc(d) : null);

  // CRUD
  Future<void> addItem(ItemModel item) async {
    final doc = _col.doc();
    await doc.set(
      ItemModel(
        id: doc.id,
        name: item.name,
        category: item.category,
        code: item.code,
        status: item.status,
        image: item.image,
        spesification: item.spesification,
      ).toMap(),
    );
  }

  Future<void> updateItem(ItemModel item) =>
      _col.doc(item.id).update(item.toMap()..remove('created_at'));

  Future<void> deleteItem(String id) => _col.doc(id).delete();

  Future<void> seedIfEmpty() async {
    final snap = await _col.limit(1).get();
    if (snap.docs.isNotEmpty) return;

    const data = [
      [
        'Mikroskop Binokuler',
        'Optik',
        'LAB-001',
        'Available',
        'mikroskop',
        'Pembesaran 40x-1000x',
      ],
      [
        'Multimeter Digital',
        'Elektronik',
        'LAB-002',
        'Borrowed',
        'multimeter',
        'Auto-range, 600V',
      ],
      [
        'Laptop Praktikum',
        'Komputer',
        'LAB-003',
        'Available',
        'laptop',
        'Core i5, RAM 8GB',
      ],
      [
        'Osiloskop',
        'Elektronik',
        'LAB-004',
        'Available',
        'osiloskop',
        '2 channel, 100MHz',
      ],
      [
        'Gelas Ukur 500ml',
        'Kimia',
        'LAB-005',
        'Borrowed',
        'gelas',
        'Borosilikat',
      ],
      [
        'Teleskop Bintang',
        'Optik',
        'LAB-006',
        'Available',
        'teleskop',
        'Diameter 70mm',
      ],
    ];
    final batch = FirebaseFirestore.instance.batch();
    for (final d in data) {
      final doc = _col.doc();
      batch.set(doc, {
        'item_id': doc.id,
        'item_name': d[0],
        'category': d[1],
        'code': d[2],
        'status': d[3],
        'image': d[4],
        'spesification': d[5],
        'created_at': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
