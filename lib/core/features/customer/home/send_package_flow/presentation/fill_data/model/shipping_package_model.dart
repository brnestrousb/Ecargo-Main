class ShippingPackageModel {
  final String id;
  final String title;
  final String method;
  final String description;
  final String timeEstimate;
  final String priceEstimate;
  final String iconPath;

  const ShippingPackageModel({
    required this.id,
    required this.title,
    required this.method,
    required this.description,
    required this.timeEstimate,
    required this.priceEstimate,
    required this.iconPath,
  });
}
