import 'package:dio/dio.dart';
import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/other/data/datasources/users_remote_datasource.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/widgets/profile_card.dart';
import 'package:ecarrgo/core/network/api_constants.dart';
import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  final logger = Logger();
  final SecureStorageService storageService = SecureStorageService();

  // Buat instance UsersRemoteDataSource dengan baseUrl /api/v1
  late final UsersRemoteDataSource usersRemoteDataSource =
      UsersRemoteDataSourceImpl(
    Dio(BaseOptions(
      baseUrl: '${ApiConstants.baseUrl}/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    )),
  );

  String name = '-';
  String email = '-';
  String phone = '-';
  bool isVerified = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final accessToken = await storageService.getToken();

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      final response =
          await usersRemoteDataSource.getProfile(accessToken: accessToken);

      final data = response.data['data'];
      logger.i(data);
      setState(() {
        name = data['name'] ?? '-';
        email = data['email'] ?? '-';
        phone = data['phone_number'] ?? '083943795393533';
        isVerified = data['is_verified'] ?? false;
        isLoading = false;
      });
    } catch (e) {
      logger.e('❌ Failed to fetch profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          children: [
            ProfileCard(
              name: name,
              role: 'Customer',
              email: email,
              phone: phone,
              isVerified: isVerified,
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Akun',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            _buildMenuItem(
                'assets/images/icons/be_vendor_icon.svg', 'Jadi Vendor', () {}),
            _buildMenuItem(
                'assets/images/icons/address_icon.svg', 'Alamat Saya', () {}),
            _buildMenuItem('assets/images/icons/help_icon.svg', 'Bantuan', () {
              Navigator.pushNamed(context, '/help');
            }),
            _buildMenuItem(
                'assets/images/icons/language_icon.svg', 'Bahasa', () {}),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Info Lainnya',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            _buildMenuItem('assets/images/icons/policies_and_privacy_icon.svg',
                'Kebijakan & Privasi', () {}),
            _buildMenuItem('assets/images/icons/terms_of_service_icon.svg',
                'Ketentuan Layanan', () {}),
            _buildMenuItem('assets/images/icons/data_attribution_icon.svg',
                'Atribusi Data', () {}),
            _buildMenuItem(
                'assets/images/icons/rating_icon.svg', 'Beri Rating', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String svgPath, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: SvgPicture.asset(
              svgPath,
              width: 24,
              height: 24,
            ),
            title: Text(title),
            onTap: onTap,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 36),
            child: Divider(
              height: 0.8,
              color: AppColors.lightGrayBlue,
            ),
          ),
        ],
      ),
    );
  }
}
