import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import '../../services/borrowing_service.dart';
import '../../services/item_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/status_chip.dart';

class DetailItemScreen extends StatefulWidget {
  final ItemModel item;
  const DetailItemScreen({super.key, required this.item});

  @override
  State<DetailItemScreen> createState() => _DetailItemScreenState();
}

class _DetailItemScreenState extends State<DetailItemScreen> {
  // Item diikuti real-time, jadi status selalu terbaru
  late final Stream<ItemModel?> _itemStream = ItemService().streamItem(
    widget.item.id,
  );

  bool _loading = false;

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _borrow(ItemModel item) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _snack('Silakan login terlebih dahulu');
      return;
    }
    setState(() => _loading = true);
    try {
      await BorrowingService().borrowItem(
        uid,
        itemId: item.id,
        itemName: item.name,
      );
      if (mounted) _snack('Pengajuan pinjam berhasil dikirim');
    } on FirebaseException catch (e) {
      if (mounted) _snack('Gagal mengajukan pinjam: ${e.code}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _info(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
        ),
        const SizedBox(height: 3),
        Text(
          value.isEmpty ? '-' : value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ItemModel?>(
      stream: _itemStream,
      initialData: widget.item,
      builder: (context, snap) {
        final item = snap.data;
        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Data tidak ditemukan')),
          );
        }
        final canBorrow = item.status == AppStrings.available;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Detail Inventaris',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  item.image,
                  height: 230,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 230,
                    color: Colors.blue.shade50,
                    child: const Icon(Icons.image_not_supported, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StatusChip(status: item.status),
                ],
              ),
              const SizedBox(height: 20),
              _info('Kode Serial', item.code),
              _info('Kategori', item.category),
              _info('Spesifikasi', item.spesification),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: CustomButton(
                text: canBorrow ? 'Ajukan Pinjaman' : 'Sedang Dipinjam',
                loading: _loading,
                onPressed: canBorrow ? () => _borrow(item) : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
