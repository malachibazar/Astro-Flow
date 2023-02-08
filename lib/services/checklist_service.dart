// Service to handle storing and retrieving checklist data
// from SharedPreferences.
import 'dart:convert';

import 'package:astro_flow/models/checklist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChecklistService {
  // Load the user's checklist from local storage.
  Future<ChecklistModel> loadChecklist() async {
    // Load the user's checklist from local storage
    final preferences = await SharedPreferences.getInstance();
    final checklist = preferences.getStringList('checklist');
    // The data is stored as a list of strings.
    // Every other string is the text of the checklist item.
    // Every other string is whether the checklist item is checked off.
    // If the user has not set a checklist, return an empty checklist.
    if (checklist == null) return ChecklistModel(items: []);

    // Create a list of items from the data.
    final items = <ChecklistItemModel>[];
    for (var i = 0; i < checklist.length; i += 2) {
      items.add(
        ChecklistItemModel(
          id: i ~/ 2,
          text: checklist[i],
          checked: checklist[i + 1] == 'true',
        ),
      );
    }
    print(jsonEncode(items.map((item) => item.toMap()).toList()));

    return ChecklistModel(items: items);
  }

  // Save the user's checklist to local storage.
  Future<void> saveChecklist(ChecklistModel checklist) async {
    // Save the user's checklist to local storage
    final preferences = await SharedPreferences.getInstance();
    print(checklist.items
        .expand((item) => [item.text, item.checked.toString()])
        .toList()
        .toString());
    // The data is stored as a list of strings.
    await preferences.setStringList(
      'checklist',
      checklist.items
          .expand((item) => [item.text, item.checked.toString()])
          .toList(),
    );
  }
}
