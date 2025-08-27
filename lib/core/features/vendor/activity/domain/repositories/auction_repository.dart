import 'package:ecarrgo/core/features/customer/activity/data/models/auction_model.dart';

abstract class AuctionRepository {
  Future<List<AuctionModel>> getMyAuctions();
}
