import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/model/map_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

class MapSection extends StatefulWidget {
  final MapController mapController;
  final LatLng? currentLatLng;
  final LatLng? destinationLatLng;
  final VoidCallback onMapReady;
  final MapFocusMode focusMode;
  // final Function(LatLng) onPickupLocationChanged;

  const MapSection({
    super.key,
    required this.mapController,
    required this.currentLatLng,
    required this.destinationLatLng,
    required this.onMapReady,
    required this.focusMode,
    // required this.onPickupLocationChanged,
  });

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  @override
  void didUpdateWidget(covariant MapSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusMode != oldWidget.focusMode ||
        widget.currentLatLng != oldWidget.currentLatLng ||
        widget.destinationLatLng != oldWidget.destinationLatLng) {
      _fitCamera();
    }
  }

  void _fitCamera() {
    const bottomPadding = 200.0;
    final pickup = widget.currentLatLng;
    final destination = widget.destinationLatLng;

    if (widget.focusMode == MapFocusMode.pickupAndDestination &&
        pickup != null &&
        destination != null) {
      final bounds = LatLngBounds.fromPoints([pickup, destination]);
      Future.delayed(const Duration(milliseconds: 100), () {
        widget.mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds, // pastikan ini named parameter 'bounds'
            padding: EdgeInsets.only(
              left: 80,
              top: 80,
              right: 80,
              bottom: bottomPadding,
            ),
          ),
        );
      });
    } else if (widget.focusMode == MapFocusMode.pickupOnly && pickup != null) {
      final adjusted = LatLng(pickup.latitude + 0.002, pickup.longitude);
      widget.mapController.move(adjusted, 15);
    } else if (widget.focusMode == MapFocusMode.destinationOnly &&
        destination != null) {
      final adjusted =
          LatLng(destination.latitude + 0.002, destination.longitude);
      widget.mapController.move(adjusted, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(
        initialCameraFit:
            (widget.currentLatLng != null && widget.destinationLatLng != null)
                ? CameraFit.bounds(
                    bounds: LatLngBounds(
                      widget.currentLatLng!,
                      widget.destinationLatLng!,
                    ),
                    padding: const EdgeInsets.all(40),
                  )
                : null,
        onMapReady: () {
          widget.onMapReady();
          _fitCamera();
        },
        // onPositionChanged: (position, hasGesture) {
        //   if (hasGesture) {
        //     // Perbarui lokasi pickup berdasarkan posisi kamera
        //     final center = widget.mapController.center;
        //     widget.onPickupLocationChanged(center);
        //   }
        // },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.ecarrgo',
        ),
        MarkerLayer(
          markers: [
            if (widget.currentLatLng != null)
              Marker(
                point: widget.currentLatLng!,
                width: 100,
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            // Ganti withOpacity ke withValues
                            color: Colors.black.withValues(
                              alpha: 0.2,
                              red: 0,
                              green: 0,
                              blue: 0,
                            ),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Lokasi Anda',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SvgPicture.asset(
                      'assets/images/icons/map_pin_icon.svg',
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
            if (widget.destinationLatLng != null)
              Marker(
                point: widget.destinationLatLng!,
                width: 100,
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.2,
                              red: 0,
                              green: 0,
                              blue: 0,
                            ),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Tujuan',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SvgPicture.asset(
                      'assets/images/icons/destination_pin_icon.svg',
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
          ],
        ),
        // Ikon pickup di tengah peta
        // Center(
        //   child: IgnorePointer(
        //     child: SvgPicture.asset(
        //       'assets/images/icons/map_pin_icon.svg',
        //       width: 40,
        //       height: 40,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
