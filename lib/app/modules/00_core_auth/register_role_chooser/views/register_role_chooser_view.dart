import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../../theme/app_colors.dart';
import '../controllers/register_role_chooser_controller.dart';

class RegisterRoleChooserView extends GetView<RegisterRoleChooserController> {
  const RegisterRoleChooserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set status bar icons to dark
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian Utama (Scrollable)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Pilih Peran Anda",
                      style: Get.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2D3436),
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tentukan bagaimana Anda ingin berkontribusi dalam ekosistem Genta.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- Pilihan Peran ---
                    
                    // 1. Petani (Primary Green)
                    _buildRoleCard(
                      title: "Saya Petani",
                      desc: "Ajukan pendanaan, kelola lahan, dan jual hasil panen.",
                      icon: FontAwesomeIcons.seedling,
                      color: AppColors.primary,
                      onTap: controller.navigateToFarmerRegistration,
                    ),
                    const SizedBox(height: 16),

                    // 2. Investor (Gold/Amber)
                    _buildRoleCard(
                      title: "Saya Investor",
                      desc: "Investasi pada proyek riil & pantau ROI secara transparan.",
                      icon: FontAwesomeIcons.chartLine,
                      color: const Color(0xFFF39C12), // Amber/Gold
                      onTap: controller.navigateToInvestorRegistration,
                    ),
                    const SizedBox(height: 16),

                    // 3. Pakar (Blue)
                    _buildRoleCard(
                      title: "Saya Pakar",
                      desc: "Buka jasa konsultasi & bagikan keahlian pertanian.",
                      icon: FontAwesomeIcons.userDoctor,
                      color: const Color(0xFF3498DB), // Blue
                      onTap: controller.navigateToExpertRegistration,
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Footer (Login Redirect)
            _buildLoginFooter(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
        onPressed: () => Get.back(),
      ),
    );
  }

  /// Kartu Peran dengan Desain Modern
  Widget _buildRoleCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE0E0E0).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: FaIcon(icon, color: color, size: 22),
                ),
              ),
              const SizedBox(width: 16),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Chevron Icon (Center Vertically)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Footer Login
  Widget _buildLoginFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Sudah punya akun? ", style: TextStyle(color: Colors.grey.shade600)),
          GestureDetector(
            onTap: controller.navigateToLogin,
            child: const Text(
              "Masuk",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}