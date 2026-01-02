// lib/app/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // private constructor

  // --- Main Colors ---
  static const Color primary = Color(0xFF2D8C24);     // Hijau Genta
  static const Color primaryDark = Color(0xFF1E5E18); // Hijau Tua (untuk status bar/pressed)
  static const Color accent = Color(0xFFF2A900);      // Emas/Kuning Aksen
  
  // Alias agar kompatibel dengan kode UI 'Josjis' sebelumnya
  static const Color secondary = accent; 

  // --- Text Colors ---
  static const Color textDark = Color(0xFF222222);    // Hitam pekat untuk Judul
  static const Color textLight = Color(0xFF555555);   // Abu tua untuk Deskripsi
  
  // --- Background & Surface ---
  static const Color background = Color(0xFFFFFFFF);  // Putih bersih
  static const Color greyLight = Color(0xFFF0F0F0);   // Abu muda untuk placeholder/bg item
  static const Color surface = Color(0xFFFAFAFA);     // Putih tulang untuk card background

  // --- Icons & Others ---
  static const Color iconSecondary = Color(0xFF616161);
  static const Color error = Color(0xFFD32F2F);       // Merah standar error
}