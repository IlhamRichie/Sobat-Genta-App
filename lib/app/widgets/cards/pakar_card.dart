// lib/app/widgets/cards/pakar_card.dart

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

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    bool isOnline = pakar.isAvailable;
    
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto & Status Online
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: pakar.user.profilePictureUrl != null && pakar.user.profilePictureUrl!.isNotEmpty
                      ? Image.network(
                          pakar.user.profilePictureUrl!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 120,
                            color: AppColors.greyLight,
                            child: const Center(child: FaIcon(FontAwesomeIcons.userDoctor, color: Colors.grey, size: 48)),
                          ),
                        )
                      : Container(
                          height: 120,
                          color: AppColors.greyLight,
                          child: const Center(child: FaIcon(FontAwesomeIcons.userDoctor, color: Colors.grey, size: 48)),
                        ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(16),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pakar.user.fullName,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pakar.specialization,
                    style: Get.textTheme.bodySmall?.copyWith(color: AppColors.textLight),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rupiahFormatter.format(pakar.consultationFee),
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}