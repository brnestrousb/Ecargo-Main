import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:ecarrgo/core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecarrgo/core/features/auth/presentation/widgets/signup_form.dart';
import 'package:ecarrgo/core/model/user_role.dart';
import 'package:ecarrgo/main_vendor.dart';
import 'package:flutter/material.dart';
import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/providers/locale_provider.dart';
import 'package:ecarrgo/core/widgets/language_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:ecarrgo/core/network/api_constants.dart';

class SignUpScreen extends StatefulWidget {
  final UserRole role;

  const SignUpScreen({
    super.key,
    required this.role,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AuthRemoteDataSource authRemoteDataSource;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController businessLicenseController =
      TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();
  final TextEditingController companyAddressController =
      TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    authRemoteDataSource = AuthRemoteDataSourceImpl(Dio(BaseOptions(
      baseUrl: '${ApiConstants.baseUrl}/api/v1',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    )));
  }

  void handleSignUp() {
    if (widget.role == UserRole.vendor) {
      // Langsung lanjut ke halaman vendor tanpa validasi dan API call
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VendorNavigation(),
        ),
      );
      return;
    }

    // Untuk customer, lakukan validasi dan panggilan API
    if (_formKey.currentState?.validate() ?? false) {
      if (!agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus menyetujui syarat dan ketentuan'),
          ),
        );
        return;
      }

      authRemoteDataSource
          .register(
        name: '${firstNameController.text} ${lastNameController.text}',
        email: emailController.text,
        password: passwordController.text,
        phone: phoneController.text,
        company: 'ECarrgo',
        address: 'Alamat Anda',
      )
          .then((user) {
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(
              email: user.email,
              password: passwordController.text,
              role: widget.role,
            ),
          ),
        );
      }).catchError((error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mendaftar: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

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
              ),
              const SizedBox(width: 4),
              Image.asset('assets/images/logo.png',
                  width: 108, height: 14, fit: BoxFit.contain),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LanguageToggleButton(
              currentLocale: locale,
              onLocaleChanged: (newLocale) {
                context.read<LocaleProvider>().setLocale(newLocale);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.role == UserRole.vendor) ...[
                        const Text(
                          'Jadi Vendor Logistik',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ] else if (widget.role == UserRole.customer) ...[
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Pastikan bahwa 'Nama Depan' dan 'Nama Belakang' Anda sesuai dengan nama pada KTP / Paspor Anda untuk mempertahankan catatan yang akurat.",
                          style:
                              TextStyle(fontSize: 12, color: AppColors.slate),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SignUpForm(
                formKey: _formKey,
                role: widget.role,
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                emailController: emailController,
                phoneController: phoneController,

                // Untuk password, pilih yang customer atau vendor sesuai role
                customerPasswordController: widget.role == UserRole.customer
                    ? passwordController
                    : null,
                customerConfirmPasswordController:
                    widget.role == UserRole.customer
                        ? confirmPasswordController
                        : null,
                vendorPasswordController:
                    widget.role == UserRole.vendor ? passwordController : null,
                vendorConfirmPasswordController: widget.role == UserRole.vendor
                    ? confirmPasswordController
                    : null,

                // Untuk company dan vehicle type, hanya untuk vendor
                companyNameController: widget.role == UserRole.vendor
                    ? companyNameController
                    : null,
                businessLicenseController: widget.role == UserRole.vendor
                    ? businessLicenseController
                    : null,
                companyEmailController: widget.role == UserRole.vendor
                    ? companyEmailController
                    : null,
                companyPhoneController: widget.role == UserRole.vendor
                    ? companyPhoneController
                    : null,
                companyAddressController: widget.role == UserRole.vendor
                    ? companyAddressController
                    : null,

                selectedVehicleType: widget.role == UserRole.vendor
                    ? vehicleTypeController.text
                    : null,
                onVehicleTypeChanged: widget.role == UserRole.vendor
                    ? (val) {
                        setState(() {
                          vehicleTypeController.text = val ?? '';
                        });
                      }
                    : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    onChanged: (value) =>
                        setState(() => agreeToTerms = value ?? false),
                  ),
                  const Expanded(
                    child: Text(
                      'Dengan mendaftar, kamu setuju dengan Syarat dan Ketentuan yang ada di ECarrgo.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleSignUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Daftar Sekarang',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Atau daftar dengan', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: Image.asset('assets/images/icons/apple.png',
                        width: 40, height: 40),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: Image.asset('assets/images/icons/google.png',
                        width: 40, height: 40),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: Image.asset('assets/images/icons/facebook.png',
                        width: 40, height: 40),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Sudah mempunyai akun?',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  if (widget.role == UserRole.vendor) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VendorNavigation(),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(
                          password: passwordController.text,
                          role: widget.role,
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
