import 'package:flutter/material.dart';
import '../../models/item_model.dart';
import '../../services/item_service.dart';
import '../../widgets/item_form.dart';

class EditItemScreen extends StatelessWidget {
  final ItemModel item;
  const EditItemScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Inventaris',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ItemForm(
        item: item,
        submitText: 'Simpan Perubahan',
        onSubmit: (updated) => ItemService().updateItem(updated),
      ),
    );
  }
}
