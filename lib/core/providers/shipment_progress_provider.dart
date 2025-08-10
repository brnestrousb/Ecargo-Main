import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShipmentProgressProvider with ChangeNotifier {
  int _currentStep = 0;
  bool _paymentConfirmed = false;
  int? _selectedDriverIndex;
  late SharedPreferences _prefs;

  int get currentStep => _currentStep;
  bool get paymentConfirmed => _paymentConfirmed;
  int? get selectedDriverIndex => _selectedDriverIndex;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await loadProgress();
  }

  Future<void> setProgress(int step,
      {bool? paymentConfirmed, int? driverIndex}) async {
    _currentStep = step;
    _paymentConfirmed = paymentConfirmed ?? _paymentConfirmed;
    _selectedDriverIndex = driverIndex ?? _selectedDriverIndex;
    await _saveProgress();
    notifyListeners();
  }

  Future<void> resetProgress() async {
    _currentStep = 0;
    _paymentConfirmed = false;
    _selectedDriverIndex = null;
    await _saveProgress();
    notifyListeners();
  }

  Future<void> loadProgress() async {
    _currentStep = _prefs.getInt('currentStep') ?? 0;
    _paymentConfirmed = _prefs.getBool('paymentConfirmed') ?? false;
    if (_prefs.containsKey('selectedDriverIndex')) {
      _selectedDriverIndex = _prefs.getInt('selectedDriverIndex');
    }
  }

  Future<void> _saveProgress() async {
    await _prefs.setInt('currentStep', _currentStep);
    await _prefs.setBool('paymentConfirmed', _paymentConfirmed);
    if (_selectedDriverIndex != null) {
      await _prefs.setInt('selectedDriverIndex', _selectedDriverIndex!);
    } else {
      await _prefs.remove('selectedDriverIndex');
    }
  }
}
