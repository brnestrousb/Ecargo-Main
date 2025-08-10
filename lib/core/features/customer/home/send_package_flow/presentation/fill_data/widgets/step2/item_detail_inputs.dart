import 'package:ecarrgo/core/features/customer/home/send_package_flow/utils/rupiah_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemDetailInputs extends StatefulWidget {
  final TextEditingController weightController;
  final TextEditingController valueController;
  final TextEditingController dimensionController;
  final TextEditingController descriptionController;
  final VoidCallback onChanged;
  final bool readOnly; // tambahkan parameter ini

  const ItemDetailInputs({
    super.key,
    required this.weightController,
    required this.valueController,
    required this.dimensionController,
    required this.descriptionController,
    required this.onChanged,
    this.readOnly = false, // default false supaya backward compatible
  });

  @override
  State<ItemDetailInputs> createState() => _ItemDetailInputsState();
}

class _ItemDetailInputsState extends State<ItemDetailInputs> {
  final formatter = NumberFormat.decimalPattern('id_ID');

  @override
  Widget build(BuildContext context) {
    const borderRadius = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    );

    if (widget.readOnly) {
      // Format text saat readonly
      final rawText = widget.valueController.text;
      final cleanNumber = int.tryParse(
            rawText.replaceAll(RegExp(r'[^0-9]'), ''),
          ) ??
          0;

      // Format ulang jika belum diformat
      final formattedText = formatter.format(cleanNumber);

      // Set text jika belum sesuai
      if (widget.valueController.text != formattedText) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.valueController.text = formattedText;
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Group 1: Berat Total & Nilai Barang ===
        Row(
          children: [
            // === Berat Total ===
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Berat Total (ton) ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: widget.weightController,
                    keyboardType: TextInputType.number,
                    enabled: !widget.readOnly, // disable editing kalau readOnly
                    decoration: const InputDecoration(
                      border: borderRadius,
                      hintText: 'Masukkan berat',
                    ),
                    onChanged: (_) => widget.onChanged(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // === Nilai Barang ===
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Nilai Barang ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: widget.valueController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [RupiahInputFormatter()],
                    enabled: !widget.readOnly, // disable editing kalau readOnly
                    decoration: InputDecoration(
                      border: borderRadius,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 16, right: 8),
                        child: Text(
                          'Rp.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: 'Masukkan nilai',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    style: const TextStyle(fontSize: 16),
                    onChanged: (_) => widget.onChanged(),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // === Dimensi ===
        const Row(
          children: [
            Text(
              'Dimensi (per m3 / kubik) ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.dimensionController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          enabled: !widget.readOnly, // disable editing kalau readOnly
          decoration: const InputDecoration(
            border: borderRadius,
            hintText: '0 m³',
            suffixText: 'm³',
          ),
          onChanged: (_) => widget.onChanged(),
        ),

        const SizedBox(height: 16),

        // === Deskripsi Barang ===
        const Row(
          children: [
            Text(
              'Deskripsi Barang ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.descriptionController,
          maxLines: 3,
          enabled: !widget.readOnly, // disable editing kalau readOnly
          decoration: const InputDecoration(
            border: borderRadius,
            hintText: 'Contoh: Elektronik (laptop, aksesoris komputer)...',
          ),
          onChanged: (_) => widget.onChanged(),
        ),
      ],
    );
  }
}
