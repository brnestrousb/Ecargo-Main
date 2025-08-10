import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemTypesSelector extends StatefulWidget {
  final Function(List<String>) onItemTypesSelected;
  final bool readOnly;
  final List<String> selectedTypes;

  const ItemTypesSelector({
    super.key,
    required this.onItemTypesSelected,
    this.readOnly = false,
    this.selectedTypes = const [],
  });

  @override
  State<ItemTypesSelector> createState() => _ItemTypesSelectorState();
}

class _ItemTypesSelectorState extends State<ItemTypesSelector> {
  final List<Map<String, dynamic>> _badges = [
    {
      'label': 'Makanan',
      'iconPath': 'assets/images/icons/type/food_type_icon.svg',
    },
    {
      'label': 'Furniture',
      'iconPath': 'assets/images/icons/type/furnitur_type_icon.svg',
    },
    {
      'label': 'Buku',
      'iconPath': 'assets/images/icons/type/book_type_icon.svg',
    },
    {
      'label': 'Pakaian',
      'iconPath': 'assets/images/icons/type/clothes_type_icon.svg',
    },
    {
      'label': 'Dokumen',
      'iconPath': 'assets/images/icons/type/document_type_icon.svg',
    },
    {
      'label': 'Obat & Kesehatan',
      'iconPath': 'assets/images/icons/type/medicine_type_icon.svg',
    },
  ];

  late List<String> _selectedTypes;
  final List<String> _customTypes = [];
  final TextEditingController _otherTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTypes = List<String>.from(widget.selectedTypes);
    // Pisahkan custom types jika ada dari selectedTypes (misal yg tidak ada di _badges)
    for (final type in _selectedTypes) {
      if (!_badges.any((badge) => badge['label'] == type) &&
          !_customTypes.contains(type)) {
        _customTypes.add(type);
      }
    }
    // Hapus customTypes dari _selectedTypes supaya tidak duplikat
    _selectedTypes.removeWhere((type) => _customTypes.contains(type));
  }

  @override
  void didUpdateWidget(covariant ItemTypesSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTypes != oldWidget.selectedTypes) {
      _selectedTypes = List<String>.from(widget.selectedTypes);
      // Sync custom types juga
      _customTypes.clear();
      for (final type in _selectedTypes) {
        if (!_badges.any((badge) => badge['label'] == type)) {
          _customTypes.add(type);
        }
      }
      _selectedTypes.removeWhere((type) => _customTypes.contains(type));
    }
  }

  @override
  void dispose() {
    _otherTypeController.dispose();
    super.dispose();
  }

  void _updateSelectedTypes() {
    widget.onItemTypesSelected(_selectedTypes + _customTypes);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Colors.grey[300];

    if (widget.readOnly) {
      // Only show badges user selected (default + custom)
      final selectedBadges = _selectedTypes
          .where((label) => _badges.any((b) => b['label'] == label))
          .map((label) {
        final badge = _badges.firstWhere((b) => b['label'] == label);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBlue),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                badge['iconPath'],
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.black)),
            ],
          ),
        );
      }).toList();

      final customBadges = _customTypes.map((customLabel) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.darkBlue),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/icons/type/default_type_icon.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(customLabel, style: const TextStyle(color: Colors.black)),
            ],
          ),
        );
      });

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...selectedBadges,
              ...customBadges,
            ],
          ),
        ],
      );
    }

    // Non-readonly: full interactive UI
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jenis Barang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ..._badges.map((badge) {
              final label = badge['label'];
              final iconPath = badge['iconPath'];
              final isSelected = _selectedTypes.contains(label);

              return ChoiceChip(
                showCheckmark: false,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(iconPath, width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text(label, style: const TextStyle(color: Colors.black)),
                  ],
                ),
                selected: isSelected,
                backgroundColor: Colors.white,
                selectedColor: Colors.white,
                pressElevation: 0,
                shadowColor: Colors.transparent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? AppColors.darkBlue : borderColor!,
                  ),
                ),
                onSelected: widget.readOnly
                    ? null
                    : (_) {
                        setState(() {
                          if (isSelected) {
                            _selectedTypes.remove(label);
                          } else {
                            _selectedTypes.add(label);
                          }
                        });
                        _updateSelectedTypes();
                      },
              );
            }),

            // Custom badges with delete icon (only tappable if not readonly)
            ..._customTypes.map((customLabel) {
              return Container(
                padding: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.darkBlue),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/type/default_type_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(customLabel,
                          style: const TextStyle(color: Colors.black)),
                      if (!widget.readOnly) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _customTypes.remove(customLabel);
                            });
                            _updateSelectedTypes();
                          },
                          child: const Icon(Icons.close,
                              size: 16, color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Jenis Lainnya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (!widget.readOnly)
          TextField(
            controller: _otherTypeController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Tambahkan lainnya..',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: SvgPicture.asset(
                  'assets/images/icons/btn_edit.svg',
                  width: 20,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final value = _otherTypeController.text.trim();
                  if (value.isEmpty) return;
                  if (_customTypes.contains(value)) return;
                  if (_customTypes.length >= 3) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Maksimal 3 jenis barang yang boleh ditambahkan.'),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    _customTypes.add(value);
                    _otherTypeController.clear();
                  });
                  _updateSelectedTypes();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
      ],
    );
  }
}
