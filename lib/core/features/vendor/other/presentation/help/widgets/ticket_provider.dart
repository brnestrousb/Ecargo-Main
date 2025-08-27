import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketProvider extends ChangeNotifier {
  String? _ticketNumber;

  String? get ticketNumber => _ticketNumber;

  String? get hasTicket => _ticketNumber;

  Future<void> loadTicket() async {
    final prefs = await SharedPreferences.getInstance();
    _ticketNumber = prefs.getString('ticketNumber');
    notifyListeners();
  }

  Future<void> setTicketNumber(String number) async {
    _ticketNumber = number;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ticketNumber', number);
    notifyListeners();
  }

  Future<void> clearTicket() async {
    _ticketNumber = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ticketNumber');
    notifyListeners();
  }
}
