// This model keeps track of the user's checklist.

import 'dart:convert';

class ChecklistItemModel {
  // The id of the item.
  int id;
  // The text of the item.
  String text;
  // Whether the item is checked off.
  bool checked;

  // Constructor
  ChecklistItemModel({
    this.id = 0,
    this.text = '',
    this.checked = false,
  });

  // Convert the item to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'checked': checked,
    };
  }
}

class ChecklistModel {
  // The list of items in the checklist.
  List<ChecklistItemModel> items;

  // Constructor
  ChecklistModel({
    this.items = const [],
  });

  // Add an item to the checklist.
  void addItem(ChecklistItemModel item) {
    item.id = getHighestIdItem() + 1;
    items.add(item);
  }

  // Remove an item from the checklist.
  void removeItem(ChecklistItemModel item) {
    // print a json string of the item
    print(jsonEncode(items.map((item) => item.toMap()).toList()));
    items.removeWhere((element) => element.id == item.id);
    print(jsonEncode(items.map((item) => item.toMap()).toList()));
  }

  // Get the item with the highest id.
  int getHighestIdItem() {
    if (items.isEmpty) return 0;
    return items.map((item) => item.id).reduce((a, b) => a > b ? a : b);
  }
}
