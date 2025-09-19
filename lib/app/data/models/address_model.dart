// lib/data/models/address_model.dart
// (Buat file baru)

class AddressModel {
  final String addressId;
  final String label; // Cth: "Rumah", "Kantor"
  final String recipientName;
  final String phoneNumber;
  final String fullAddress;
  final String city;
  final String postalCode;
  final bool isPrimary;

  AddressModel({
    required this.addressId,
    required this.label,
    required this.recipientName,
    required this.phoneNumber,
    required this.fullAddress,
    required this.city,
    required this.postalCode,
    this.isPrimary = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'].toString(),
      label: json['label'] ?? 'Alamat',
      recipientName: json['recipient_name'] ?? json['full_name'], // fallback
      phoneNumber: json['phone_number'],
      fullAddress: json['address_detail'],
      city: json['city'],
      postalCode: json['postal_code'],
      isPrimary: json['is_primary'] ?? false,
    );
  }
}