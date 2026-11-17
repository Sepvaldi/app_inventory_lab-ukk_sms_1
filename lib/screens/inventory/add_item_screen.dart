import 'package:flutter/material.dart';
import '../../services/item_service.dart';
import '../../widgets/item_form.dart';

class AddItemScreen extends StatelessWidget {
  const AddItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Inventaris',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ItemForm(
        submitText: 'Simpan',
        onSubmit: (item) => ItemService().addItem(item),
      ),
    );
  }
}
