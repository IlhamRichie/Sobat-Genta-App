// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_colors.dart'; // <-- IMPORT

void main() {
  runApp(
    GetMaterialApp(
      title: "SobatGenta",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),

      // --- PENGATURAN TEMA GLOBAL ---
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),

        // Set 'Inter' sebagai font default untuk SELURUH aplikasi
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(Get.context!).textTheme,
        ).copyWith(
          bodyMedium: TextStyle(color: AppColors.textLight),
          titleLarge: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700),
        ),

        // Tema default untuk tombol
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600, 
              fontSize: 16,
            ),
          ),
        ),
      ),
      // --- AKHIR TEMA ---
    ),
  );
}