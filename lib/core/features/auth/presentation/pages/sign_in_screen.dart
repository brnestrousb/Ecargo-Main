import 'package:ecarrgo/core/model/user_role.dart';
import 'package:ecarrgo/core/providers/fcm_token_provider.dart';
import 'package:ecarrgo/main_vendor.dart';
import 'package:flutter/material.dart';
import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/widgets/language_toggle_button.dart';
import 'package:provider/provider.dart';
import 'package:ecarrgo/core/providers/locale_provider.dart';
import 'package:ecarrgo/main_customer.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:ecarrgo/core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecarrgo/core/network/api_constants.dart';

class SignInScreen extends StatefulWidget {
  final String? email;
  final String? password;
  final UserRole role;

  const SignInScreen({
    super.key,
    this.email,
    this.password,
    required this.role,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final logger = Logger();
  late final AuthRemoteDataSource authRemoteDataSource =
      AuthRemoteDataSourceImpl(
    Dio(BaseOptions(
      baseUrl: '${ApiConstants.baseUrl}/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    )),
  );

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false; // << tambahan

  @override
  void initState() {
    super.initState();

    if (widget.email != null) {
      emailController.text = widget.email!;
    }
    if (widget.password != null) {
      passwordController.text = widget.password!;
    }
  }

  void handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      // tutup keyboard
      FocusScope.of(context).unfocus();

      setState(() {
        isLoading = true;
      });

      try {
        final fcmToken =
            Provider.of<FcmTokenProvider>(context, listen: false).fcmToken;

        final user = await authRemoteDataSource.login(
          email: emailController.text,
          password: passwordController.text,
          fcmToken: fcmToken,
        );

        if (fcmToken != null) {
          await authRemoteDataSource.sendFcmToken(
            fcmToken: fcmToken,
            accessToken: user.accessToken,
          );
          logger.i('✅ FCM token sent after login.');
        } else {
          logger.w('⚠️ FCM token is null, skipping send.');
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => _getNavigationForRole(widget.role),
          ),
        );
      } catch (error) {
        logger.e('❌ Login error: $error');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal login: $error')),
        );
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;

    return Stack(
      children: [
        Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkan email dan password untuk masuk ke akun ECarrgo Anda.',
                    style: TextStyle(fontSize: 12, color: AppColors.slate),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!value.contains('@')) {
                              return 'Email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: handleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Masuk',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // const Text('Atau masuk dengan',
                        //     style: TextStyle(fontSize: 14)),
                        // const SizedBox(height: 12),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     _buildSocialIcon('assets/images/icons/apple.png'),
                        //     const SizedBox(width: 16),
                        //     _buildSocialIcon('assets/images/icons/google.png'),
                        //     const SizedBox(width: 16),
                        //     _buildSocialIcon(
                        //         'assets/images/icons/facebook.png'),
                        //   ],
                        // ),
                        const SizedBox(height: 24),
                        const Text('Belum punya akun?',
                            style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Daftar Sekarang',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Loading overlay
        if (isLoading)
          Positioned.fill(
            child: Container(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Widget _buildSocialIcon(String assetPath) {
  //   return Container(
  //     width: 48,
  //     height: 48,
  //     padding: const EdgeInsets.all(4),
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       border: Border.all(color: Colors.grey, width: 0.5),
  //     ),
  //     child: Image.asset(assetPath, width: 40, height: 40),
  //   );
  // }

  Widget _getNavigationForRole(UserRole role) {
    switch (role) {
      case UserRole.customer:
        return const CustomerNavigation();
      case UserRole.vendor:
        return const VendorNavigation();
    }
  }
}
