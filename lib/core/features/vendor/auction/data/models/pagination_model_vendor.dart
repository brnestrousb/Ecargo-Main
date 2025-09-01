class PaginationVendorModel {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PaginationVendorModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PaginationVendorModel.fromJson(Map<String, dynamic> json) {
    return PaginationVendorModel(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        "page": page,
        "limit": limit,
        "total": total,
        "totalPages": totalPages,
      };
}
