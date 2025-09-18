// lib/app/modules/register_farmer/controllers/register_farmer_controller.dart

import '../../auth_base/base_register_controller.dart';

class RegisterFarmerController extends BaseRegisterController {
  
  // Cukup override role-nya. Selesai.
  @override
  final String userRole = 'FARMER'; 
}