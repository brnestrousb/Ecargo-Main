import 'dart:async';
import 'package:ecarrgo/core/features/vendor/auction/data/models/offer_model.dart';

class OfferAuctionService {
  // Dummy data
  static Future<List<OfferModel>> fetchOffers() async {
    await Future.delayed(const Duration(seconds: 1)); // simulasi loading

    return [
      OfferModel(
        id: "1",
        driverName: "ADI NUGROHO",
        vehicleName: "Colt Diesel 2014",
        plateNumber: "Z 2394 SAO",
        maxCapacity: 2.0,
        maxVolume: 49,
        vendorLevel: "Silver",
      ),
      OfferModel(
        id: "2",
        driverName: "CAHYO",
        vehicleName: "Hino 2018",
        plateNumber: "D 2391 BG",
        maxCapacity: 3.0,
        maxVolume: 60,
        vendorLevel: "Gold",
      ),
      OfferModel(
        id: "3",
        driverName: "HIDAYAT",
        vehicleName: "Fuso 2020",
        plateNumber: "D 3291 HA",
        maxCapacity: 2.0,
        maxVolume: 49,
        vendorLevel: "Platinum",
      ),
    ];
  }
}
