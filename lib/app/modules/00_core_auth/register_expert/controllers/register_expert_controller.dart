// lib/app/modules/register_expert/controllers/register_expert_controller.dart

import '../../auth_base/base_register_controller.dart';

class RegisterExpertController extends BaseRegisterController {
  
  // Hanya ini yang perlu kita tulis.
  @override
  final String userRole = 'EXPERT';
}