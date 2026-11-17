import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/item_model.dart';
import 'item_card.dart';

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
        child: Text(text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );
}

/// Baris horizontal berisi kartu alat inventaris
class HorizontalItemList extends StatelessWidget {
  final String title;
  final List<ItemModel> items;

  const HorizontalItemList(
      {super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title),
        SizedBox(
          height: 215,
          child: items.isEmpty
              ? const Center(child: Text('Data tidak ditemukan'))
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: items.length,
                  itemBuilder: (_, i) => ItemCard(item: items[i]),
                ),
        ),
      ],
    );
  }
}

/// Baris horizontal berisi chip pilihan (kategori / status)
class HorizontalChipList extends StatelessWidget {
  final String title;
  final List<String> labels;
  final String selected;
  final ValueChanged<String> onSelected;
  final IconData Function(String label) iconFor;

  const HorizontalChipList({
    super.key,
    required this.title,
    required this.labels,
    required this.selected,
    required this.onSelected,
    required this.iconFor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title),
        SizedBox(
          height: 46,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            children: labels.map((l) {
              final active = l == selected;
              return GestureDetector(
                onTap: () => onSelected(l),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: active
                            ? AppColors.primary
                            : Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(iconFor(l),
                          size: 18,
                          color: active ? Colors.white : Colors.black54),
                      const SizedBox(width: 6),
                      Text(l,
                          style: TextStyle(
                              color: active ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}