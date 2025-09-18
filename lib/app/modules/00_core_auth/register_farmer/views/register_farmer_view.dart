// lib/app/modules/register_farmer/views/register_farmer_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../auth_base/base_register_form.dart';
import '../controllers/register_farmer_controller.dart';

// Kita import Form reusable dari base (yang akan kita buat)
// Untuk sementara, kita buat di sini saja

class RegisterFarmerView extends GetView<RegisterFarmerController> {
  const RegisterFarmerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar sebagai Petani"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textDark),
      ),
      // Panggil widget Form yang reusable
      body: BaseRegisterForm(
        controller: controller, // Kirim controller-nya
        headerText: "Lengkapi data diri Anda untuk memulai.",
        nameHint: "contoh: Budi Setiawan",
        emailHint: "contoh: budi@petani.com",
      ),
    );
  }
}