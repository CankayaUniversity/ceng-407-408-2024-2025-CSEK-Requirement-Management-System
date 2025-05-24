// lib/backend/projects/selected_project_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/backend/projects/projects_model.dart';

final selectedProjectProvider = StateProvider<ProjectsModel?>((ref) => null);
