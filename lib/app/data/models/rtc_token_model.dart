// lib/data/models/rtc_token_model.dart
// (Buat file baru)

class RtcTokenModel {
  final String appId; // App ID Agora
  final String channelName; // Nama room
  final String rtcToken; // Token temporer

  RtcTokenModel({
    required this.appId,
    required this.channelName,
    required this.rtcToken,
  });

  factory RtcTokenModel.fromJson(Map<String, dynamic> json) {
    return RtcTokenModel(
      appId: json['app_id'],
      channelName: json['channel_name'],
      rtcToken: json['rtc_token'],
    );
  }
}