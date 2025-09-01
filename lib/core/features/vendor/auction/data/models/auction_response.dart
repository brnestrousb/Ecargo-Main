import 'dart:convert';
import 'auction_model_vendor.dart';

AuctionResponse auctionResponseFromJson(String str) =>
    AuctionResponse.fromJson(json.decode(str));

String auctionResponseToJson(AuctionResponse data) =>
    json.encode(data.toJson());

class AuctionResponse {
  final int statusCode;
  final bool success;
  final String message;
  final Auction data;

  AuctionResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuctionResponse.fromJson(Map<String, dynamic> json) {
    return AuctionResponse(
      statusCode: json["statusCode"] ?? 0,
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: Auction.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}
