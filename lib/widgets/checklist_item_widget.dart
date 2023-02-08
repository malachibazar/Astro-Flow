// A checklist item has a text field, a checkbox, and a delete button.

// The text field is used to edit the text of the checklist item.
// The checkbox is used to check off the checklist item.
// The delete button is used to remove the checklist item from the checklist.

import 'dart:convert';

import 'package:astro_flow/controllers/checklist_controller.dart';
import 'package:astro_flow/models/checklist_model.dart';
import 'package:flutter/material.dart';

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
                print(jsonEncode(widget.checklistController.checklist.items
                        .map((item) => item.toMap())
                        .toList())
                    .toString());
                widget.checklistController.checklist.removeItem(widget.item);
                print(jsonEncode(widget.checklistController.checklist.items
                        .map((item) => item.toMap())
                        .toList())
                    .toString());
                widget.checklistController
                    .saveChecklist(widget.checklistController.checklist);
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
                widget.checklistController.checklist.items
                    .firstWhere((item) => item.id == widget.item.id)
                    .text = value;
                widget.checklistController
                    .saveChecklist(widget.checklistController.checklist);
              },
            ),
          ),
          Checkbox(
            value: widget.item.checked,
            onChanged: widget.editMode
                ? (value) {
                    setState(() {
                      widget.checklistController.checklist.items
                          .firstWhere((item) => item.id == widget.item.id)
                          .checked = value!;
                      widget.checklistController
                          .saveChecklist(widget.checklistController.checklist);
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
