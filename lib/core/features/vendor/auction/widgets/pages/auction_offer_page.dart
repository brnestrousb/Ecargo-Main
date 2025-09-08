import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model_vendor.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/pages/auction_confirmation_page.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/widgets/reusable_button_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({super.key, required this.auction});
  final Auction auction;

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  int currentStep = 1;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final detail = widget.auction.shipment; // ✅ akses langsung detail
    final weightKg = double.tryParse(detail.itemWeightTon) ?? 0.0;
    final itemWeightTon = (weightKg / 1000).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Buat Penawaran",
            style: TextStyle(
                fontSize: 16, fontVariations: [FontVariation.weight(700)])),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20)),
      ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStepCircle("1", isActive: currentStep >= 1),
                Expanded(
                  child: Divider(
                    color: currentStep >= 2
                        ? const Color(0xFF01518D)
                        : Colors.grey.shade300,
                    thickness: 2,
                  ),
                ),
                _buildStepCircle("2", isActive: currentStep >= 2),
              ],
            ),
          ),

          // Info Box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kapasitas:",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                    Text("Volume (P x L x T):",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    
                    Text("$itemWeightTon Ton",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF01518D))),
                    Text("${detail.itemVolumeM3} m³",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF01518D))),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selectedIndex == 0
                          ? const Color(0xFF01518D)
                          : const Color(0xFFF6F8F9),
                      width: 2,
                    ),
                  ),
                  child: RadioListTile<int>(
                    value: 0,
                    groupValue: selectedIndex,
                    activeColor: const Color(0xFF01518D),
                    onChanged: (val) {
                      setState(() => selectedIndex = val);
                    },
                    title: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9BAAB7), Color(0XFFE8EEF4)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/images/vendor/box_car.svg',
                            width: 36,
                            height: 36,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User ID: ${detail.userId.toString()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Resi: ${detail.resiNumber}',
                                style: const TextStyle(
                                    color: Color(0xFFA68B13), fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        const Divider(thickness: 0.7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Kapasitas Maks: $itemWeightTon Ton"),
                            Text("Volume Maks: ${detail.itemVolumeM3} m³"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          BottomActionSection(
            buttonLabel: "Selanjutnya",
            categoryLabel: "🔥 Terbaik",
            categoryIcon: Icons.local_fire_department,
            onPressed: selectedIndex != null
                ? () {
                    setState(() => currentStep = 2);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OfferConfirmationPage(auction: widget.auction),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(String number, {bool isActive = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF01518D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? const Color(0xFF01518D) : Colors.grey.shade300,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(number,
          style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold)),
    );
  }
}

