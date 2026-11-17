class BannerData {
  final String image, title, subtitle;
  const BannerData(this.image, this.title, this.subtitle);
}

class AppStrings {
  static const appName = 'Inventaris Lab';

  // Nama koleksi Firestore
  static const colUsers = 'users';
  static const colItems = 'items';
  static const colBorrowings = 'borrowings';

  // Status & filter
  static const available = 'Available';
  static const borrowed = 'Borrowed';
  static const all = 'Semua';

  // Banner carousel
  static const banners = [
    BannerData('https://picsum.photos/seed/lab1/800/400',
        'Peralatan Baru Tiba!', 'Aset lab siap dipinjam.'),
    BannerData('https://picsum.photos/seed/lab2/800/400',
        'Pinjam Alat Lebih Mudah', 'Cukup beberapa ketukan.'),
    BannerData('https://picsum.photos/seed/lab3/800/400',
        'Cek Ketersediaan Real-time', 'Status alat selalu terbaru.'),
  ];
}