// lib/app/modules/register_expert/views/register_expert_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../auth_base/base_register_form.dart';
import '../controllers/register_expert_controller.dart';

class RegisterExpertView extends GetView<RegisterExpertController> {
  const RegisterExpertView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar sebagai Pakar"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textDark),
      ),
      body: BaseRegisterForm(
        controller: controller, // Kirim controller-nya
        headerText: "Bergabunglah sebagai pakar dan bantu petani.",
        nameHint: "contoh: Drh. Budi Santoso",
        emailHint: "contoh: pakar@genta.com",
      ),
    );
  }
}