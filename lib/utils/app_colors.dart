import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2F5BE0);     // biru royal
  static const primaryDark = Color(0xFF1E44C0);
  static const primaryLight = Color(0xFF4F7BF5);
  static const background = Color(0xFFF4F7FD);  // putih kebiruan
  static const card = Colors.white;
  static const accent = Color(0xFFFFD43B);      // kuning tombol banner
  static const danger = Color(0xFFD64545);      // teks stok / ikon hati
  static const available = Color(0xFF2E9E5B);
  static const borrowed = Color(0xFFE5651E);
  static const textGrey = Color(0xFF8A94A6);

  static const gradient = LinearGradient(
    colors: [primaryDark, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}