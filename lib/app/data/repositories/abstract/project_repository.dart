// lib/data/repositories/abstract/project_repository.dart
// (Buat file baru)
import 'dart:io';

import '../../models/project_model.dart';
import '../../models/project_update_model.dart';

abstract class IProjectRepository {
  /// Petani membuat proposal proyek baru
  Future<void> createProjectProposal(Map<String, dynamic> textData, File? projectImage);

  Future<List<ProjectModel>> getMyProjects();

  Future<List<ProjectModel>> getPublishedProjects();

  Future<ProjectModel> getProjectById(String projectId);

  Future<void> investInProject(String projectId, double amount);

  Future<List<ProjectUpdateModel>> getProjectUpdates(String projectId);
}