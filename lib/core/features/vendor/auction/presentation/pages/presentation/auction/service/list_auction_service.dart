import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/model/auction/auction_model.dart';

class AuctionListService {
  /// Dummy list penawaran lelang
  static Future<List<AuctionDetail>> fetchAuctionList() async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi delay API
    
    return [
      AuctionDetail(
        customerName: "PT. Cahaya Nur Abadi",
        modelDelivery: "Reguler",
        minBid: 2125000,
        deliveryType: "Reguler",
        distance: "230 Km",
        weight: "120 Kg",
        category: "Makanan",
        pickupAddress: "Jl. Kemandoran VII No.22",
        destinationAddress: "Binus University, Anggrek Campus",
        note: "-",
        deliveryDate: DateTime(2025, 6, 18),
        deliveryTime: "14:02",
        itemWeight: 120.0,
        itemValue: 2000000,
        itemDimension: 30,
        itemDescription:
            "Barang pakaian, dimohon untuk tidak terkena air ataupun basah",
        shippingType: "Dalam Kota (Reguler)",
        shippingDesc:
            "Instan atau SameDay, waktu lebih cepat dan banyak partisipan lelang",
        shippingEstimate: "2–3 Hari",
        shippingPrice: 174000,
        protectionType: "Silver Protection",
        protectionPrice: 1000,
        protectionDesc:
            "Sampai dengan Rp. 5.000.000. Cocok untuk barang seperti makanan, buku, obat-obatan.",
        totalBids: 12,
        remainingTime: "4j 15m",
        detailPickupAddress:
            "Jl. Kemandoran VII No.22, RT.12/RW.4, Jakarta Selatan",
        detailDestinationAddress: "Jl. Raya Kb. Jeruk No.27, Jakarta Barat",
        pickupLat: -6.21462,
        pickupLng: 106.78825,
        destinationLat: -6.20157,
        destinationLng: 106.78189,
        userLat: -6.20040,
        userLng: 106.79600,
      ),
      AuctionDetail(
        customerName: "Komunitas Transport Nusantara",
        modelDelivery: "Reguler",
        minBid: 2125000,
        deliveryType: "Reguler",
        distance: "230 Km",
        weight: "120 Kg",
        category: "Makanan",
        pickupAddress: "Jl. Kemandoran VII No.22",
        destinationAddress: "Binus University, Anggrek Campus",
        note: "-",
        deliveryDate: DateTime(2025, 6, 18),
        deliveryTime: "14:02",
        itemWeight: 120.0,
        itemValue: 2000000,
        itemDimension: 30,
        itemDescription:
            "Barang pakaian, dimohon untuk tidak terkena air ataupun basah",
        shippingType: "Dalam Kota (Reguler)",
        shippingDesc:
            "Instan atau SameDay, waktu lebih cepat dan banyak partisipan lelang",
        shippingEstimate: "2–3 Hari",
        shippingPrice: 174000,
        protectionType: "Silver Protection",
        protectionPrice: 1000,
        protectionDesc:
            "Sampai dengan Rp. 5.000.000. Cocok untuk barang seperti makanan, buku, obat-obatan.",
        totalBids: 12,
        remainingTime: "4j 15m",
        detailPickupAddress:
            "Jl. Kemandoran VII No.22, RT.12/RW.4, Jakarta Selatan",
        detailDestinationAddress: "Jl. Raya Kb. Jeruk No.27, Jakarta Barat",
        pickupLat: -6.21462,
        pickupLng: 106.78825,
        destinationLat: -6.20157,
        destinationLng: 106.78189,
        userLat: -6.20040,
        userLng: 106.79600,
      ),
      AuctionDetail(
        customerName: "Fuad Maulana",
        modelDelivery: "Reguler",
        minBid: 2000000,
        deliveryType: "Reguler",
        distance: "230 Km",
        weight: "100 Kg",
        category: "Makanan",
        pickupAddress: "Jl. Kemandoran VII No.22",
        destinationAddress: "Binus University, Anggrek Campus",
        note: "-",
        deliveryDate: DateTime(2025, 6, 18),
        deliveryTime: "14:02",
        itemWeight: 100.0,
        itemValue: 1500000,
        itemDimension: 20,
        itemDescription:
            "Barang pakaian, dimohon untuk tidak terkena air ataupun basah",
        shippingType: "Dalam Kota (Reguler)",
        shippingDesc:
            "Instan atau SameDay, waktu lebih cepat dan banyak partisipan lelang",
        shippingEstimate: "2–3 Hari",
        shippingPrice: 150000,
        protectionType: "Silver Protection",
        protectionPrice: 1000,
        protectionDesc:
            "Sampai dengan Rp. 5.000.000. Cocok untuk barang seperti makanan, buku, obat-obatan.",
        totalBids: 12,
        remainingTime: "4j 15m",
        detailPickupAddress:
            "Jl. Kemandoran VII No.22, RT.12/RW.4, Jakarta Selatan",
        detailDestinationAddress: "Jl. Raya Kb. Jeruk No.27, Jakarta Barat",
        pickupLat: -6.21462,
        pickupLng: 106.78825,
        destinationLat: -6.20157,
        destinationLng: 106.78189,
        userLat: -6.20040,
        userLng: 106.79600,
      ),
    ];
  }
}
