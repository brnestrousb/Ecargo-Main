import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/customer/activity/data/datasources/auction_remote_data_source.dart';
// import 'package:ecarrgo/core/features/vendor/auction/data/datasources/auction_remote_vendor_datasources.dart';
import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model_vendor.dart';
import 'package:ecarrgo/core/features/vendor/auction/data/models/shipment_model_vendor.dart';
import 'package:ecarrgo/core/features/vendor/auction/data/models/vendor_model.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/pages/auction_detail_page.dart';
import 'package:ecarrgo/core/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  String selectedTab = "Rekomendasi"; //Default Tab Filter
  final Logger logger = Logger();
  late final AuctionRemoteDataSource auctionRemoteDataSource;
  List<Map<String, dynamic>> activityDataFromApi = [];
  bool isLoading = false;
  String? errorMessage;
  late Future<List<Auction>> _auctionsFuture;

  @override
  void initState() {
    super.initState();

    final dio = Dio(BaseOptions(
      baseUrl: '${ApiConstants.baseUrl}/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    auctionRemoteDataSource = AuctionRemoteDataSourceImpl(dio);
    _auctionsFuture = auctionRemoteDataSource.getMyAuctions().then((data) {
      try {
        // ✅ Validasi lengkap
        final dynamic auctionsData = data['data'];

        if (auctionsData is List) {
          // 🔧 Proses dengan penanganan null
          final List<Auction> auctions = <Auction>[];

          for (var item in auctionsData) {
            if (item != null && item is Map<String, dynamic>) {
              try {
                final auction = Auction.fromJson(item);
                auctions.add(auction);
              } catch (e) {
                Logger().e('Error parsing auction item: $e');
                // Skip item yang error
              }
            }
          }

          return auctions;
        }

        return <Auction>[];
      } catch (e) {
        Logger().e('Error in auctions parsing: $e');
        return <Auction>[];
      }
    });
    fetchAuctionData();
  }

  Future<void> fetchAuctionData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: FutureBuilder<List<Auction>>(
              future: _auctionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  final errorMessage = snapshot.error.toString();

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          const Text(
                            "Oops! Terjadi kesalahan",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Tidak dapat memuat data lelang.\nSilakan coba lagi nanti.",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _auctionsFuture = auctionRemoteDataSource
                                    .getMyAuctions()
                                    .then((data) {
                                  final List<dynamic> auctionsJson =
                                      data['data'] ?? [];
                                  return auctionsJson
                                      .map<Auction>(
                                          (json) => Auction.fromJson(json))
                                      .toList();
                                });
                              });
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text("Coba Lagi"),
                          ),
                          const SizedBox(height: 16),
                          // detail error untuk developer (debug mode)
                          Text(
                            errorMessage,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // HEADER ICON
                        SvgPicture.asset(
                          'assets/images/vendor/auction.svg',
                          height: 50,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Lelang disekitarmu!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // SEARCH BAR
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 45, vertical: 12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black
                                      // ignore: deprecated_member_use
                                      .withOpacity(0.1), // shadow tipis
                                  offset:
                                      const Offset(0, 1), // arah shadow ke atas
                                  blurRadius: 6, // bikin shadow halus
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.amber, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      hintText: "Cari lokasi",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTab = 'Rekomendasi';
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: selectedTab == 'Rekomendasi'
                                          ? const Color(0xFF002D72)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Center(
                                      child: AnimatedDefaultTextStyle(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        style: TextStyle(
                                          color: selectedTab == 'Rekomendasi'
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        child: const Text("Rekomendasi"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTab = 'Baru';
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: selectedTab == 'Baru'
                                          ? const Color(0xFF002D72)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Center(
                                      child: AnimatedDefaultTextStyle(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        style: TextStyle(
                                          color: selectedTab == 'Baru'
                                              ? Colors.white
                                              : const Color(0xFF002D72),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        child: const Text("Baru"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // LIST AUCTION ITEMS

                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/icons/empty_state.svg',
                                width: 180,
                                height: 180,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Belum ada Lelang ditemukan',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                }
                final auction = snapshot.data ?? [];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // HEADER ICON
                      SvgPicture.asset(
                        'assets/images/vendor/auction.svg',
                        height: 50,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Lelang disekitarmu!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // SEARCH BAR
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 45, vertical: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black
                                    // ignore: deprecated_member_use
                                    .withOpacity(0.1), // shadow tipis
                                offset:
                                    const Offset(0, 1), // arah shadow ke atas
                                blurRadius: 6, // bikin shadow halus
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: "Cari lokasi",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 45, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Rekomendasi';
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: selectedTab == 'Rekomendasi'
                                        ? const Color(0xFF002D72)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      style: TextStyle(
                                        color: selectedTab == 'Rekomendasi'
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      child: const Text("Rekomendasi"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Baru';
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: selectedTab == 'Baru'
                                        ? const Color(0xFF002D72)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: AnimatedDefaultTextStyle(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      style: TextStyle(
                                        color: selectedTab == 'Baru'
                                            ? Colors.white
                                            : const Color(0xFF002D72),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      child: const Text("Baru"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // LIST AUCTION ITEMS

                      ...auction.map((auction) => _AuctionItemCard(
                            auction: auction,
                            onTap: () {
                              // Mapping Auction ke AuctionDetail
                              final detail = Auction(
                                id: auction.id,
                                shipmentId: auction.shipmentId,
                                vendorId: auction.id,
                                startingBid: auction.startingBid,
                                auctionStartingPrice:
                                    auction.auctionStartingPrice,
                                auctionDuration: auction.auctionDuration,
                                status: auction.status,
                                createdAt: auction.createdAt,
                                updatedAt: auction.updatedAt,
                                deletedAt: auction.deletedAt,
                                expiresAt: auction.expiresAt,
                                shipment: Shipment.fromJson(
                                    auction.shipment.toJson()),
                                vendor: Vendor.fromJson(auction.vendor
                                    .toJson()), // sesuaikan jika properti vendor tidak ada di Auction
                                bids: [], // mapping jika ada
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AuctionDetailPage(detail: detail),
                                ),
                              );
                            },
                          )),
                      const SizedBox(height: 8)
                    ],
                  ),
                );
              }),
        ));
  }
}

class _AuctionItemCard extends StatelessWidget {
  final Auction auction;
  final VoidCallback? onTap;

  const _AuctionItemCard({
    required this.auction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // TITLE + FAVORITE ICON
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      auction.shipment.pickupAddress,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // PRICE - TIME - BIDS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Penawaran terbaik:",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                        "Rp ${auction.auctionStartingPrice}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF002D72)),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Waktu tersisa:",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/vendor/timer.svg'),
                          const SizedBox(width: 2),
                          Text(auction.auctionDuration),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Penawaran:",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Row(
                        children: [
                          SvgPicture.asset('assets/images/vendor/box.svg'),
                          const SizedBox(width: 2),
                          Text("${auction.bids.length}"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              // TAGS
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildTag(auction.status, Colors.white, Colors.black),
                    _buildTag("${auction.shipment.itemWeightTon} Kg",
                        Colors.white, Colors.black),
                    _buildTag(auction.shipment.shippingType, Colors.white,
                        Colors.black,
                        icon: 'assets/images/vendor/food.svg'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor,
      {String? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[SvgPicture.asset(icon)],
          const SizedBox(width: 1),
          Text(text,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
