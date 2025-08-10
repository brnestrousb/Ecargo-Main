import 'package:flutter/material.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/model/protection_option_model.dart';
import 'package:ecarrgo/core/constant/colors.dart'; // ganti sesuai path AppColors kamu

final List<ProtectionOption> protectionOptions = [
  ProtectionOption(
    name: 'Silver Protection',
    price: 'Rp 10.000',
    description:
        'Sampai dengan Rp. 50.000.000. Cocok untuk barang seperti makanan, buku, atau obat-obatan.',
    icon: 'assets/images/icons/protection/silver_protection_icon.svg',
    color: Colors.grey,
  ),
  ProtectionOption(
    name: 'Blue Protection',
    price: 'Rp 20.000',
    description:
        'Sampai dengan Rp. 100.000.000. Cocok untuk barang seperti makanan, buku, atau obat-obatan.',
    icon: 'assets/images/icons/protection/blue_protection_icon.svg',
    color: AppColors.darkBlue,
  ),
  ProtectionOption(
    name: 'Gold Protection',
    price: 'Rp 35.000',
    description:
        'Sampai dengan Rp. 200.000.000. Cocok untuk barang seperti makanan, buku, atau obat-obatan.',
    icon: 'assets/images/icons/protection/gold_protection_icon.svg',
    color: Colors.deepPurple,
  ),
];
