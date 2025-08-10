import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/shipping_package_data.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step3/dash_border_painter.dart';
import 'package:ecarrgo/core/providers/fill_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step3/shipping_package_card.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step3/shipping_protection_dialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Step3ShippingPackage extends StatefulWidget {
  final VoidCallback onNext;
  final ValueChanged<String> onShippingTypeChanged;
  final ValueChanged<String> onProtectionChanged;
  final bool readOnly;

  const Step3ShippingPackage({
    super.key,
    required this.onNext,
    required this.onShippingTypeChanged,
    required this.onProtectionChanged,
    this.readOnly = false,
  });

  @override
  State<Step3ShippingPackage> createState() => _Step3ShippingPackageState();
}

class _Step3ShippingPackageState extends State<Step3ShippingPackage> {
  String? _selectedProtection;
  String? _selectedProtectionIcon;
  String? _selectedShippingType;

  @override
  void initState() {
    super.initState();

    // Ambil data dari FillDataProvider jika tersedia
    final fillData = context.read<FillDataProvider>();

    if (widget.readOnly) {
      // Gunakan data dari provider jika tersedia
      _selectedShippingType = fillData.selectedShippingType ?? 'Reguler';
      _selectedProtection = fillData.selectedProtection ?? 'Silver';
      _selectedProtectionIcon = fillData.selectedProtection == 'Silver'
          ? 'assets/images/icons/silver_protection_icon.svg'
          : 'assets/images/icons/proteksi_icon.svg';
    }
  }

  void _showProtectionDialog() async {
    if (widget.readOnly) return;

    // 1. Hilangkan fokus secara eksplisit
    FocusManager.instance.primaryFocus?.unfocus();

    // 2. Sembunyikan keyboard sistem
    await SystemChannels.textInput.invokeMethod('TextInput.hide');

    // 3. Tambahkan delay lebih panjang
    await Future.delayed(const Duration(milliseconds: 300));

    // 4. Tampilkan dialog
    final Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
      context: context,
      // ignore: deprecated_member_use
      builder: (_) => WillPopScope(
        onWillPop: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          await SystemChannels.textInput.invokeMethod('TextInput.hide');
          return true;
        },
        child: const ShippingProtectionDialog(),
      ),
    );

    // 5. Setelah dialog ditutup, pastikan keyboard tetap tersembunyi
    if (mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
      await Future.delayed(const Duration(milliseconds: 100));

      if (result != null) {
        setState(() {
          _selectedProtection = result['name'] as String?;
          _selectedProtectionIcon = result['icon'] as String?;
        });
        widget.onProtectionChanged(result['name']!);
      }
    }
  }

  void _selectShippingType(String type) {
    if (widget.readOnly) return; // jika read-only, tidak boleh ubah

    setState(() {
      _selectedShippingType = type;
    });
    widget.onShippingTypeChanged(type);
  }

  @override
  Widget build(BuildContext context) {
    final fillData = context.watch<FillDataProvider>();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Bagian paket pengiriman
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pilih Paket Pengiriman',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Column(
                  children: shippingPackages.map((package) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ShippingPackageCard(
                        svgIconPath: package.iconPath,
                        title: package.title,
                        method: package.method,
                        description: package.description,
                        timeEstimate: package.timeEstimate,
                        priceEstimate: package.priceEstimate,
                        selected: fillData.selectedShippingType == package.id,
                        onTap: widget.readOnly
                            ? null
                            : () => _selectShippingType(package.id),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Separator full width
          Container(
            height: 12,
            color: Colors.grey[200],
          ),

          // Paket Proteksi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paket Proteksi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Stack(
                  children: [
                    CustomPaint(
                      painter: DashedBorderPainter(
                        color: Colors.grey.shade300,
                        borderRadius: 12,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (fillData.selectedProtection != null)
                              SvgPicture.asset(
                                _selectedProtectionIcon ??
                                    'assets/images/icons/proteksi_icon.svg',
                                width: 48,
                                height: 48,
                              )
                            else
                              SvgPicture.asset(
                                'assets/images/icons/proteksi_icon.svg',
                                width: 48,
                                height: 48,
                              ),
                            const SizedBox(height: 12),
                            Text(
                              fillData.selectedProtection != null
                                  ? 'Paket Proteksi: ${fillData.selectedProtection}'
                                  : 'Anda belum menambahkan Paket Proteksi,\ntambahkan sekarang',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: fillData.selectedProtection != null
                                    ? Colors.black
                                    : Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: widget.readOnly
                                  ? null
                                  : _showProtectionDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkBlue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/bookmark_icon.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    fillData.selectedProtection != null
                                        ? 'Ubah Proteksi'
                                        : 'Tambah Proteksi',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
