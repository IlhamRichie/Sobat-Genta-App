// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WAJIB ada di sini
  await initializeDateFormatting('id_ID', null); 

  final baseTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
    ),
  );

  runApp(
    GetMaterialApp(
      title: "SobatGenta",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,

      // --- PENGATURAN TEMA GLOBAL ---
      theme: baseTheme.copyWith(
        // Set 'Inter' sebagai font default untuk SELURUH aplikasi
        textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
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