import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../../data/models/expert_model.dart';
import '../../../../routes/app_pages.dart';

class ConsultationChatRoomController extends GetxController {
  
  late ExpertModel expertData;
  late types.User expertUser; 
  late types.User currentUser; 

  // --- [FIX] Ubah dari RxList menjadi List biasa ---
  final List<types.Message> messages = <types.Message>[];
  final uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    
    expertData = Get.arguments as ExpertModel;
    expertUser = types.User(
      id: expertData.id.toString(),
      firstName: expertData.name,
      imageUrl: expertData.imageUrl,
    );
    currentUser = const types.User(
      id: 'farmer_user_id_001',
      firstName: 'Budi Santoso',
      imageUrl: 'https://picsum.photos/seed/user/200',
    );
    
    _loadInitialMessages();
  }

  void onSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: currentUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: uuid.v4(),
      text: message.text,
    );
    _addMessage(textMessage);
    _simulateExpertReply();
  }

  // --- [FIX] Helper ini sekarang harus memanggil update() ---
  void _addMessage(types.Message message) {
    messages.insert(0, message);
    update(); // <-- INI KUNCINYA: Beri tahu GetBuilder untuk update UI
  }

  void _loadInitialMessages() {
    final initialMessage = types.TextMessage(
      author: expertUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: uuid.v4(),
      text: 'Halo, ${currentUser.firstName}! Ada yang bisa saya bantu terkait ${expertData.specialtyName}?',
    );
    _addMessage(initialMessage); // Ini juga akan memanggil update()
  }

  void _simulateExpertReply() {
    Future.delayed(1500.ms, () {
      final replyMessage = types.TextMessage(
        author: expertUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: uuid.v4(),
        text: 'Baik, saya terima pesannya. Akan segera saya analisis.',
      );
      _addMessage(replyMessage); // Ini juga akan memanggil update()
    });
  }

  void goToVideoCallPage() {
    // Arahkan ke halaman Video Call, kirim data Pakar juga
    Get.toNamed(
      Routes.CONSULTATION_VIDEO_CALL,
      arguments: expertData,
    );
  }
  
}