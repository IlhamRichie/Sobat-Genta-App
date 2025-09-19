// lib/data/repositories/abstract/address_repository.dart
// (Buat file baru)

import '../../models/address_model.dart';

abstract class IAddressRepository {
  /// Mengambil semua alamat tersimpan milik user
  Future<List<AddressModel>> getMyAddresses();

  /// Menambah alamat baru
  Future<AddressModel> addAddress(Map<String, dynamic> addressData);

  /// Menandai satu alamat sebagai tujuan utama (Primary/Selected)
  /// Backend harus menangani logic untuk 'uncheck' primary lama.
  Future<void> setSelectedAddress(String addressId);
  
  // (Nanti kita tambah update/delete untuk halaman "Manajemen Alamat" di Profil)
}