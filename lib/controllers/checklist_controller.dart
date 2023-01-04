// Handles the logic for the checklist page

import 'package:astro_flow/models/checklist_model.dart';
import 'package:astro_flow/services/checklist_service.dart';
import 'package:flutter/widgets.dart';

class ChecklistController with ChangeNotifier {
  ChecklistController(this._checklistService);

  final ChecklistService _checklistService;

  late ChecklistModel _checklist;

  ChecklistModel get checklist => _checklist;

  // Load the user's checklist from local storage.
  Future<void> loadChecklist() async {
    _checklist = await _checklistService.loadChecklist();
    notifyListeners();
  }

  // Save the user's checklist to local storage.
  Future<void> saveChecklist() async {
    await _checklistService.saveChecklist(_checklist);
  }
}
