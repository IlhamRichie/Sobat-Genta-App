// lib/data/repositories/implementations/fake_project_repository.dart
// (Buat file baru)
import 'dart:io';

import '../../models/project_model.dart';
import '../../models/project_update_model.dart';
import '../abstract/project_repository.dart';

class FakeProjectRepository implements IProjectRepository {

  final List<Map<String, dynamic>> _mockProjectDatabase = [
    {
      "project_id": "PROJ-001",
      "title": "Siklus Tanam Bawang Merah Super",
      "target_fund": 50000000.0, "collected_fund": 50000000.0,
      "status": "FUNDED", "asset_name": "Lahan Subur Utama", "project_image_url": null,
      "description": "Proyek ini bertujuan untuk menanam Bawang Merah varietas unggul di lahan 2 Hektar...",
      "duration_days": 90, "roi_percentage": 15.0,
      "rab_details_json": [
        {"item_name": "Bibit Bawang (1 Ton)", "cost": 20000000.0},
        {"item_name": "Pupuk Organik Cair", "cost": 10000000.0},
        {"item_name": "Tenaga Kerja Harian (5 orang @ 60 hari)", "cost": 20000000.0}
      ],
      "farmer_profile": {
        "user_id": "farmer_123", "full_name": "Budi (Petani)", "total_projects": 3
      }
    },
    {
      "project_id": "PROJ-002",
      "title": "Perluasan Kandang Sapi Perah",
      "target_fund": 75000000.0, "collected_fund": 30000000.0,
      "status": "PUBLISHED", "asset_name": "Peternakan Sapi Perah", "project_image_url": null,
      "description": "Pengembangan kandang untuk menambah kapasitas 10 ekor sapi perah...",
      "duration_days": 120, "roi_percentage": 18.0,
      "rab_details_json": [
        {"item_name": "Material Bangunan", "cost": 40000000.0},
        {"item_name": "Upah Tukang", "cost": 15000000.0},
        {"item_name": "Instalasi Pipa Air & Listrik", "cost": 20000000.0}
      ],
      "farmer_profile": {
        "user_id": "farmer_456", "full_name": "Joko Susilo", "total_projects": 1
      }
    }
  ];

  final Map<String, List<Map<String, dynamic>>> _mockProjectUpdates = {
    // Update untuk proyek Bawang (PROJ-001)
    "PROJ-001": [
      {
        "update_id": "PU-003",
        "title": "Panen Berhasil!",
        "description": "Panen bawang merah telah selesai, total 5 ton. Siap untuk distribusi dan pembagian hasil.",
        "image_url": null,
        "timestamp": "2024-11-15T14:00:00Z"
      },
      {
        "update_id": "PU-002",
        "title": "Proses Pemupukan Kedua",
        "description": "Pemupukan kedua menggunakan pupuk organik cair telah selesai.",
        "image_url": "https://example.com/images/pupuk.jpg",
        "timestamp": "2024-10-01T09:00:00Z"
      },
      {
        "update_id": "PU-001",
        "title": "Pembelian Bibit Selesai",
        "description": "1 Ton bibit bawang varietas unggul telah tiba di lokasi.",
        "image_url": null,
        "timestamp": "2024-09-05T11:00:00Z"
      }
    ],
    // Update untuk proyek Sapi (PROJ-002)
    "PROJ-002": [
       {
        "update_id": "PU-004",
        "title": "Pemasangan Atap Kandang",
        "description": "Proses pemasangan atap baja ringan telah 50% selesai.",
        "image_url": "https://example.com/images/atap.jpg",
        "timestamp": "2024-11-10T15:00:00Z"
      },
       {
        "update_id": "PU-005",
        "title": "Pengecoran Lantai",
        "description": "Pengecoran lantai kandang utama telah selesai dan dalam proses pengeringan.",
        "image_url": null,
        "timestamp": "2024-11-01T12:00:00Z"
      }
    ]
  };

  @override
  Future<void> createProjectProposal(Map<String, dynamic> textData, File? projectImage) async {
    await Future.delayed(const Duration(seconds: 2));
    
    print("--- FAKE PROJECT PROPOSAL SUBMITTED ---");
    print("Data: $textData");
    if (projectImage != null) {
      print("File Proyek: ${projectImage.path}");
    }
    print("STATUS: PENDING_ADMIN (Sesuai Flowchart A2)");
    
    
    // Simulasi sukses
    final newProject = {
      "project_id": "NEW-${DateTime.now().millisecondsSinceEpoch}",
      "title": textData['title'],
      "target_fund": textData['target_fund'],
      "collected_fund": 0.0,
      "status": "PENDING_ADMIN", // Sesuai Flowchart A2
      "asset_name": "Aset (ID: ${textData['land_id']})", // Sederhanakan untuk fake data
      "project_image_url": null,
    };
    
    // Tambahkan di awal list
    _mockProjectDatabase.insert(0, newProject);
    return;
  }

  @override
  Future<List<ProjectModel>> getMyProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Kembalikan semua data dari database palsu kita
    return _mockProjectDatabase.map((json) => ProjectModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProjectModel>> getPublishedProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Sesuai Flowchart A4, Investor hanya melihat
    // proyek yang sudah di-publish (atau sudah didanai).
    // Kita filter proyek dengan status PENDING_ADMIN.
    final publishedList = _mockProjectDatabase.where((json) {
      return json['status'] == "PUBLISHED" || json['status'] == "FUNDED";
    }).toList();
    
    // Kita urutkan agar yang 'PUBLISHED' (masih galang dana)
    // tampil di atas yang 'FUNDED'.
    publishedList.sort((a, b) {
      if (a['status'] == 'PUBLISHED' && b['status'] != 'PUBLISHED') return -1;
      if (a['status'] != 'PUBLISHED' && b['status'] == 'PUBLISHED') return 1;
      return 0;
    });

    return publishedList.map((json) => ProjectModel.fromJson(json)).toList();
  }

  @override
  Future<ProjectModel> getProjectById(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi network
    
    // Temukan proyek di database palsu
    final projectJson = _mockProjectDatabase.firstWhere(
      (p) => p['project_id'] == projectId,
      orElse: () => throw Exception("Proyek tidak ditemukan"),
    );
    
    // (Simulasi update data 'collectedFund' secara real-time)
    // if (projectJson['status'] == 'PUBLISHED') {
    //   projectJson['collected_fund'] += 100000; // Tambah 100rb tiap di-load
    // }

    return ProjectModel.fromJson(projectJson);
  }

  @override
  Future<void> investInProject(String projectId, double amount) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulasi proses transaksi

    // 1. Temukan proyek di 'database' palsu kita
    final projectIndex = _mockProjectDatabase.indexWhere(
      (p) => p['project_id'] == projectId
    );

    if (projectIndex == -1) {
      throw Exception("Proyek tidak ditemukan");
    }

    // 2. Update data proyek (Simulasi Transaksi Backend)
    final project = _mockProjectDatabase[projectIndex];
    double currentCollected = (project['collected_fund'] as num).toDouble();
    double target = (project['target_fund'] as num).toDouble();
    
    currentCollected += amount;

    // Update data di 'database' palsu
    _mockProjectDatabase[projectIndex]['collected_fund'] = currentCollected;

    // 3. Cek apakah pendanaan sudah penuh
    if (currentCollected >= target) {
      _mockProjectDatabase[projectIndex]['status'] = "FUNDED";
    }

    // (Di backend asli, ini juga akan mengurangi saldo dompet investor)
    
    return;
  }

  @override
  Future<List<ProjectUpdateModel>> getProjectUpdates(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Ambil update berdasarkan ID proyek
    final updates = _mockProjectUpdates[projectId];
    
    if (updates == null) {
      return []; // Tidak ada update
    }
    
    return updates.map((json) => ProjectUpdateModel.fromJson(json)).toList();
  }

}