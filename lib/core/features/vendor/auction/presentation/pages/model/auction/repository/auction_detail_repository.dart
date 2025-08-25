import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auction_model.dart';

class AuctionDetailRepository {
  final String baseUrl;

  AuctionDetailRepository(this.baseUrl);

  Future<AuctionDetail> fetchAuctionDetail(int auctionId) async {
    final response = await http.get(Uri.parse('$baseUrl/auction/$auctionId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AuctionDetail.fromJson(data);
    } else {
      throw Exception('Failed to load auction detail');
    }
  }
}
