import 'package:ecarrgo/core/features/vendor/auction/widgets/pages/auction_detail_page.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/pages/auction_full_map_page.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/service/map_auction_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:latlong2/latlong.dart' as latlng;
import '../../data/models/auction_model.dart';

class AuctionMapPage extends StatelessWidget {
  final AuctionDetail detail;

  const AuctionMapPage({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Kondisi web vs mobile
          kIsWeb ? _buildFlutterMap() : _buildGoogleMap(),

          // Card info alamat
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tombol Back dengan SafeArea
              SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(16), // jarak dari pojok
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black, size: 20),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuctionDetailPage()));
                    },
                  ),
                ),
              ),

              // Bagian bawah (card alamat)
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildAddressCard(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Google Maps (Mobile)
  Widget _buildGoogleMap() {
    final pickupLatLng = gmap.LatLng(detail.pickupLat, detail.pickupLng);
    return gmap.GoogleMap(
      initialCameraPosition:
          gmap.CameraPosition(target: pickupLatLng, zoom: 13),
      markers: MapAuctionService.buildGoogleMarkers(detail),
      polylines: MapAuctionService.buildGooglePolyline(detail),
    );
  }

  /// Flutter Map (Web)
  Widget _buildFlutterMap() {
    return fmap.FlutterMap(
      options: fmap.MapOptions(
        initialCenter: latlng.LatLng(detail.pickupLat, detail.pickupLng),
        initialZoom: 13,
      ),
      children: [
        fmap.TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        fmap.PolylineLayer(
          polylines: [
            fmap.Polyline(
              points: MapAuctionService.buildFlutterPolyline(detail),
              strokeWidth: 4,
              color: Colors.blue,
            )
          ],
        ),
        fmap.MarkerLayer(
            markers: MapAuctionService.buildFlutterMarkers(detail)),
      ],
    );
  }

  /// Card alamat
  Widget _buildAddressCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF6F8F9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAddress(
              "Lokasi Anda", "Jl. Kemanggisan II No. 43", Colors.green),
          _buildAddress(
              "Alamat Penjemputan", detail.pickupAddress, Colors.blue),
          _buildAddress(
              "Alamat Tujuan", detail.destinationAddress, Colors.orange,
              isLast: true),
          const SizedBox(height: 12),

          // Tombol Lanjut
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AuctionMapFullPage(detail: detail)));
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: const Color(0xFF01518D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Lanjut", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress(String label, String address, Color color,
      {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bagian Icon + Garis Vertikal
        Column(
          children: [
            Icon(
              label == "Lokasi Anda"
                  ? Icons.flag
                  : label == "Alamat Tujuan"
                      ? Icons.location_on
                      : Icons.flag,
              color: color,
            ),
            if (!isLast)
              Container(
                height: 40,
                width: 2,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),

        // Bagian Teks
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                label: Text(label),
                // ignore: deprecated_member_use
                backgroundColor: color.withOpacity(0.1),
                labelStyle: TextStyle(
                    color: color, fontWeight: FontWeight.w600, fontSize: 10),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (!isLast) const Divider(),
            ],
          ),
        ),
      ],
    );
  }
}
