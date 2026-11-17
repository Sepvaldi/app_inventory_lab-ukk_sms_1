import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ukk_semester1/utils/app_colors.dart';
import '../models/item_model.dart';
import '../utils/app_strings.dart';
import '../utils/validators.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';

class ItemForm extends StatefulWidget {
  final ItemModel? item;
  final String submitText;
  final Future<void> Function(ItemModel item) onSubmit;

  const ItemForm({
    super.key,
    this.item,
    required this.submitText,
    required this.onSubmit,
  });

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.item?.name);
  late final _category = TextEditingController(text: widget.item?.category);
  late final _code = TextEditingController(text: widget.item?.code);
  late final _spec = TextEditingController(text: widget.item?.spesification);
  late final _image = TextEditingController(text: widget.item?.image);
  late String _status = widget.item?.status ?? AppStrings.available;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _code.dispose();
    _spec.dispose();
    _image.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await widget.onSubmit(
        ItemModel(
          id: widget.item?.id ?? '',
          name: _name.text.trim(),
          category: _category.text.trim(),
          code: _code.text.trim(),
          status: _status,
          image: _image.text.trim(),
          spesification: _spec.text.trim(),
          createdAt: widget.item?.createdAt,
        ),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: ${e.code}')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _name,
              label: 'Nama Alat',
              icon: Icons.inventory_2_outlined,
              validator: (v) => Validators.required(v, field: 'Nama Alat'),
            ),
            CustomTextField(
              controller: _category,
              label: 'Kategori',
              icon: Icons.category_outlined,
              validator: (v) => Validators.required(v, field: 'Kategori'),
            ),
            CustomTextField(
              controller: _code,
              label: 'Kode Serial',
              icon: Icons.qr_code,
              validator: (v) => Validators.required(v, field: 'Kode'),
            ),
            CustomTextField(
              controller: _spec,
              label: 'Spesifikasi',
              icon: Icons.description_outlined,
              validator: (v) => Validators.required(v, field: 'Spesifikasi'),
            ),
            CustomTextField(
              controller: _image,
              label: 'Link Gambar (URL)',
              icon: Icons.image_outlined,
              validator: (v) => Validators.required(v, field: 'Link Gambar'),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  labelText: 'Status',
                  prefixIcon: const Icon(Icons.flag_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: AppColors.primaryDark),
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: AppStrings.available,
                    child: Text(AppStrings.available),
                  ),
                  DropdownMenuItem(
                    value: AppStrings.borrowed,
                    child: Text(AppStrings.borrowed),
                  ),
                ],
                onChanged: (v) => setState(() => _status = v!),
              ),
            ),
            CustomButton(
              text: widget.submitText,
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
