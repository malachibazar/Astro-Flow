// A checklist item has a text field, a checkbox, and a delete button.

// The text field is used to edit the text of the checklist item.
// The checkbox is used to check off the checklist item.
// The delete button is used to remove the checklist item from the checklist.

import 'package:astro_flow/controllers/checklist_controller.dart';
import 'package:astro_flow/models/checklist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChecklistItem extends StatefulWidget {
  const ChecklistItem(
      {super.key,
      required this.item,
      required this.editMode,
      required this.checklistController});

  final ChecklistItemModel item;
  final bool editMode;
  final ChecklistController checklistController;

  @override
  State<ChecklistItem> createState() => _ChecklistItemState();
}

class _ChecklistItemState extends State<ChecklistItem> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.item.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          if (widget.editMode)
            IconButton(
              onPressed: () {
                // Remove the item from the checklist using the item id.
                widget.checklistController.checklist.items
                    .removeWhere((element) => element.id == widget.item.id);
                widget.checklistController.saveChecklist();
              },
              icon: const Icon(Icons.delete),
            ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Checklist Item',
              ),
              onChanged: (value) {
                widget.item.text = value;
                widget.checklistController.saveChecklist();
              },
            ),
          ),
          Checkbox(
            value: widget.item.checked,
            onChanged: widget.editMode
                ? (value) {
                    setState(() {
                      widget.item.checked = value!;
                      widget.checklistController.saveChecklist();
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
