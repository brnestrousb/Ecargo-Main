import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:latlong2/latlong.dart' as latlng;
import 'package:flutter/material.dart';
import '../../../model/auction/auction_model.dart';

class MapAuctionService {
  /// Dummy Auction Detail untuk preview
  Future<AuctionDetail> fetchAuctionDetail() async {
  await Future.delayed(const Duration(seconds: 1)); // simulasi delay API
  return AuctionDetail(
      customerName: "Budi Angga",
      modelDelivery: "Pengiriman Regular",
      minBid: 2125000, // Rp. 2.125.000
      deliveryType: "Reguler",
      distance: "230 Km",
      weight: "120 Kg",
      category: "Makanan",
    pickupAddress: "Jl. Kemandoran VII No.22",
    destinationAddress: "Binus University, Anggrek Campus",
      note: "-",
      deliveryDate: DateTime(2025, 6, 24), // 24 Juni 2025
      deliveryTime: "08:00",
      itemWeight: 20.0,
    itemValue: 2000000,
      itemDimension: 30.0,
      itemDescription:
          "Barang pakaian, dimohon untuk tidak terkena air ataupun basah",
      shippingType: "Dalam Kota (Regular)",
      shippingDesc:
          "Instant atau SameDay, waktu lebih cepat dan lebih banyak partisipan lelang.",
      shippingEstimate: "2-3 Hari",
      shippingPrice: 174000,
      protectionType: "Silver Protection",
      protectionPrice: 1000,
      protectionDesc:
          "Sampai dengan Rp. 5.000.000. Cocok untuk barang seperti makanan, buku, atau obat-obatan.",
      totalBids: 12,
    remainingTime: "4j 15m",
      detailPickupAddress:
          "Jl. Kemandoran VII No.22, RT.12/RW.4, Grogol Utara, Kec. Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12210",
      detailDestinationAddress:
          "Jl. Raya Kb. Jeruk No.27, RT.1/RW.9, Kemanggisan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11530",

      // koordinat simulasi Jakarta
    pickupLat: -6.21462,
    pickupLng: 106.78825,
    destinationLat: -6.20157,
    destinationLng: 106.78189,
    userLat: -6.20040,
    userLng: 106.79600,
  );
}


  /// Versi Google Maps (Mobile)
  static Set<gmap.Marker> buildGoogleMarkers(AuctionDetail detail) {
    return {
      gmap.Marker(
        markerId: const gmap.MarkerId("pickup"),
        position: gmap.LatLng(detail.pickupLat, detail.pickupLng),
        infoWindow: gmap.InfoWindow(title: "Penjemputan", snippet: detail.pickupAddress),
      ),
      gmap.Marker(
        markerId: const gmap.MarkerId("destination"),
        position: gmap.LatLng(detail.destinationLat, detail.destinationLng),
        infoWindow: gmap.InfoWindow(title: "Tujuan", snippet: detail.destinationAddress),
      ),
      gmap.Marker(
        markerId: const gmap.MarkerId("user"),
        position: gmap.LatLng(detail.userLat, detail.userLng),
        infoWindow: const gmap.InfoWindow(title: "Lokasi Anda"),
      ),
    };
  }

  static Set<gmap.Polyline> buildGooglePolyline(AuctionDetail detail) {
    return {
      gmap.Polyline(
        polylineId: const gmap.PolylineId("route"),
        color: Colors.blue,
        width: 4,
        points: [
          gmap.LatLng(detail.pickupLat, detail.pickupLng),
          gmap.LatLng(detail.userLat, detail.userLng),
          gmap.LatLng(detail.destinationLat, detail.destinationLng),
        ],
      )
    };
  }

  // Versi Flutter Map (Web)
  static List<fmap.Marker> buildFlutterMarkers(AuctionDetail detail) {
  return [
    fmap.Marker(
      point: latlng.LatLng(detail.pickupLat, detail.pickupLng),
      width: 40,
      height: 40,
      child: SvgPicture.asset('assets/images/vendor/pickup.svg'),
    ),
    fmap.Marker(
      point: latlng.LatLng(detail.destinationLat, detail.destinationLng),
      width: 40,
      height: 40,
      child: SvgPicture.asset('assets/images/vendor/destination.svg'),
    ),
    fmap.Marker(
      point: latlng.LatLng(detail.userLat, detail.userLng),
      width: 40,
      height: 40,
      child: SvgPicture.asset('assets/images/vendor/location.svg'),
    ),
  ];
}


  static List<latlng.LatLng> buildFlutterPolyline(AuctionDetail detail) {
    return [
      latlng.LatLng(detail.pickupLat, detail.pickupLng),
      latlng.LatLng(detail.userLat, detail.userLng),
      latlng.LatLng(detail.destinationLat, detail.destinationLng),
    ];
  }
}
