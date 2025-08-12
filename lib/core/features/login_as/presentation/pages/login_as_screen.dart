import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:ecarrgo/core/model/user_role.dart';
import 'package:ecarrgo/core/providers/locale_provider.dart';
import 'package:ecarrgo/core/widgets/language_toggle_button.dart';
import 'package:ecarrgo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginAsScreen extends StatefulWidget {
  final UserRole? role;
  const LoginAsScreen({super.key, this.role});

  @override
  State<LoginAsScreen> createState() => _LoginAsScreenState();
}

class _LoginAsScreenState extends State<LoginAsScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>().locale;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 170, // kasih ruang lebih besar
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.black),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero, // hapus padding default
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ), // buat icon lebih compact
              ),
              const SizedBox(width: 4),
              Image.asset(
                'assets/images/logo.png',
                width: 108, // kecilkan ukuran logo
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
              currentLocale: locale,
              onLocaleChanged: (newLocale) {
                context.read<LocaleProvider>().setLocale(newLocale);
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 250), // jarak dari atas layar, sesuaikan angkanya
                  Text(
                    AppLocalizations.of(context)!.loginAsTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedRole = 'vendor';
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignInScreen(role: UserRole.vendor),
                              ),
                            );
                          },
                          // Nonaktifkan gesture
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite2, // Tampilan disable
                              borderRadius: BorderRadius.circular(12),
                              border: selectedRole == 'customer'
                                  ? Border.all(
                                      color: AppColors.darkBlue, width: 1.5)
                                  : null,
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
                                        // color:
                                        //     Colors.grey, // Menunjukkan disable
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
                                // const Icon(
                                //   Icons.lock_outline,
                                //   color: Colors.grey,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedRole = 'customer';
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignInScreen(role: UserRole.customer),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite2,
                              borderRadius: BorderRadius.circular(12),
                              border: selectedRole == 'customer'
                                  ? Border.all(
                                      color: AppColors.darkBlue, width: 1.5)
                                  : null,
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
                                          height: 32),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .loginAsSender,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
