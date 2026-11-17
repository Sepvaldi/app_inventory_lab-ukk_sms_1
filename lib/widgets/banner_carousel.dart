import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _current = 0;

  // Ganti atau tambahkan link gambar dari Google/internet di sini
  final List<String> _imageUrls = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmvCAkrWmO4O9Qph4ge0DW9lXZhU2Xs1e5pzrKPz9aBknmPu8C9P3xAR4&s=10',
    'https://upload.wikimedia.org/wikipedia/commons/0/0d/Volumetric_flasks.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSo4ykZi2PaAwZgkTmjT_plIhKvHuZZ-qdCpdB3zafQhefJ4__SYOKUwoI&s=10',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            itemCount: _imageUrls.length,
            onPageChanged: (index) => setState(() => _current = index),
            itemBuilder: (_, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  _imageUrls[index],
                  width: double.infinity,
                  height: 170,
                  fit: BoxFit.cover,
                  // Animasi loading saat gambar sedang diunduh
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  // Tampilan pengganti jika link gambar rusak/tidak bisa diakses
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Titik indikator halaman aktif
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _imageUrls.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _current == index ? 18 : 6,
              decoration: BoxDecoration(
                color: _current == index
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
