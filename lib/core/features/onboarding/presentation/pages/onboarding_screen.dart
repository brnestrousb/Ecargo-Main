import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/login_as/presentation/pages/login_as_screen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ecarrgo/l10n/app_localizations.dart';
import 'package:ecarrgo/core/features/register_as/presentation/pages/register_as_screen.dart';
import 'package:ecarrgo/core/widgets/language_toggle_button.dart';

class OnboardingScreen extends StatefulWidget {
  final void Function(Locale) setLocale;

  const OnboardingScreen({super.key, required this.setLocale});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  void setLocale(Locale locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final onboardingData = [
      {
        "title": t.onboardingTitle1,
        "description": t.onboardingDesc1,
      },
      {
        "title": t.onboardingTitle2,
        "description": t.onboardingDesc2,
      },
      {
        "title": t.onboardingTitle3,
        "description": t.onboardingDesc3,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 130, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          color: AppColors.offWhite1,
                        ),
                        Positioned(
                          // bottom: 10,
                          child: Image.asset(
                            'assets/images/onboarding_illustration.png',
                            width: 400,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  onboardingData[index]['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  onboardingData[index]['description'] ?? '',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: onboardingData.length,
                      effect: const WormEffect(
                        dotHeight: 12,
                        dotWidth: 12,
                        activeDotColor: Colors.blue,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginAsScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF01518D),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 8,
                            // ignore: deprecated_member_use
                            shadowColor: Colors.black.withOpacity(0.3),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.buttonLogin,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterAsScreen(
                                        setLocale: setLocale,
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 0.4,
                              ),
                            ),
                            elevation: 6,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            // ignore: deprecated_member_use
                            shadowColor: Colors.black.withOpacity(0.1),
                          ),
                          child: Text(
                              AppLocalizations.of(context)!.buttonRegister),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  // TestConnectionButton()
                ],
              ),
            ),

            // Toggle language button di pojok kanan atas
            Positioned(
              top: 16,
              right: 16,
              child: LanguageToggleButton(
                currentLocale: Localizations.localeOf(context),
                onLocaleChanged: (newLocale) {
                  widget.setLocale(newLocale);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
