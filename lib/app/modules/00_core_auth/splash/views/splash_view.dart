// lib/app/modules/splash/views/splash_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // onReady di controller akan dipanggil secara otomatis 
    // setelah frame pertama di-render.
    // Kita tidak perlu memanggil controller.init() secara manual.

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti ini dengan logo SobatGenta
            Icon(Icons.agriculture, size: 100, color: Colors.green),
            SizedBox(height: 24),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Menyiapkan aplikasi...'),
          ],
        ),
      ),
    );
  }
}