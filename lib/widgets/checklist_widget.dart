// There are two modes for this widget: edit and view.
// In edit mode, the user can add and remove items from the checklist.
// In view mode, the user can only check off items.

import 'package:astro_flow/controllers/checklist_controller.dart';
import 'package:astro_flow/models/checklist_model.dart';
import 'package:astro_flow/widgets/checklist_item_widget.dart';
import 'package:flutter/material.dart';

class ChecklistWidget extends StatelessWidget {
  const ChecklistWidget(
      {Key? key, required this.editMode, required this.checklistController})
      : super(key: key);

  final bool editMode;
  final ChecklistController checklistController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in checklistController.checklist.items)
          ChecklistItem(
            item: item,
            editMode: editMode,
            checklistController: checklistController,
          ),
        if (editMode)
          ElevatedButton(
            onPressed: () {
              checklistController.checklist.items
                  .add(ChecklistItemModel(text: '', checked: false));
            },
            child: const Text('Add Item'),
          ),
      ],
    );
  }
}
