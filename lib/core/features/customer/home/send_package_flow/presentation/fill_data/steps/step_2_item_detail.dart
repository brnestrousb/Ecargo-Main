import 'package:flutter/material.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step2/item_detail_inputs.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step2/item_type_selector.dart';

class Step2ItemDetails extends StatefulWidget {
  final VoidCallback onNext;
  final void Function({
    required List<String> itemTypes,
    required String weight,
    required String value,
    required String dimensions,
    required String description,
  }) onItemDetailsChanged;
  final bool readOnly;

  const Step2ItemDetails({
    super.key,
    required this.onNext,
    required this.onItemDetailsChanged,
    this.readOnly = false,
  });

  @override
  State<Step2ItemDetails> createState() => _Step2ItemDetailsState();
}

class _Step2ItemDetailsState extends State<Step2ItemDetails>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _itemWeightController = TextEditingController();
  final TextEditingController _itemValueController = TextEditingController();
  final TextEditingController _itemDimensionController =
      TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();

  List<String> _selectedItemTypes = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _itemWeightController.dispose();
    _itemValueController.dispose();
    _itemDimensionController.dispose();
    _itemDescriptionController.dispose();
    super.dispose();
  }

  void _notifyParent() {
    if (!widget.readOnly) {
      widget.onItemDetailsChanged(
        itemTypes: _selectedItemTypes,
        weight: _itemWeightController.text,
        value: _itemValueController.text,
        dimensions: _itemDimensionController.text,
        description: _itemDescriptionController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ItemTypesSelector(
            readOnly: widget.readOnly,
            onItemTypesSelected: (selectedTypes) {
              if (!widget.readOnly) {
                setState(() {
                  _selectedItemTypes = selectedTypes;
                });
                print(
                    "Selected Item Types updated: $_selectedItemTypes"); // Debug print
                _notifyParent();
              }
            },
            selectedTypes: _selectedItemTypes,
          ),
          const SizedBox(height: 16),
          Container(height: 12, color: Colors.grey[200]),
          const SizedBox(height: 16),
          const Text(
            'Detail Barang',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ItemDetailInputs(
            readOnly: widget.readOnly,
            weightController: _itemWeightController,
            valueController: _itemValueController,
            dimensionController: _itemDimensionController,
            descriptionController: _itemDescriptionController,
            onChanged: _notifyParent,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
