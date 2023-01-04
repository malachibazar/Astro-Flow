// Service to handle storing and retrieving checklist data
// from SharedPreferences.
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
    // Every third string is the id of the checklist item.
    // If the user has not set a checklist, return an empty checklist.
    if (checklist == null) return ChecklistModel(items: []);

    // Otherwise, return the user's checklist.
    return ChecklistModel(
      items: List.generate(
        checklist.length ~/ 2,
        (index) => ChecklistItemModel(
          text: checklist[index * 2],
          checked: checklist[index * 2 + 1] == 'true',
        ),
      ),
    );
  }

  // Save the user's checklist to local storage.
  Future<void> saveChecklist(ChecklistModel checklist) async {
    // Save the user's checklist to local storage
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      'checklist',
      List.generate(
        checklist.items.length * 2,
        (index) => index.isEven
            ? checklist.items[index ~/ 2].text
            : checklist.items[index ~/ 2].checked.toString(),
      ),
    );
  }
}
