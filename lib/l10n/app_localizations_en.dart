// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingTitle1 => 'Welcome to ECarrgo Demo!';

  @override
  String get onboardingDesc1 =>
      'Discover a smarter way to ship goods with ECarrgo, a digital platform that connects shippers and carriers through a competitive auction system, both domestically and internationally.';

  @override
  String get onboardingTitle2 => 'Digital Logistics Simplified';

  @override
  String get onboardingDesc2 =>
      'Track your shipments in real time, compare carrier bids, and manage your logistics from one powerful dashboard.';

  @override
  String get onboardingTitle3 => 'Join the ECarrgo Network';

  @override
  String get onboardingDesc3 =>
      'Connect with trusted logistics partners and scale your business efficiently through our smart logistics ecosystem.';

  @override
  String get onboardingTitle4 => 'Smart Shipping Experience';

  @override
  String get onboardingDesc4 =>
      'Experience faster, smarter, and more cost-effective shipping with ECarrgo\'s intelligent matching technology.';

  @override
  String get buttonLogin => 'Login';

  @override
  String get buttonRegister => 'I am a new user, Sign up';

  @override
  String get loginAsTitle => 'Login as?';

  @override
  String get loginAsVendor => 'Vendor Logistics';

  @override
  String get loginAsSender => 'Sender';
}
