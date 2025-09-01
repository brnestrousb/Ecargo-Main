class Review {
  final int? id; 
  final int? shipmentId;
  final int? userId;
  final String? comment;
  final int? rating;

  Review({
    this.id,
    this.shipmentId,
    this.userId,
    this.comment,
    this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      shipmentId: json['shipment_id'],
      userId: json['user_id'],
      comment: json['comment'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shipment_id': shipmentId,
      'user_id': userId,
      'comment': comment,
      'rating': rating,
    };
  }
}
