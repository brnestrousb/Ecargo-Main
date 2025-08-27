import 'package:ecarrgo/core/features/auth/providers/auth_token_provider.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/pages/help.dart';
import 'package:ecarrgo/core/features/customer/other/presentation/help/widgets/ticket_provider.dart';
import 'package:ecarrgo/core/features/vendor/auction/widgets/pages/auction_confirmation_page.dart';
import 'package:ecarrgo/core/providers/fcm_token_provider.dart';
import 'package:ecarrgo/core/providers/fill_data_provider.dart';
import 'package:ecarrgo/core/providers/shipment_progress_provider.dart';
import 'package:ecarrgo/core/providers/shipment_provider.dart';
import 'package:ecarrgo/l10n/app_localizations.dart';
import 'package:ecarrgo/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/features/splash/presentation/pages/splash_screen.dart';
import 'core/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'core/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  final authTokenProvider = AuthTokenProvider();
  await authTokenProvider.loadToken(); // <-- load token dari storage
  await initializeNotifications(); // ✅ Tambahkan ini
  final progressProvider = ShipmentProgressProvider();
  await progressProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
            create: (_) => FcmTokenProvider()), // ⛔️ jangan init langsung
        ChangeNotifierProvider(create: (_) => FillDataProvider()),
        ChangeNotifierProvider(create: (_) => authTokenProvider),
        ChangeNotifierProvider(create: (_) => ShipmentProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider.value(value: progressProvider),
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      // ignore: use_build_context_synchronously
      final fcmProvider = Provider.of<FcmTokenProvider>(context, listen: false);
      // ignore: use_build_context_synchronously
      fcmProvider.initFcmToken(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'ECarrgo',
      navigatorKey: navigatorKey, // untuk navigasi global
      scaffoldMessengerKey:
          scaffoldMessengerKey, // 💡 penting agar bisa tampilkan SnackBar
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PlusJakartaSans',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'PlusJakartaSans'),
          bodyMedium: TextStyle(fontFamily: 'PlusJakartaSans'),
          titleLarge: TextStyle(fontFamily: 'PlusJakartaSans'),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(
              setLocale: (locale) => localeProvider.setLocale(locale),
            ),
        //(context) => OfferConfirmationPage(),
        
        '/help': (context) =>
            const HelpHomePage(), // ✅ definisi route untuk bantuan
      },
    );
  }
}
