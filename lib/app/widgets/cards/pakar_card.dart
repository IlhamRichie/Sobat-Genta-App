// lib/app/widgets/cards/pakar_card.dart
// (Buat folder dan file baru ini)

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/pakar_profile_model.dart';
import '../../theme/app_colors.dart';

class PakarCard extends StatelessWidget {
  final PakarProfileModel pakar;
  final VoidCallback onTap;
  final double cardWidth; // Lebar kartu (untuk horizontal/vertical list)

  PakarCard({
    Key? key,
    required this.pakar,
    required this.onTap,
    this.cardWidth = 160,
  }) : super(key: key);

  // Widget ini mengelola formatter-nya sendiri
  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    bool isOnline = pakar.isAvailable;
    
    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8), // Beri margin agar tidak menempel
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto & Status Online
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity, // Sesuaikan dengan lebar kartu
                    decoration: const BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    // TODO: Ganti dengan Image.network(pakar.user.profilePictureUrl)
                    child: const Center(child: FaIcon(FontAwesomeIcons.userDoctor, color: Colors.grey)),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green.shade700 : Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isOnline ? "Online" : "Offline",
                        style: Get.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              // Info
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pakar.user.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      pakar.specialization,
                      style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      rupiahFormatter.format(pakar.consultationFee),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}