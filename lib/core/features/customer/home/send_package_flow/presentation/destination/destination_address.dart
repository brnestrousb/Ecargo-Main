import 'dart:async';
import 'dart:convert';

import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/model/location_data.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/model/map_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'widgets/draggable_sheet_content.dart';
import 'widgets/map_section.dart';
import 'widgets/confirm_pickup_dialog.dart';
import 'widgets/pickup_destination_dialog.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/fill_data_page.dart';
import 'widgets/back_button_widget.dart';

class DestinationAddressScreen extends StatefulWidget {
  const DestinationAddressScreen({super.key});

  @override
  State<DestinationAddressScreen> createState() =>
      _DestinationAddressScreenState();
}

class _DestinationAddressScreenState extends State<DestinationAddressScreen>
    with TickerProviderStateMixin {
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();
  final logger = Logger();
  late BuildContext rootContext;

  late double _maxChildSize = 0.9;
  MapFocusMode _mapFocusMode = MapFocusMode.pickupOnly;
  Timer? _debounce;
  bool isLoading = false;

  bool _isReady = false;

  LatLng? _pickupLatLng;
  LatLng? _destinationLatLng;

  String? _pickupLocation;

  late MapController _mapController;
  late AnimationController _animationController;
  Timer? _snapTimer;

  bool _isDialogOpen = false;
  bool _showDraggableSheet = true;
  bool _isDialogActive = false;

  // bool _isMapVisible = false;

  List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _maxChildSize = 0.9;
    _draggableController.addListener(_onExtentChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isReady = true;
      });
      _animationController.forward();
      fetchCurrentAddress();
    });
  }

  void _onExtentChanged() {
    if (!_draggableController.isAttached) return;

    setState(() {});

    _snapTimer?.cancel();

    _snapTimer = Timer(const Duration(milliseconds: 150), () {
      if (!_draggableController.isAttached) return;

      final current = _draggableController.size;
      final target = (current < 0.6) ? 0.3 : 0.9;

      _draggableController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<String?> getAddressFromLatLng(LatLng latLng) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}',
    );

    final response = await http.get(
      url,
      headers: {
        'User-Agent':
            'ecarrgo-app/1.0 (https://ecarrgo.com; ferdiansyahmuh5@gmail.com)',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getFullAddressFromLatLng(LatLng latlng) async {
    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${latlng.latitude}&lon=${latlng.longitude}&addressdetails=1',
    );

    try {
      await Future.delayed(Duration(seconds: 3)); // Rate limit
      final response = await http.get(
        url,
        headers: {
          'User-Agent':
              'ecarrgo-app/1.0 (https://ecarrgo.com; ferdiansyahmuh5@gmail.com)',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print('Error status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception reverse geocoding: $e');
      return null;
    }
  }

  void _navigateToFillData() async {
    if (_pickupLatLng == null || _destinationLatLng == null) {
      logger.e('⛔ Lokasi pickup atau tujuan belum dipilih');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Pilih lokasi penjemputan dan tujuan terlebih dahulu")),
      );
      return;
    }

    setState(() => isLoading = true); // ⏳ START LOADING

    try {
      final pickupData = await getFullAddressFromLatLng(_pickupLatLng!);
      final destinationData =
          await getFullAddressFromLatLng(_destinationLatLng!);

      if (pickupData == null || destinationData == null) {
        logger.e('⛔ Gagal ambil alamat dari reverse geocoding');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mendapatkan detail lokasi")),
        );
        setState(() => isLoading = false); // ❌ STOP LOADING
        return;
      }

      final pickupLocationData = LocationData(
        address: pickupData['display_name'] ?? '',
        latitude: _pickupLatLng!.latitude,
        longitude: _pickupLatLng!.longitude,
        placeName: pickupData['name'],
        detail: null,
        city: pickupData['address']?['city'] ??
            pickupData['address']?['town'] ??
            pickupData['address']?['village'] ??
            '',
        postalCode: pickupData['address']?['postcode'] ?? '',
        country: pickupData['address']?['country'] ?? '',
      );

      final destinationLocationData = LocationData(
        address: destinationData['display_name'] ?? '',
        latitude: _destinationLatLng!.latitude,
        longitude: _destinationLatLng!.longitude,
        placeName: destinationData['name'],
        detail: null,
        city: destinationData['address']?['city'] ??
            destinationData['address']?['town'] ??
            destinationData['address']?['village'] ??
            '',
        postalCode: destinationData['address']?['postcode'] ?? '',
        country: destinationData['address']?['country'] ?? '',
      );

      setState(() => isLoading = false); // ✅ STOP LOADING

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FillDataPage(
            pickup: pickupLocationData,
            destination: destinationLocationData,
          ),
        ),
      );
    } catch (e, stackTrace) {
      logger.e('❌ Exception saat ambil data lokasi: $e',
          error: e, stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat mengambil lokasi")),
      );
      setState(() => isLoading = false); // ❌ STOP LOADING
    }
  }

  Future<void> fetchCurrentAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logger.e('Layanan lokasi tidak aktif');
      return;
    }

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

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() => isLoading = true); // ⏳ START LOADING

    final latLng = LatLng(position.latitude, position.longitude);
    final address = await getAddressFromLatLng(latLng);

    if (address != null && mounted) {
      setState(() {
        _pickupLatLng = latLng;
        _pickupLocation = address;
      });
    }

    setState(() => isLoading = false); // ✅ STOP LOADING
  }

  Future<void> searchDestination(String query) async {
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        searchResults = [];
      });
      return;
    }

    if (!mounted) return;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'ecarrgoApp/1.0'},
      );

      if (response.statusCode == 200) {
        final results = json.decode(response.body) as List;
        if (!mounted) return;
        setState(() {
          searchResults = results; // hasil dibatasi max 5 sesuai limit
        });
      } else {
        if (!mounted) return;
        setState(() {
          searchResults = [];
        });
        logger.e('Error response: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        searchResults = [];
      });
      logger.e('Gagal mencari tujuan: $e');
    }
  }

  void _updateLocations({
    String? pickupAddress,
    LatLng? pickupLatLng,
    String? destinationAddress,
    LatLng? destinationLatLng,
  }) {
    setState(() {
      if (pickupAddress != null) _pickupLocation = pickupAddress;
      if (pickupLatLng != null) _pickupLatLng = pickupLatLng;
      if (destinationLatLng != null) _destinationLatLng = destinationLatLng;
    });
  }

  void _focusPickupAndDestination() {
    setState(() {
      _mapFocusMode = MapFocusMode.pickupAndDestination;
    });
  }

  void _onConfirmLocation() {
    if (_isDialogOpen) return;
    _isDialogOpen = true;

    // 1. Ubah mode fokus map dan sembunyikan sheet terlebih dahulu
    setState(() {
      _mapFocusMode = MapFocusMode.pickupOnly;
      _showDraggableSheet = false;
      _isDialogActive = true;
    });

    // 2. Delay sebentar agar MapSection bisa rebuild dan pindah fokus
    Future.delayed(const Duration(milliseconds: 150), () {
      final AnimationController dialogAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );

      dialogAnimationController.forward();

      showGeneralDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: dialogAnimationController,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height - 250 - 120,
                    left: 16,
                    child: SafeArea(
                      child: BackButtonWidget(
                        onPressed: _backFromFirstDialog,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Material(
                          color: Colors.white,
                          child: SizedBox(
                            height: 250,
                            child: ConfirmPickupDialog(
                              alamatLengkap:
                                  _pickupLocation ?? 'Alamat tidak ditemukan',
                              onConfirmed: () async {
                                await dialogAnimationController.reverse();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  _showPickupDestinationDialog();
                                  _focusPickupAndDestination();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).whenComplete(() {
        _isDialogOpen = false;
        dialogAnimationController.dispose();
      });
    });
  }

  Future<void> _showPickupDestinationDialog() async {
    String destinationAddress = 'Alamat tujuan tidak ditemukan';
    setState(() => _isDialogActive = true);

    if (_destinationLatLng != null) {
      final address = await getAddressFromLatLng(_destinationLatLng!);
      if (address != null) destinationAddress = address;
    }

    final AnimationController dialogAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    dialogAnimationController.forward();

    final rootContext = context;

    showGeneralDialog(
      // ignore: use_build_context_synchronously
      context: rootContext,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: dialogAnimationController,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                // Tombol Back di luar dialog
                Positioned(
                  top: MediaQuery.of(context).size.height - 300 - 75,
                  left: 16,
                  child: SafeArea(
                    child: BackButtonWidget(
                      onPressed: () {
                        _backFromSecondDialog();
                      },
                    ),
                  ),
                ),
                // Dialog putih
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        color: Colors.white,
                        child: IntrinsicHeight(
                          child: PickupDestinationDialog(
                            pickupAddress: _pickupLocation ??
                                'Alamat jemput tidak ditemukan',
                            destinationAddress: destinationAddress,
                            onEditPickup: () async {
                              final navigator =
                                  Navigator.of(context); // Simpan dulu
                              await dialogAnimationController.reverse();
                              if (!mounted) return;
                              navigator.pop();
                              setState(() {
                                _showDraggableSheet = true;
                              });
                            },
                            onEditDestination: () async {
                              final navigator =
                                  Navigator.of(context); // Simpan dulu
                              await dialogAnimationController.reverse();
                              if (!mounted) return;
                              navigator.pop();
                              setState(() {
                                _showDraggableSheet = true;
                              });
                            },
                            onConfirmed: () async {
                              final navigator =
                                  Navigator.of(context, rootNavigator: true);
                              final messenger = ScaffoldMessenger.of(context);

                              await dialogAnimationController.reverse();
                              if (!mounted) return;
                              navigator.pop();

                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                if (!mounted) return;

                                if (_pickupLocation == null ||
                                    _destinationLatLng == null) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Lokasi jemput dan tujuan harus dipilih terlebih dahulu'),
                                    ),
                                  );
                                  return;
                                }

                                _navigateToFillData();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      dialogAnimationController.dispose();
    });
  }

  void _backFromFirstDialog() {
    Navigator.of(context).pop(); // tutup dialog pertama
    setState(() {
      _showDraggableSheet = true; // munculkan DraggableScrollableSheet lagi
      _isDialogActive = false;
    });
  }

  Future<void> _backFromSecondDialog() async {
    Navigator.of(context).pop(); // tutup dialog kedua
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _onConfirmLocation(); // buka dialog pertama lagi
  }

  void _openMapSectionForPickup() {
    setState(() {
      _mapFocusMode = MapFocusMode.pickupOnly; // Fokus pada lokasi pickup
      _showDraggableSheet = false; // Sembunyikan DraggableScrollableSheet
    });
  }

  void _confirmPickupLocation() {
    setState(() {
      _showDraggableSheet = true; // Tampilkan kembali DraggableScrollableSheet
      _mapFocusMode = MapFocusMode.none; // Reset mode fokus peta
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _snapTimer?.cancel();
    _animationController.dispose();
    _draggableController.removeListener(_onExtentChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          MapSection(
            mapController: _mapController,
            currentLatLng: _pickupLatLng,
            destinationLatLng: _destinationLatLng,
            onMapReady: () {},
            focusMode: _mapFocusMode,
            // onPickupLocationChanged: (LatLng newLatLng) async {
            //   final address = await getAddressFromLatLng(newLatLng);
            //   if (mounted) {
            //     setState(() {
            //       _pickupLatLng = newLatLng;
            //       _pickupLocation = address;
            //     });
            //   }
            // },
          ),

          // Back Button di pojok kiri atas layar
          if (!_isDialogActive && _showDraggableSheet)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              child: SafeArea(
                child: BackButtonWidget(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),

          if (_showDraggableSheet)
            DraggableScrollableSheet(
              controller: _draggableController,
              initialChildSize: 0.9,
              minChildSize: 0.9,
              maxChildSize: _maxChildSize,
              builder: (context, scrollController) {
                return SafeArea(
                  bottom: true,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 12.0,
                      bottom: 16.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        color: Colors.white,
                        elevation: 2,
                        child: DraggableSheetContent(
                          scrollController: scrollController,
                          pickupLocation: _pickupLocation,
                          onConfirmLocation: _onConfirmLocation,
                          onPickFromMap: _openMapSectionForPickup,
                          onLocationUpdated: _updateLocations,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
