import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('id_ID', null);
  runApp(GetMaterialApp(
    title: "Application",
    debugShowCheckedModeBanner: false,
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white, // Background utama app
      textTheme: GoogleFonts.interTextTheme(),
    ),
  ));
}
