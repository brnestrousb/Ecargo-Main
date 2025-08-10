import 'package:ecarrgo/core/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:ecarrgo/core/model/user_role.dart';
import 'package:flutter/material.dart';
import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/register_as/presentation/widgets/role_description_card.dart';
import 'package:ecarrgo/core/widgets/language_toggle_button.dart';

class RegisterAsScreen extends StatefulWidget {
  final UserRole? role;
  final Function(Locale) setLocale;

  const RegisterAsScreen({
    super.key,
    required this.setLocale,
    this.role,
  });

  @override
  State<RegisterAsScreen> createState() => _RegisterAsScreenState();
}

class _RegisterAsScreenState extends State<RegisterAsScreen> {
  UserRole? selectedRole;

  final List<Map<String, String>> vendorSteps = [
    {
      'icon': 'assets/images/logo/vendor/daftar_icon.png',
      'title': 'Daftar Dengan Mudah',
      'description':
          'Bergabung sebagai vendor hanya membutuhkan beberapa langkah sederhana. Lengkapi informasi dasar, unggah dokumen yang dibutuhkan, dan mulai berjualan tanpa ribet.',
    },
    {
      'icon': 'assets/images/logo/vendor/dukungan_icon.png',
      'title': 'Jangkau Lebih Banyak Pelanggan',
      'description':
          'Tingkatkan visibilitas bisnis Anda dengan menjangkau ribuan pelanggan aktif melalui platform ECarrgo. Setiap hari adalah peluang baru untuk mendapatkan order.',
    },
    {
      'icon': 'assets/images/logo/vendor/jangkau_icon.png',
      'title': 'Pantau Penghasilan Anda',
      'description':
          'Nikmati berbagai fasilitas seperti sistem pelacakan canggih, dukungan customer service yang responsif, dan pelatihan untuk meningkatkan layanan Anda sebagai vendor.',
    },
  ];

  final List<Map<String, String>> senderSteps = [
    {
      'icon': 'assets/images/logo/pengirim/kirim_icon.png',
      'title': 'Kirim Barang dengan Lebih Cepat',
      'description':
          'Bergabung sebagai vendor hanya membutuhkan beberapa langkah sederhana. Lengkapi informasi dasar, unggah dokumen yang dibutuhkan, dan mulai berjualan tanpa ribet.',
    },
    {
      'icon': 'assets/images/logo/pengirim/layanan_icon.png',
      'title': 'Pantau Pengiriman Secara Real-Time',
      'description':
          'Tingkatkan visibilitas bisnis Anda dengan menjangkau ribuan pelanggan aktif melalui platform ECarrgo. Setiap hari adalah peluang baru untuk mendapatkan order.',
    },
    {
      'icon': 'assets/images/logo/pengirim/pantau_icon.png',
      'title': 'Layanan yang Transparan dan Terpercaya',
      'description':
          'Nikmati berbagai fasilitas seperti sistem pelacakan canggih, dukungan customer service yang responsif, dan pelatihan untuk meningkatkan layanan Anda sebagai vendor.',
    },
  ];

  List<Map<String, String>> getStepsByRole(UserRole role) {
    return role == UserRole.vendor ? vendorSteps : senderSteps;
  }

  void handleSelection(UserRole role) {
    setState(() {
      selectedRole = role;
    });
  }

  void handleContinue() {
    if (selectedRole == UserRole.vendor) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(
            role: UserRole.vendor,
          ),
        ),
      );
    } else if (selectedRole == UserRole.customer) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(
            role: UserRole.customer,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 170,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
              const SizedBox(width: 4),
              Image.asset(
                'assets/images/logo.png',
                width: 108,
                height: 14,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LanguageToggleButton(
              currentLocale: Localizations.localeOf(context),
              onLocaleChanged: (newLocale) {
                widget.setLocale(newLocale);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 50),
                children: [
                  Center(
                    child: Text(
                      'Daftar Sebagai?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => handleSelection(UserRole.vendor),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite2,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedRole == UserRole.vendor
                                    ? AppColors.darkBlue
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/logo/driver.png',
                                        width: 32,
                                        height: 32,
                                        color:
                                            null, // Hapus warna abu jika sudah aktif
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Vendor Logistik',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  selectedRole == UserRole.vendor
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => handleSelection(UserRole.customer),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite2,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedRole == UserRole.customer
                                    ? AppColors.darkBlue
                                    : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        'assets/images/logo/customer.png',
                                        width: 32,
                                        height: 32,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Pengirim',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  selectedRole == UserRole.customer
                                      ? Icons.expand_less // ke atas
                                      : Icons.expand_more, // ke bawah
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (selectedRole != null) ...[
                    const SizedBox(height: 10),
                    Column(
                      children: getStepsByRole(selectedRole!)
                          .map(
                            (step) => RoleDescriptionCard(
                              iconPath: step['icon']!,
                              title: step['title']!,
                              description: step['description']!,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            if (selectedRole == UserRole.vendor)
              SafeArea(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Jadi Vendor Sekarang',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (selectedRole == UserRole.customer)
              SafeArea(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Jadi Pengirim Sekarang',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
