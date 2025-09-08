import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/vendor/auction/data/datasources/auction_remote_vendor_datasources.dart';
import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model_vendor.dart';
import 'package:ecarrgo/core/features/vendor/auction/data/models/shipment_model_vendor.dart';
import 'package:ecarrgo/core/features/vendor/auction/data/models/vendor_model.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/pages/auction_detail_page.dart';
import 'package:ecarrgo/core/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  String selectedTab = "Rekomendasi"; //Default Tab Filter
  final Logger logger = Logger();

  late final AuctionRemoteVendorDataSource
      auctionRemoteVendorDataSource; // Data source untuk vendor
  bool isLoading = false;
  String? errorMessage;
  late Future<List<Auction>> _auctionsFuture;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    final dio = Dio(BaseOptions(
      baseUrl: '${ApiConstants.baseUrl}/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ));

    auctionRemoteVendorDataSource = AuctionRemoteVendorDataSourceImpl(dio);
    _auctionsFuture = _fetchAuctions();
  }

  Future<List<Auction>> _fetchAuctions() async {
    try {
      final response = await auctionRemoteVendorDataSource.getAllAuctions();

      final data = response['data'];
      if (data == null) {
        logger.e("Key 'data' tidak ada di response: $response");
        return [];
      }

      final List<dynamic> auctionsJson;
      if (data is Map<String, dynamic> && data['data'] is List) {
        auctionsJson = data['data'];
      } else if (data is List) {
        auctionsJson = data;
      } else {
        logger.e("Format data tidak sesuai: $data");
        return [];
      }

      return auctionsJson.map<Auction>((json) {
        final shipmentJson = json['shipment'];
        final vendorJson = json['vendor'];

        return Auction(
          id: json['id'] ?? 0,
          shipmentId: json['shipment_id'] ?? 0,
          vendorId: json['vendor_id'] ?? 0,
          startingBid: _parseToDouble(json['starting_bid']),
          auctionStartingPrice: _parseToDouble(json['auction_starting_price']),
          auctionDuration: json['auction_duration']?.toString() ?? '',
          status: json['status'] ?? '',
          createdAt:
              DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
          updatedAt:
              DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
          deletedAt: json['deleted_at'] != null
              ? DateTime.tryParse(json['deleted_at'])
              : null,
          expiresAt:
              DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
          shipment: shipmentJson != null
              ? Shipment.fromJson(shipmentJson)
              : Shipment.empty(),
          vendor:
              vendorJson != null ? Vendor.fromJson(vendorJson) : Vendor.empty(),
          bids: [],
        );
      }).toList();
    } catch (e, stack) {
      logger.e('Error fetching auctions: $e', error: e, stackTrace: stack);
      return [];
    }
  }

  /// Helper untuk parse dynamic ke double
  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
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
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text("Oops! Terjadi kesalahan",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text(
                            "Tidak dapat memuat data lelang.\nSilakan coba lagi nanti."),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _auctionsFuture =
                                  _fetchAuctions(); // refresh ulang
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Coba Lagi"),
                        ),
                        const SizedBox(height: 16),
                        Text(snapshot.error?.toString() ?? 'Unknown Error',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }

              final List<Auction> auctions = snapshot.data ?? [];
              var filteredAuctions = searchQuery.isEmpty
                  ? auctions
                  : auctions.where((auction) {
                      final city = auction.shipment.pickupCity.toLowerCase();
                      return city.contains(searchQuery);
                    }).toList();
              if (selectedTab == "Baru") {
                filteredAuctions.sort((a, b) {
                  final createdA = a.createdAt;
                  final createdB = b.createdAt;
                  return createdB.compareTo(createdA); // terbaru dulu
                });
                
              } else if (selectedTab == "Rekomendasi") {
                filteredAuctions.sort((a, b) {
                  final durationA = a.auctionDuration;
                  final durationB = b.auctionDuration;
                  return durationB.compareTo(durationA); // descending
                });
              } else {
                filteredAuctions = List.from(filteredAuctions);
              }

              if (auctions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/icons/empty_state.svg',
                          width: 180, height: 180),
                      const SizedBox(height: 16),
                      const Text('Belum ada Lelang ditemukan',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SvgPicture.asset('assets/images/vendor/auction.svg',
                        height: 50),
                    const SizedBox(height: 8),
                    const Text("Lelang disekitarmu!",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // Search Bar
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
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 1),
                                blurRadius: 6),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchQuery = value.toLowerCase();
                                  });
                                },
                                decoration: const InputDecoration(
                                    hintText: "Cari lokasi",
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tab Filter
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => selectedTab = 'Rekomendasi'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
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
                                    duration: const Duration(milliseconds: 250),
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
                              onTap: () => setState(() => selectedTab = 'Baru'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
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
                                    duration: const Duration(milliseconds: 250),
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

                    // Daftar Lelang
                    ...filteredAuctions.map((auction) => _AuctionItemCard(
                          auction: auction,
                          onTap: () {
                            final detail = Auction(
                              id: auction.id,
                              shipmentId: auction.shipmentId,
                              vendorId: auction.vendorId,
                              startingBid: auction.startingBid,
                              auctionStartingPrice:
                                  auction.auctionStartingPrice,
                              auctionDuration: auction.auctionDuration,
                              status: auction.status,
                              createdAt: auction.createdAt,
                              updatedAt: auction.updatedAt,
                              deletedAt: auction.deletedAt,
                              expiresAt: auction.expiresAt,
                              shipment:
                                  Shipment.fromJson(auction.shipment.toJson()),
                              vendor: auction.vendor != null
                                  ? Vendor.fromJson(auction.vendor!.toJson())
                                  : Vendor
                                      .empty(), // atau Vendor.empty() jika kamu sudah membuatnya
                              bids: [], // sesuaikan jika perlu
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      AuctionDetailPage(detail: detail)),
                            );
                          },
                        )),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
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
                      '${auction.shipment.pickupCity} - ${auction.shipment.deliveryCity}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Resi: ${auction.shipment.resiNumber}',
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                        NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(auction.auctionStartingPrice),
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
                          const SizedBox(width: 4),
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
                    _buildTag(auction.shipment.shippingType),
                    _buildTag("${auction.shipment.itemWeightTon}Kg"),
                    _buildTag(auction.shipment.itemTypes),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _mapTagStyle(String text) {
    switch (text.toLowerCase()) {
      // Shipping types
      case 'normal':
        return {
          'bgColor': Color(0xFFE8EEF4),
          'textColor': Color(0xFF01518D),
          'icon': null,
        };
      case 'prioritas':
        return {
          'bgColor': Color(0xFFA68B13),
          'textColor': Colors.white,
          'icon': null,
        };
      case 'silver':
        return {
          'bgColor': Color(0xFF6D7882),
          'textColor': Colors.white,
          'icon': null,
        };

      // Item types
      case 'makanan':
        return {
          'icon': 'assets/images/icons/type/food_type_icon.svg',
        };
      case 'pakaian':
        return {
          'icon': 'assets/images/icons/type/clothes_type_icon.svg',
        };
      case 'furniture':
        return {
          'icon': 'assets/images/icons/type/furnitur_type_icon.svg',
        };
      case 'book':
        return {
          'icon': 'assets/images/icons/type/book_type_icon.svg',
        };
      case 'obat & kesehatan':
        return {
          'icon': 'assets/images/icons/type/medicine_type_icon.svg',
        };
      case 'dokumen':
        return {
          'icon': 'assets/images/icons/type/document_type_icon.svg',
        };
      default:
        return {
          'icon': 'assets/images/icons/type/default_type_icon.svg',
        };
    }
  }

  Widget _buildTag(String text,
      {Color? bgColor, Color? textColor, String? icon}) {
    final style = _mapTagStyle(text);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor ?? style['bgColor'],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((icon != null) || (style['icon'] != null)) ...[
            SvgPicture.asset(icon ?? style['icon'], height: 14, width: 14),
            const SizedBox(width: 3),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor ?? style['textColor'],
            ),
          ),
        ],
      ),
    );
  }
}
