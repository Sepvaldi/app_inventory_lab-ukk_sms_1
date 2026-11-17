import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_strings.dart';
import '../models/user_model.dart';

class UserService {
  final _col = FirebaseFirestore.instance.collection(AppStrings.colUsers);

  Future<void> createUser(UserModel user) =>
      _col.doc(user.id).set(user.toMap());

  Stream<UserModel?> streamUser(String uid) => _col
      .doc(uid)
      .snapshots()
      .map((d) => d.exists ? UserModel.fromDoc(d) : null);

  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _col.doc(uid).update(data);
}