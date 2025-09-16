import '../../modules/02_clinic_support/clinic_expert_list/controllers/clinic_expert_list_controller.dart';

class ExpertModel {
  final int id;
  final String name;
  final String specialtyName;
  final ExpertSpecialty specialtyEnum;
  final double rating;
  final String price;
  final bool isOnline;
  final String imageUrl;

  ExpertModel({
    required this.id,
    required this.name,
    required this.specialtyName,
    required this.specialtyEnum,
    required this.rating,
    required this.price,
    required this.isOnline,
    required this.imageUrl,
  });
}