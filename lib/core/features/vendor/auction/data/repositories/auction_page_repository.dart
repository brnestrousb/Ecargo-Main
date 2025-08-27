// lib/core/features/vendor/other/repositories/auction_repository.dart
import 'dart:convert';
import 'package:ecarrgo/core/features/vendor/auction/data/models/auction_model.dart';
//import 'package:ecarrgo/core/features/vendor/auction/presentation/pages/model/auction/auction_page_model.dart';
import 'package:http/http.dart' as http;

class AuctionRepository {
  final String? baseUrl;

  AuctionRepository({this.baseUrl});

  Future<List<AuctionDetail>> fetchAuctions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/auctions'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Pastikan body adalah list
        if (body is List) {
          return body
              .map((json) => AuctionDetail.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception("Data dari server bukan berupa List");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } on http.ClientException {
      throw Exception("Tidak dapat terhubung ke server. Periksa koneksi internet Anda.");
    } on FormatException {
      throw Exception("Data dari server tidak sesuai format JSON.");
    } catch (e) {
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
