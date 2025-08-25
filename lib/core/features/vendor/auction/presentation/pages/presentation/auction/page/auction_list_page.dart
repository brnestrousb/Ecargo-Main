import 'dart:async';
import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/model/auction/auction_model.dart';
import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/presentation/auction/service/list_auction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AuctionListPage extends StatefulWidget {
  const AuctionListPage({super.key});

  @override
  State<AuctionListPage> createState() => _AuctionListPageState();
}

class _AuctionListPageState extends State<AuctionListPage> {
  late Future<List<AuctionDetail>> _auctionList;
  Duration remainingTime = const Duration(hours: 4, minutes: 15);
  Timer? _timer;
  final currencyFormat = NumberFormat.currency(
    locale: "id",
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _auctionList = AuctionListService.fetchAuctionList();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // String _formatDuration(Duration duration) {
  //   final days = duration.inDays;
  //   final hours = duration.inHours % 24;
  //   final minutes = duration.inMinutes % 60;
  //   final seconds = duration.inSeconds % 60;

  //   if (days > 0) {
  //     return "$days Hari $hours Jam $minutes Menit";
  //   } else if (hours > 0) {
  //     return "$hours Jam $minutes Menit $seconds Detik";
  //   } else {
  //     return "$minutes Menit $seconds Detik";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AuctionDetail>>(
        future: _auctionList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada penawaran"));
          }

          final list = snapshot.data!;
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                color: Color(0xFF0168A4),
                child: Column(
                  children: [
                    // baris atas: tombol back
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ikon kotak kurir
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFE8EEF4),
                      child: SvgPicture.asset('assets/images/vendor/auction.svg')
                    ),
                    const SizedBox(height: 16),

                    // countdown waktu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimeBox("${remainingTime.inDays}", "Hari"),
                        const SizedBox(width: 8),
                        _buildTimeBox("${remainingTime.inHours % 24}", "Jam"),
                        const SizedBox(width: 8),
                        _buildTimeBox("${remainingTime.inMinutes % 60}", "Menit"),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // teks "Lelang berakhir pada"
                    const Text(
                      "Lelang berakhir pada:",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 8),

                    // baris tanggal + jam dengan ikon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.calendar_today, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text("24/06/2025", style: TextStyle(color: Colors.white, fontSize: 12)),
                        SizedBox(width: 20),
                        Icon(Icons.access_time, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text("08:00", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("List Penawaran Lelang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                  const SizedBox(width: 2),
                  const Text("(12)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                ],
              ),
              const SizedBox(height: 20),

              // filter chips
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF01518D),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: const Text(
                              "Terbaik",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: const Text(
                              "Tercepat",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: const Text(
                              "Termurah",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              // list vendor
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final auction = list[index];
                    return Column(
                      children: [
                        const SizedBox(width: 12),
                        const Divider(thickness: 0.7),
                        const SizedBox(width: 12),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/images/icons/profile.svg', width: 30, height: 30),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Divider(thickness: 0.7),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                            auction.customerName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                            const SizedBox(width: 2),
                                            Text("(⭐ 4.7)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                            const SizedBox(width: 5),
                                          ]
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          // crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Dibuat: ${auction.deliveryDate.day}/${auction.deliveryDate.month}/${auction.deliveryDate.year} ${auction.deliveryTime}",
                                              style: const TextStyle(
                                                  fontSize: 11, color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Estimasi tiba: ",
                                                style: const TextStyle(fontSize: 13)),
                                            const SizedBox(height: 5),
                                            Text(auction.shippingEstimate,
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Harga yang ditawarkan: ",
                                                style: const TextStyle(fontSize: 13)),
                                            const SizedBox(height: 5),
                                            Text(currencyFormat.format(auction.minBid),
                                              //auction.minBid.toStringAsFixed(0),
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("Level Vendor: ",
                                                style: const TextStyle(fontSize: 13)),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                SvgPicture.asset('assets/images/icons/level/silver_icon.svg'),
                                                const SizedBox(width: 2),
                                                const Text("Silver",
                                                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // summary penawaran
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0XFFE8EEF4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF01518D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFF01518D),
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: const Text(
                          "12",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Penawaran",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF01518D)),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "(4j 15m)",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Color(0xFF01518D)),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 0.7, height: 2),
              // tombol buat penawaran
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: Color(0xFF01518D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Buat Penawaran", style: TextStyle(color: Colors.white)),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}

Widget _buildTimeBox(String value, String label) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.baseline,
    textBaseline: TextBaseline.alphabetic, // penting untuk baseline alignment
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    ],
  );
}

