import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/model/shipping_package_model.dart';

const List<ShippingPackageModel> shippingPackages = [
  ShippingPackageModel(
    id: 'Reguler',
    title: 'Dalam Kota (Reguler)',
    method: 'Darat',
    description: 'Pengiriman standar dalam kota.',
    timeEstimate: '2 - 3 Hari',
    priceEstimate: 'Rp 50.000',
    iconPath: 'assets/images/icons/dalam_kota_icon.svg',
  ),
  ShippingPackageModel(
    id: 'Ekspres',
    title: 'Dalam Kota (Ekspres)',
    method: 'Udara',
    description: 'Pengiriman cepat melalui jalur udara.',
    timeEstimate: '1 Hari',
    priceEstimate: 'Rp 100.000',
    iconPath: 'assets/images/icons/luar_kota_icon.svg',
  ),
  ShippingPackageModel(
    id: 'Hemat',
    title: 'Dalam Kota (Hemat)',
    method: 'Udara',
    description: 'Pengiriman cepat melalui jalur udara.',
    timeEstimate: '1 Hari',
    priceEstimate: 'Rp 100.000',
    iconPath: 'assets/images/icons/luar_kota_icon.svg',
  ),
];
