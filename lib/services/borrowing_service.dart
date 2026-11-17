import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_strings.dart';
import '../models/borrowing_model.dart';

class BorrowingService {
  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      FirebaseFirestore.instance
          .collection(AppStrings.colUsers)
          .doc(uid)
          .collection(AppStrings.colBorrowings);

  Stream<List<BorrowingModel>> streamBorrowings(String uid) => _col(uid)
      .orderBy('borrow_date', descending: true)
      .snapshots()
      .map((s) => s.docs.map(BorrowingModel.fromDoc).toList());

  Future<void> addBorrowing(
    String uid, {
    required String itemId,
    required String itemName,
  }) async {
    final doc = _col(uid).doc();
    await doc.set(
      BorrowingModel(id: doc.id, itemId: itemId, itemName: itemName).toMap(),
    );
  }

  Future<void> borrowItem(
    String uid, {
    required String itemId,
    required String itemName,
  }) async {
    final db = FirebaseFirestore.instance;
    final borrowRef = _col(uid).doc();
    final itemRef = db.collection(AppStrings.colItems).doc(itemId);

    final batch = db.batch();
    batch.set(
      borrowRef,
      BorrowingModel(
        id: borrowRef.id,
        itemId: itemId,
        itemName: itemName,
      ).toMap(),
    );
    batch.update(itemRef, {'status': AppStrings.borrowed});
    await batch.commit();
  }

  Future<void> deleteBorrowing(String uid, String borrowId) =>
      _col(uid).doc(borrowId).delete();
}
