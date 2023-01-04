// This model keeps track of the user's checklist.

class ChecklistItemModel {
  // The id of the item.
  int? id;
  // The text of the item.
  String text;
  // Whether the item is checked off.
  bool checked;

  // Constructor
  ChecklistItemModel({
    this.text = '',
    this.checked = false,
  });
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

  // Get the item with the highest id.
  int getHighestIdItem() {
    if (items.isEmpty) return 0;
    return items.map((item) => item.id).reduce((a, b) => a! > b! ? a : b)!;
  }
}
