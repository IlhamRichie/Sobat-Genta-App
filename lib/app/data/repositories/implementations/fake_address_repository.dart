// lib/data/repositories/implementations/fake_address_repository.dart
// (Buat file baru)

import '../../models/address_model.dart';
import '../abstract/address_repository.dart';

class FakeAddressRepository implements IAddressRepository {

  // Simulasikan Budi sudah punya 1 alamat
  final List<Map<String, dynamic>> _mockAddressDB = [
    {
      "address_id": "ADDR-001",
      "label": "Rumah",
      "recipient_name": "Budi Setiawan",
      "phone_number": "08123456789",
      "address_detail": "Jl. Merdeka No. 10, Dusun Krajan",
      "city": "Temanggung",
      "postal_code": "56200",
      "is_primary": true,
    }
  ];

  @override
  Future<List<AddressModel>> getMyAddresses() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAddressDB.map((json) => AddressModel.fromJson(json)).toList();
  }

  @override
  Future<AddressModel> addAddress(Map<String, dynamic> addressData) async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    final newAddressJson = {
      "address_id": "ADDR-${DateTime.now().millisecondsSinceEpoch}",
      "label": addressData['label'],
      "recipient_name": addressData['recipient_name'],
      "phone_number": addressData['phone_number'],
      "address_detail": addressData['address_detail'],
      "city": addressData['city'],
      "postal_code": addressData['postal_code'],
      "is_primary": false, // Alamat baru jarang langsung jadi primary
    };
    
    _mockAddressDB.add(newAddressJson);
    return AddressModel.fromJson(newAddressJson);
  }

  @override
  Future<void> setSelectedAddress(String addressId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Logika backend palsu: set semua ke false, lalu set satu ke true
    for (var addr in _mockAddressDB) {
      addr['is_primary'] = (addr['address_id'] == addressId);
    }
    print("Fake DB: Alamat utama diubah ke $addressId");
  }
}