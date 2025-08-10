import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/customer/activity/data/datasources/auction_remote_data_source.dart';
import 'package:ecarrgo/core/features/customer/activity/presentation/widgets/activity_item_card.dart';
import 'package:ecarrgo/core/features/customer/activity/presentation/widgets/empty_state.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/send_package_flow_layout.dart';
import 'package:ecarrgo/core/features/customer/presentation/widgets/custom_tab_navigation.dart';
import 'package:ecarrgo/core/network/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String selectedTimeFilter = '60 Hari Terakhir';
  final Logger logger = Logger();
  final List<String> timeFilterOptions = [
    '7 Hari Terakhir',
    '30 Hari Terakhir',
    '60 Hari Terakhir',
    '90 Hari Terakhir',
    'Custom'
  ];

  late final AuctionRemoteDataSource auctionRemoteDataSource;
  List<Map<String, dynamic>> activityDataFromApi = [];
  bool isLoading = false;
  String? errorMessage;

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

    fetchActivityData();
  }

  Future<void> fetchActivityData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Tambahkan delay untuk simulasi loading
      await Future.delayed(const Duration(seconds: 2));

      final response = await auctionRemoteDataSource.getMyAuctions();
      // Pretty print the response
      // final encoder = JsonEncoder.withIndent('  ');
      // logger.i('Raw Response:\n${encoder.convert(response)}');

      final List<dynamic> apiData = response['data']['data'];
      final List<Map<String, dynamic>> parsedData =
          apiData.map<Map<String, dynamic>>((auction) {
        final shipment = auction['shipment'] ?? {};

        // Handle price formatting
        String priceString = (auction['auction_starting_price'] ?? '0')
            .toString()
            .replaceAll('.', '');
        double price = double.tryParse(priceString) ?? 0;

        // Handle date - fallback to current date if empty
        String dateString = auction['created_at'] is String
            ? auction['created_at']
            : DateTime.now().toIso8601String();

        // Potong alamat menjadi 4 kata pertama
        String fullAddress = shipment['delivery_address'] ?? '';
        List<String> addressWords = fullAddress.split(' ');
        String shortAddress = addressWords.length > 4
            ? '${addressWords.sublist(0, 4).join(' ')}...'
            : fullAddress;

        String formattedAuctionStatus =
            (auction['status']?.toString().toLowerCase() ?? '')
                .replaceAll('_', ' ') // ganti underscore jadi spasi
                .split(' ') // pisah per kata
                .map((word) => word.isNotEmpty
                    ? word[0].toUpperCase() + word.substring(1)
                    : '')
                .join(' ');

        return {
          'id': auction['id'], // Tambahkan ID auction
          'shipment_id': auction['shipment_id'], // Tambahkan shipment_id
          'date': dateString,
          'price': price,
          'category':
              shipment['origin_city_id'] == shipment['destination_city_id']
                  ? 'Dalam Kota'
                  : 'Luar Kota',
          'status': formattedAuctionStatus,
          'address': shortAddress,
          'resi': shipment['resi_number'] ?? '',
        };
      }).toList();

      setState(() {
        activityDataFromApi = parsedData;
        isLoading = false;
      });
    } catch (e) {
      logger.e('Error fetching auction data: $e');
      setState(() {
        errorMessage = 'Gagal memuat data. Silakan coba lagi.';
        isLoading = false;
      });
    }
  }

  DateTimeRange? customDateRange;

  String selectedTab = 'Riwayat';
  final List<String> tabs = ['Riwayat', 'Dalam Proses', 'Draf'];

  final TextEditingController searchController = TextEditingController();

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  DateTime getStartDate() {
    final now = DateTime.now();
    switch (selectedTimeFilter) {
      case '7 Hari Terakhir':
        return now.subtract(const Duration(days: 7));
      case '30 Hari Terakhir':
        return now.subtract(const Duration(days: 30));
      case '60 Hari Terakhir':
        return now.subtract(const Duration(days: 60));
      case '90 Hari Terakhir':
        return now.subtract(const Duration(days: 90));
      case 'Custom':
        return customDateRange?.start ?? DateTime(2000);
      default:
        return DateTime(2000);
    }
  }

  DateTime getEndDate() {
    final now = DateTime.now();
    if (selectedTimeFilter == 'Custom') {
      return customDateRange?.end ?? now;
    }
    return now;
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = activityDataFromApi.where((activity) {
      final activityDate =
          DateTime.tryParse(activity['date'] ?? '') ?? DateTime(2000);
      final isWithinDateRange = activityDate
              .isAfter(getStartDate().subtract(const Duration(days: 1))) &&
          activityDate.isBefore(getEndDate().add(const Duration(days: 1)));

      final matchesTab = selectedTab == 'Riwayat' ||
          (selectedTab == 'Dalam Proses' && activity['status'] == 'active') ||
          (selectedTab == 'Draf' && activity['status'] == 'draft');

      final matchesSearch = (activity['resi'] ?? '')
          .toLowerCase()
          .contains(searchController.text.toLowerCase());

      return matchesTab && matchesSearch && isWithinDateRange;
    }).toList();

    // Logger().i(filteredList);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Aktivitas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range, size: 18),
                            const SizedBox(width: 8),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedTimeFilter,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: timeFilterOptions.map((filter) {
                                  return DropdownMenuItem(
                                    value: filter,
                                    child: Text(filter),
                                  );
                                }).toList(),
                                onChanged: (value) async {
                                  if (value == 'Custom') {
                                    final pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        selectedTimeFilter = 'Custom';
                                        customDateRange = DateTimeRange(
                                          start: pickedDate,
                                          end: pickedDate,
                                        );
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      selectedTimeFilter = value!;
                                      customDateRange = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () {
                            // TODO: Export or download feature
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Tab Navigation
              CustomTabNavigation(
                tabs: tabs,
                selectedTab: selectedTab,
                onTabSelected: (tab) {
                  setState(() {
                    selectedTab = tab;
                  });
                },
                tabCounts: {
                  'Riwayat': activityDataFromApi.length,
                  'Dalam Proses': activityDataFromApi
                      .where((e) => e['status'] == 'Dalam Proses')
                      .length,
                  'Draf': activityDataFromApi
                      .where((e) => e['status'] == 'Draf')
                      .length,
                },
              ),

              const SizedBox(height: 16),

              // Search bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari nomor resi...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 16),

              Text(
                'Total Riwayat (${filteredList.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 16),

              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ),
                )
              else if (errorMessage != null)
                Expanded(
                  child: Center(
                    child: Text(
                      'Terjadi kesalahan: $errorMessage',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else if (filteredList.isEmpty)
                const Expanded(
                  child: EmptyStateWidget(),
                )
              else
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchActivityData,
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SendPackageFlowLayout(
                                  auctionId: item['id'],
                                  shipmentId: item['shipment_id'],
                                ),
                              ),
                            );
                          },
                          child: ActivityItemCard(
                            item: item,
                            currencyFormatter: currencyFormatter,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
