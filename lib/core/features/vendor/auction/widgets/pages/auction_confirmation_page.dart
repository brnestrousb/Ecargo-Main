import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model_vendor.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/widgets/reusable_button_action.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OfferConfirmationPage extends StatefulWidget {
  const OfferConfirmationPage({super.key});

  @override
  State<OfferConfirmationPage> createState() => _AuctionConfirmationPageState();
}

class _AuctionConfirmationPageState extends State<OfferConfirmationPage> {
  late Future<Auction> _auctionDetail;
  int currentStep = 1;
  int? selectedIndex;
  final currencyFormat = NumberFormat.currency(
    locale: "id",
    symbol: 'Rp ',
    decimalDigits: 0,
  );


  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 20)),
      ),
      body: FutureBuilder<Auction>(
        future: _auctionDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada data"));
          }

          final detail = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // STEP INDICATOR
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
                const SizedBox(height: 20),

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
          );
        },
      ),
      bottomNavigationBar: BottomActionSection(
          buttonLabel: "Selanjutnya",
          categoryLabel: "🔥 Terbaik",
          categoryIcon: Icons.local_fire_department,
          onPressed: () {}),
    );
  }

  Widget _buildStepCircle(String number, {bool isActive = false}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF01518D) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? Color(0xFF01518D) : Colors.grey.shade300,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
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
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(detail.shipment.deliveryAddress,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 6),
            Text(detail.shipment.deliveryAddress,
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54, height: 1.4)),
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
              Text(currencyFormat.format(detail.auctionStartingPrice),
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
            // prefixIcon: Container(
            //   padding: const EdgeInsets.all(12),
            //   child: const Text("Rp.",
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            // ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            hintText: currencyFormat.format(detail..auctionStartingPrice),
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
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  labelText: "Tanggal penjemputan *",
                  hintText: "24/06/2025",
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.access_time, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  labelText: "Jam penjemputan *",
                  hintText: "08:00",
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
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "25/06/2025",
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  hintText: "26/06/2025",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
