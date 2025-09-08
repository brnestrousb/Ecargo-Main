import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model_vendor.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/widgets/reusable_button_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class OfferConfirmationPage extends StatefulWidget {
  final Auction auction; // ✅ terima auction langsung

  const OfferConfirmationPage({super.key, required this.auction});

  @override
  State<OfferConfirmationPage> createState() => _AuctionConfirmationPageState();
}

class _AuctionConfirmationPageState extends State<OfferConfirmationPage> {
  int currentStep = 1;
  int? selectedIndex;
  var _isLoading = false;
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _arrivalStartController = TextEditingController();
  final TextEditingController _arrivalEndController = TextEditingController();


  final currencyFormat = NumberFormat.currency(
    locale: "id",
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final detail = widget.auction; // ✅ akses langsung

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEP INDICATOR
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Row(
            //     children: [
            //       _buildStepCircle("1", isActive: currentStep >= 1),
            //       Expanded(
            //         child: Divider(
            //           color: currentStep >= 1
            //               ? const Color(0xFF01518D)
            //               : Colors.grey.shade300,
            //           thickness: 2,
            //         ),
            //       ),
            //       _buildStepCircle("2", isActive: currentStep >= 1),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 20),

            // TUJUAN
            _buildDestinationCard(detail),

            const SizedBox(height: 20),

            // PENAWARAN
            _buildBidSection(detail),

            const SizedBox(height: 20),

            // WAKTU PENJEMPUTAN
            _buildPickupSection(),

            const SizedBox(height: 20),

            // ESTIMASI TIBA
            _buildArrivalSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionSection(
        buttonLabel: "Selanjutnya",
        categoryLabel: "🔥 Terbaik",
        categoryIcon: Icons.local_fire_department,
        onPressed: _isLoading ? null : _showConfirmationDialog,
      ),
    );
  }

  Future<void> _submitBid() async {
  setState(() => _isLoading = true);

  // tampilkan loader overlay
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  // simulasi API call 2 detik
  await Future.delayed(const Duration(seconds: 2));

  if (mounted) {
    Navigator.pop(context); // tutup loader
    setState(() => _isLoading = false);

    // balik ke halaman sebelumnya (atau bisa push ke halaman sukses)
    Navigator.pop(context, true);
  }
}

  void _showConfirmationDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
            const SizedBox(height: 16),
            const Text(
              "Buat penawaran?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SvgPicture.asset("assets/images/vendor/badge_confirmation.svg"), // ilustrasi opsional
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context), // batal
                    style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                  
                    child: const Text("Kembali", style: TextStyle(color: Color(0xFF6D7882), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          backgroundColor: Color(0Xff01518D)),
                    onPressed: () {
                      Navigator.pop(context); // tutup dialog
                      _submitBid(); // lanjut ke loader
                    },
                    child: const Text("Ya, Buat Penawaran", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
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

  Widget _buildDestinationCard(Auction detail) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: Colors.amber, size: 18),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F2DE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Alamat Tujuan",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(detail.shipment.deliveryCity,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 6),
            Text(detail.shipment.deliveryAddress,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black, height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget _buildBidSection(Auction detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text("Penawaran Anda",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(width: 4),
            Icon(Icons.help_outline, size: 18, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Minimal lelang:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              Text(
                  NumberFormat.currency(
                          locale: "id", symbol: 'Rp ', decimalDigits: 0)
                      .format(detail.auctionStartingPrice),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF01518D))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text("Penawaran Anda *",
            style: TextStyle(fontSize: 14, color: Colors.black)),
        const SizedBox(height: 6),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: currencyFormat.format(detail.startingBid),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildPickupSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text("Waktu Penjemputan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(width: 4),
            Icon(Icons.help_outline, size: 18, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _pickupDateController,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _pickupDateController.text =
                        DateFormat('dd/MM/yyyy').format(picked);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "dd/mm/yyyy",
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _pickupTimeController,
                readOnly: true,
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    // ignore: use_build_context_synchronously
                    _pickupTimeController.text = picked.format(context);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.access_time, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "-- . --",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildArrivalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text("Estimasi Tiba",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(width: 4),
            Icon(Icons.help_outline, size: 18, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _arrivalStartController,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _arrivalStartController.text =
                        DateFormat('dd/MM/yyyy').format(picked);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "dd/mm/yyyy",
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _arrivalEndController,
                readOnly: true,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _arrivalEndController.text =
                        DateFormat('dd/MM/yyyy').format(picked);
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "dd/mm/yyyy",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}
