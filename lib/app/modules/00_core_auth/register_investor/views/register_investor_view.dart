import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../../auth_base/base_register_form.dart';
import '../controllers/register_investor_controller.dart';

class RegisterInvestorView extends GetView<RegisterInvestorController> {
  const RegisterInvestorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar sebagai Investor"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textDark),
      ),
      body: BaseRegisterForm(
        controller: controller,
        headerText: "Lengkapi data diri Anda untuk bergabung.",
        nameHint: "contoh: Citra Lestari",
        emailHint: "contoh: citra@investor.com",
      ),
    );
  }
}