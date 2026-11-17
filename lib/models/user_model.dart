import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id, name, email, kelas, foto;
  final Timestamp? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.kelas,
    this.foto = '',
    this.createdAt,
  });

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return UserModel(
      id: doc.id,
      name: d['name'] ?? '',
      email: d['email'] ?? '',
      kelas: d['kelas'] ?? '',
      foto: d['foto'] ?? '',
      createdAt: d['created_at'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {
        'user_id': id,
        'name': name,
        'email': email,
        'kelas': kelas,
        'created_at': FieldValue.serverTimestamp(),
        'foto': foto,
      };
}