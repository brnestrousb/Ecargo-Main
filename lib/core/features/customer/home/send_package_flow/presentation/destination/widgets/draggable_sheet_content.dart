import 'dart:convert';
import 'dart:math';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/widgets/destination_result_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/widgets/badge_list_widget.dart';
import 'location_input_group.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class DraggableSheetContent extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onConfirmLocation;
  final String? pickupLocation;
  final VoidCallback onPickFromMap;
  final void Function({
    String? pickupAddress,
    LatLng? pickupLatLng,
    String? destinationAddress,
    LatLng? destinationLatLng,
  }) onLocationUpdated;

  const DraggableSheetContent({
    super.key,
    required this.scrollController,
    required this.onConfirmLocation,
    required this.onPickFromMap,
    this.pickupLocation,
    required this.onLocationUpdated,
  });

  @override
  State<DraggableSheetContent> createState() => _DraggableSheetContentState();
}

class _DraggableSheetContentState extends State<DraggableSheetContent> {
  final GlobalKey<LocationInputGroupState> _locationInputKey =
      GlobalKey<LocationInputGroupState>();

  LatLng selectedLatLng = LatLng(-6.2, 106.816666);
  String activeInput = 'destination';
  bool _hasCalledConfirm = false;

  String currentLocation = '';
  String destination = '';
  List<dynamic> destinationResults = [];
  bool isSearching = false;

  final Logger logger = Logger();
  LatLng? currentLocationLatLng;
  Timer? _debounce;

  Future<String?> getAddressFromLatLng(LatLng latLng) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}',
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'ecarrgoApp/1.0'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'];
    } else {
      return null;
    }
  }

  Future<void> fetchAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Periksa apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logger.e('Layanan lokasi tidak aktif');
      return;
    }

    // Periksa izin
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        logger.e('Izin lokasi ditolak');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      logger.e('Izin lokasi ditolak permanen');
      return;
    }

    // Ambil posisi saat ini
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latLng = LatLng(position.latitude, position.longitude);
    final address = await getAddressFromLatLng(latLng);

    if (address != null) {
      if (!mounted) return;
      setState(() {
        selectedLatLng = latLng;
        currentLocationLatLng = latLng; // Simpan lokasi saat ini
        currentLocation = address;
        _locationInputKey.currentState?.setLocation(current: address);
      });
    }
  }

  void saveToBookmark(dynamic item) {
    logger.i('Bookmark disimpan: $item');
  }

  // ganti searchDestination jadi private _searchDestination supaya ga dipanggil langsung user
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Panggil API hanya setelah 500ms user berhenti mengetik
      searchDestination(query);
    });
  }

  Future<void> searchDestination(String query) async {
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        destinationResults = [];
        isSearching = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() => isSearching = true);

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'ecarrgoApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        if (!mounted) return;
        setState(() {
          destinationResults = data;
          isSearching = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isSearching = false);
      logger.e('Gagal mencari tujuan: $e');
    }
  }

  // Panggil _onSearchChanged dari input text
  void _onLocationChanged(String current, String dest) {
    if (!mounted) return;
    setState(() {
      currentLocation = current;
      destination = dest;
      _hasCalledConfirm = false; // reset flag
    });

    if (activeInput == 'current') {
      _onSearchChanged(current);
    } else {
      _onSearchChanged(dest);
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Pi / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R * asin...
  }

  String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      final meters = (distanceKm * 1000).round();
      return '$meters m';
    } else {
      final kmRounded = distanceKm.round();
      return '$kmRounded Km';
    }
  }

  void _onFocusChanged(String input) {
    if (!mounted) return;
    setState(() {
      activeInput = input;
      destinationResults = [];
      isSearching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _debounce?.cancel(); // pastikan timer dibersihkan saat dispose
    fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      elevation: 24,
      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(16, 20, 16, 16), // Padding dialog utama
        child: ListView(
          controller: widget.scrollController,
          padding: EdgeInsets
              .zero, // Hapus padding ListView biar child bisa full lebar
          children: [
            // Konten lain, kasih Padding jika butuh

            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const Center(
              child: Text(
                "Alamat Tujuan",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Kalau kamu mau, kasih Padding di sini untuk konten selain Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: LocationInputGroup(
                currentLocation: currentLocation,
                destinationLocation: destination,
                key: _locationInputKey,
                onChanged: _onLocationChanged,
                onFocusChanged: _onFocusChanged,
              ),
            ),

            const SizedBox(height: 12),

            // ElevatedButton(
            //   onPressed: widget.onPickFromMap, // atau false
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.darkBlue,
            //     foregroundColor: Colors.white,
            //     minimumSize: const Size.fromHeight(48),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       SvgPicture.asset(
            //         'assets/images/icons/pick_from_maps_icon.svg',
            //         height: 20,
            //         width: 20,
            //         colorFilter: const ColorFilter.mode(
            //           Colors.white,
            //           BlendMode.srcIn,
            //         ),
            //       ),
            //       const SizedBox(width: 8),
            //       const Text("Pilih Alamat Anda Dari Peta"),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 20),

            BadgeListWidget(
              badges: [
                BadgeModel(icon: Icons.bookmark, name: "Gudang 1"),
                BadgeModel(icon: Icons.bookmark, name: "Gudang 2"),
                BadgeModel(icon: Icons.bookmark, name: "Gudang 3"),
              ],
            ),

            // Divider selebar dialog, tanpa padding ListView mempengaruhi
            const SizedBox(height: 20),
            const Divider(height: 1, color: Colors.grey),

            if (isSearching) ...[
              const SizedBox(height: 12),
              const Center(child: CircularProgressIndicator()),
            ],

            const SizedBox(height: 20),

            if (destinationResults.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 325,
                child: ListView.separated(
                  itemCount: destinationResults.length,
                  itemBuilder: (context, index) {
                    final item = destinationResults[index];
                    final fullAddress = item['display_name'] ?? '';
                    String shortTitle = fullAddress.split(',').first;
                    final lat = double.tryParse(item['lat'] ?? '');
                    final lon = double.tryParse(item['lon'] ?? '');

                    double? distanceKm;
                    String? distanceFormatted;
                    if (lat != null &&
                        lon != null &&
                        currentLocationLatLng != null) {
                      distanceKm = calculateDistance(
                        currentLocationLatLng!.latitude,
                        currentLocationLatLng!.longitude,
                        lat,
                        lon,
                      );
                      distanceFormatted = formatDistance(distanceKm);

                      // Log jarak untuk debug
                      logger.i(
                          'Distance calculated: $distanceKm Km, formatted: $distanceFormatted');
                    } else {
                      logger.w(
                          'Latitude or longitude is null, or currentLocationLatLng is null');
                    }

                    return DestinationResultItem(
                      shortTitle: shortTitle,
                      fullAddress: fullAddress,
                      distanceKm: distanceKm,
                      distanceFormatted: distanceFormatted,
                      onTap: () {
                        if (lat == null || lon == null) return;
                        final selectedLatLng = LatLng(lat, lon);

                        setState(() {
                          if (activeInput == 'current') {
                            currentLocation = fullAddress;
                            _locationInputKey.currentState
                                ?.setLocation(current: fullAddress);
                            widget.onLocationUpdated(
                              pickupAddress: fullAddress,
                              pickupLatLng: selectedLatLng,
                              destinationAddress: destination,
                              destinationLatLng: null,
                            );
                          } else {
                            destination = fullAddress;
                            _locationInputKey.currentState
                                ?.setLocation(destination: fullAddress);
                            widget.onLocationUpdated(
                              pickupAddress: currentLocation,
                              pickupLatLng: null,
                              destinationAddress: fullAddress,
                              destinationLatLng: selectedLatLng,
                            );
                          }
                        });

                        FocusScope.of(context).unfocus();

                        if (!_hasCalledConfirm &&
                            currentLocation.isNotEmpty &&
                            destination.isNotEmpty) {
                          _hasCalledConfirm = true;
                          widget.onConfirmLocation();
                        }
                      },
                      onBookmarkPressed: () => saveToBookmark(item),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
