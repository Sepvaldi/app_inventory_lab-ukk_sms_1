import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/borrowing_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/borrowing_service.dart';
import '../../services/user_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authUser = FirebaseAuth.instance.currentUser;
  late final Stream<UserModel?>? _userStream = _authUser == null
      ? null
      : UserService().streamUser(_authUser.uid);
  late final Stream<List<BorrowingModel>>? _borrowStream = _authUser == null
      ? null
      : BorrowingService().streamBorrowings(_authUser.uid);

  String _fmt(Timestamp? t) {
    if (t == null) return '-';
    final d = t.toDate();
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // Header profil
            StreamBuilder<UserModel?>(
              stream: _userStream,
              builder: (context, snap) {
                final u = snap.data;
                final name = (u?.name ?? '').isNotEmpty
                    ? u!.name
                    : (_authUser?.displayName ?? 'Pengguna');
                final hasFoto = u != null && u.foto.isNotEmpty;
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.fromLTRB(20, 35, 20, 35),
                  decoration: BoxDecoration(
                    gradient: AppColors.gradient,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        backgroundImage: hasFoto ? NetworkImage(u.foto) : null,
                        child: hasFoto
                            ? null
                            : const Icon(
                                Icons.person,
                                size: 48,
                                color: AppColors.primary,
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        (u?.kelas ?? '').isEmpty
                            ? 'Kelas -'
                            : 'Kelas ${u!.kelas}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Riwayat pinjam
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: Text(
                'Riwayat Pinjam',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<List<BorrowingModel>>(
              stream: _borrowStream,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Gagal memuat riwayat: ${snap.error}'),
                  );
                }
                if (!snap.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final list = snap.data!;
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('Belum ada riwayat pinjam')),
                  );
                }
                return Column(
                  children: list
                      .map(
                        (b) => Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE8EEFF),
                              child: Icon(
                                Icons.history,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(
                              b.itemName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text('Dipinjam: ${_fmt(b.borrowDate)}'),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),

            // Logout
            Padding(
              padding: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                onPressed: () async {
                  await AuthService().logout();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
