import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step4/auction_duration.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step4/auction_info_box.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step4/delivery_time_section.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step4/price_input_field.dart';
import 'package:ecarrgo/core/providers/fill_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Step4AuctionSettings extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onEditDeliveryTime;
  final DateTime? deliveryDateTime;
  final bool readOnly; // tambah parameter readOnly

  const Step4AuctionSettings({
    super.key,
    required this.onNext,
    required this.onEditDeliveryTime,
    required this.deliveryDateTime,
    this.readOnly = false, // default false
  });

  @override
  State<Step4AuctionSettings> createState() => _Step4AuctionSettingsState();
}

class _Step4AuctionSettingsState extends State<Step4AuctionSettings> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _startingPriceController;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    final fillDataProvider =
        Provider.of<FillDataProvider>(context, listen: false);

    _startingPriceController =
        TextEditingController(text: fillDataProvider.startingPrice);
    _durationController =
        TextEditingController(text: fillDataProvider.auctionDuration);

    _startingPriceController.addListener(() {
      if (!widget.readOnly) {
        fillDataProvider.startingPrice = _startingPriceController.text;
      }
    });

    if (widget.deliveryDateTime == null) {
      throw Exception('deliveryDateTime tidak boleh null');
    }
  }

  @override
  void dispose() {
    _startingPriceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fillDataProvider = Provider.of<FillDataProvider>(context);

    // Update controller text jika ada perubahan dari provider (optional, supaya sync)
    if (_startingPriceController.text != fillDataProvider.startingPrice) {
      _startingPriceController.text = fillDataProvider.startingPrice;
    }
    if (_durationController.text != fillDataProvider.auctionDuration) {
      _durationController.text = fillDataProvider.auctionDuration;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengaturan Lelang',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            AuctionInfoBox(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    content: Text('Informasi lengkap tentang sistem lelang...'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            PriceInputField(
              controller: _startingPriceController,
              label: 'Penawaran Awal (Rp)',
              hintText: '0',
              readOnly: widget.readOnly, // set readOnly ke input
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga awal harus diisi';
                }
                final parsed =
                    int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                if (parsed == null) {
                  return 'Masukkan angka yang valid';
                }
                if (parsed < 120000) {
                  return 'Penawaran awal minimum Rp. 120.000';
                }
                return null;
              },
              onChanged: widget.readOnly
                  ? null
                  : (value) {
                      fillDataProvider.startingPrice = value;
                    },
            ),
            const SizedBox(height: 8),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: const [
            //     Icon(Icons.info_outline, size: 20, color: Colors.grey),
            //     SizedBox(width: 8),
            //     Text(
            //       'Penawaran awal minimum Rp. 120.000',
            //       style: TextStyle(fontSize: 14, color: Colors.grey),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 24),
            AuctionDurationWidget(
              initialUnit: fillDataProvider.auctionDurationUnit,
              initialValue: fillDataProvider.auctionDurationValue,
              deliveryDateTime:
                  widget.deliveryDateTime ?? DateTime.now(), // Nilai default
              readOnly: widget.readOnly,
              onDurationChanged: widget.readOnly
                  ? null
                  : (unit, value) {
                      fillDataProvider.auctionDurationUnit = unit;
                      fillDataProvider.auctionDurationValue = value;

                      // Update auctionDuration as string: "12 Jam"
                      fillDataProvider.auctionDuration = '$value $unit';
                    },
            ),
            const SizedBox(height: 12),
            DeliveryTimeSection(
              formattedDate: widget.deliveryDateTime != null
                  ? '${widget.deliveryDateTime!.day}/${widget.deliveryDateTime!.month}/${widget.deliveryDateTime!.year}'
                  : 'Tanggal tidak tersedia',
              formattedTime: widget.deliveryDateTime != null
                  ? '${widget.deliveryDateTime!.hour.toString().padLeft(2, '0')}:${widget.deliveryDateTime!.minute.toString().padLeft(2, '0')}'
                  : 'Waktu tidak tersedia',
              onEditDeliveryTime: widget.onEditDeliveryTime,
              readOnly: false,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
