import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/presentation/auction/page/auction_map_page.dart';
import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/presentation/auction/service/map_auction_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:latlong2/latlong.dart' as latlng;
import '../../../model/auction/auction_model.dart';

class AuctionMapFullPage extends StatelessWidget {
  final AuctionDetail detail;

  const AuctionMapFullPage({super.key, required this.detail});

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
                              builder: (context) =>
                                  AuctionMapPage(detail: detail)));
                    },
                  ),
                ),
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
}
