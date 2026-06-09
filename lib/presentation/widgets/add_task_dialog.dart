import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class AddTaskDialog extends StatefulWidget {
  final void Function(String title, String? description) onAdd;

  const AddTaskDialog({super.key, required this.onAdd});

  static Future<void> show(
    BuildContext context,
    void Function(String title, String? description) onAdd,
  ) {
    return showDialog(
      context: context,
      builder: (_) => AddTaskDialog(onAdd: onAdd),
    );
  }

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final desc = _descController.text.trim();
      widget.onAdd(
        _titleController.text.trim(),
        desc.isEmpty ? null : desc,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.addTask),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: AppStrings.title),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppStrings.titleRequired;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descController,
              decoration:
                  const InputDecoration(labelText: AppStrings.description),
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text(AppStrings.add),
        ),
      ],
    );
  }
}
