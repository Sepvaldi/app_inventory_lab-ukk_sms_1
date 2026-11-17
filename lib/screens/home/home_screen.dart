import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/app_strings.dart';
import '../../models/item_model.dart';
import '../../models/user_model.dart';
import '../../services/item_service.dart';
import '../../services/user_service.dart';
import '../../widgets/banner_carousel.dart';
import '../../widgets/horizontal_item_list.dart';
import '../../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = ItemService();

  // Stream data pengguna yang sedang login (dibuat sekali)
  final _uid = FirebaseAuth.instance.currentUser?.uid;
  late final Stream<UserModel?>? _userStream = _uid == null
      ? null
      : UserService().streamUser(_uid);

  String _query = '';
  String _category = AppStrings.all;
  String _status = AppStrings.all;

  @override
  void initState() {
    super.initState();
    _service.seedIfEmpty(); // isi data dummy ke Firestore jika masih kosong
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<ItemModel>>(
          stream: _service.streamItems(),
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(child: Text('Gagal memuat data: ${snap.error}'));
            }
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final all = snap.data!;
            final categories = {for (final i in all) i.category}.toList()
              ..sort();

            final q = _query.toLowerCase();
            final filtered = all.where((i) {
              final okQ =
                  q.isEmpty ||
                  i.name.toLowerCase().contains(q) ||
                  i.code.toLowerCase().contains(q) ||
                  i.category.toLowerCase().contains(q);
              final okC =
                  _category == AppStrings.all || i.category == _category;
              final okS = _status == AppStrings.all || i.status == _status;
              return okQ && okC && okS;
            }).toList();

            return ListView(
              children: [
                // Greeting
                _GreetingHeader(stream: _userStream),

                // 1. Search bar
                SearchBarWidget(onChanged: (v) => setState(() => _query = v)),

                // 2. Carousel
                const BannerCarousel(),

                // 3a. Semua Data
                HorizontalItemList(title: 'Semua Data', items: filtered),

                // 3b. Kategori Peralatan
                HorizontalChipList(
                  title: 'Kategori Peralatan',
                  labels: [AppStrings.all, ...categories],
                  selected: _category,
                  onSelected: (v) => setState(() => _category = v),
                  iconFor: (l) => l == AppStrings.all
                      ? Icons.apps
                      : Icons.category_outlined,
                ),

                // 3c. Status
                HorizontalChipList(
                  title: 'Status',
                  labels: const [
                    AppStrings.all,
                    AppStrings.available,
                    AppStrings.borrowed,
                  ],
                  selected: _status,
                  onSelected: (v) => setState(() => _status = v),
                  iconFor: (l) => l == AppStrings.available
                      ? Icons.check_circle_outline
                      : l == AppStrings.borrowed
                      ? Icons.access_time
                      : Icons.apps,
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}


class _GreetingHeader extends StatelessWidget {
  final Stream<UserModel?>? stream;
  const _GreetingHeader({required this.stream});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: StreamBuilder<UserModel?>(
        stream: stream,
        builder: (context, snap) {
          final name = snap.data?.name ?? '';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo ${name.isEmpty ? 'Pengguna' : name}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Selamat datang',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          );
        },
      ),
    );
  }
}
