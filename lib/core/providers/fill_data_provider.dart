import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/model/location_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class FillDataProvider extends ChangeNotifier {
  int? _auctionId;
  int? _shipmentId;

  // --- EXISTING FIELDS ---
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _driverNote;
  String? _shippingType;
  String? _protection;
  String _itemWeight = ''; // Berat dalam ton (misalnya: "2.5")
  String _itemDimensions = ''; // Volume dalam m³
  String _itemValue = ''; // Nilai dalam Rupiah
  List<String> _itemTypes = [];
  String _itemDescription = ''; // Keterangan tambahan
  int _currentStep = 0;
  final bool _isSubmitting = false;

  // --- NEW: LOCATION DATA ---
  LocationData? _pickupLocation;
  LocationData? _destinationLocation;

  // --- PUBLIC GETTERS ---
  LocationData? get pickupLocation => _pickupLocation;
  LocationData? get destinationLocation => _destinationLocation;

  String get weight => _itemWeight;
  String get value => _itemValue;
  String get dimensions => _itemDimensions;
  String get description => _itemDescription;

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  String? get driverNote => _driverNote;
  String? get selectedShippingType => _shippingType;
  String? get selectedProtection => _protection;
  int get currentStep => _currentStep;
  bool get isSubmitting => _isSubmitting;

  int? get auctionId => _auctionId;
  int? get shipmentId => _shipmentId;

  set auctionId(int? value) {
    _auctionId = value;
    notifyListeners();
  }

  void resetid() {
    _auctionId = null;
    // reset data lainnya
    notifyListeners();
  }

  set shipmentId(int? value) {
    _shipmentId = value;
    notifyListeners();
  }

  void resetShipmentId() {
    _shipmentId = null;
    // reset data lainnya
    notifyListeners();
  }

  set weight(String val) {
    _itemWeight = val;
    notifyListeners();
  }

  set value(String val) {
    _itemValue = val;
    notifyListeners();
  }

  set dimensions(String val) {
    _itemDimensions = val;
    notifyListeners();
  }

  set description(String val) {
    _itemDescription = val;
    notifyListeners();
  }

  String _startingPrice = '';
  String get startingPrice => _startingPrice;
  set startingPrice(String val) {
    _startingPrice = val;
    notifyListeners();
  }

  String _auctionDuration = '';
  String get auctionDuration => _auctionDuration;
  set auctionDuration(String val) {
    _auctionDuration = val;
    notifyListeners();
  }

  // Convenience combined DateTime (nullable)
  DateTime? get deliveryDateTime {
    if (_selectedDate == null || _selectedTime == null) return null;
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  // --- FORMAT HELPERS (postal code removed, short form) ---
  String _removePostalCode(String fullAddress) {
    final parts = fullAddress.split(',').map((e) => e.trim()).toList();
    final filtered = parts.where((p) => !RegExp(r'^\d{5}$').hasMatch(p));
    return filtered.join(', ');
  }

  String _shortenAddressByComma(String fullAddress, {int maxParts = 2}) {
    final parts = fullAddress.split(',').map((e) => e.trim()).toList();
    if (parts.length <= maxParts) return fullAddress;
    return parts.take(maxParts).join(', ');
  }

  String cleanRupiahString(String input) {
    // Remove non-digit characters
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Public convenience getters for UI
  String get pickupShort => _pickupLocation == null
      ? ''
      : _shortenAddressByComma(_pickupLocation!.address);

  String get pickupFullNoPostal => _pickupLocation == null
      ? ''
      : _removePostalCode(_pickupLocation!.address);

  String get destinationShort => _destinationLocation == null
      ? ''
      : _shortenAddressByComma(_destinationLocation!.address);

  String get destinationFullNoPostal => _destinationLocation == null
      ? ''
      : _removePostalCode(_destinationLocation!.address);

  // --- SETTERS ---
  void initializeLocations({
    required LocationData pickup,
    required LocationData destination,
  }) {
    final changed =
        _pickupLocation != pickup || _destinationLocation != destination;
    if (!changed) return;
    _pickupLocation = pickup;
    _destinationLocation = destination;
    _revalidate();
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    _revalidate();
    notifyListeners();
  }

  String? get selectedDateFormatted {
    if (_selectedDate == null) return null;
    final d = _selectedDate!;
    return "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";
  }

  void setSelectedTime(TimeOfDay time) {
    _selectedTime = time;
    _revalidate();
    notifyListeners();
  }

  void setDriverNote(String note) {
    _driverNote = note;
    notifyListeners();
  }

  void setShippingType(String type) {
    _shippingType = type;
    _revalidate();
    notifyListeners();
  }

  // Getter sudah ada, cuma namanya itemTypes
  List<String> get itemTypes => _itemTypes;

// Tambahkan setter supaya bisa dipakai seperti ini:
  set selectedItemTypes(List<String> types) {
    _itemTypes = types;
    notifyListeners();
  }

  void updateItemDetails({
    required List<String> itemTypes,
    required double weight,
    required double value,
    required double dimensions,
    required String description,
  }) {
    _itemTypes = itemTypes;
    _itemWeight = weight.toString();
    _itemValue = value.toString();
    _itemDimensions = dimensions.toString();
    _itemDescription = description;

    notifyListeners();
  }

  void addItemType(String type) {
    if (!_itemTypes.contains(type)) {
      _itemTypes.add(type);
      notifyListeners();
    }
  }

  void removeItemType(String type) {
    if (_itemTypes.contains(type)) {
      _itemTypes.remove(type);
      notifyListeners();
    }
  }

  void setSelectedShippingType(String? type) {
    _shippingType = type;
    notifyListeners();
  }

  void setProtection(String protection) {
    _protection = protection;
    _revalidate();
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 4) {
      _currentStep++;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step < 0 || step > 4) return;
    _currentStep = step;
    _revalidate();
    notifyListeners();
  }

  // --- VALIDATION ---
  bool _isStep1Valid() {
    return _pickupLocation != null &&
        _destinationLocation != null &&
        _selectedDate != null &&
        _selectedTime != null;
  }

  bool _isStep2Valid() {
    final weight = double.tryParse(_itemWeight) ?? 0;
    final cleanedValueString = cleanRupiahString(_itemValue);
    final value = double.tryParse(cleanedValueString) ?? -1;
    final dimensions = double.tryParse(_itemDimensions) ?? 0;

    Logger().i('Validasi Step 2: itemTypes="$_itemTypes", '
        'weight=$weight, value=$value, dimensions=$dimensions, '
        'description="$_itemDescription"');

    final isValid = _itemTypes.isNotEmpty &&
        weight > 0 &&
        weight <= 100 &&
        value >= 0 &&
        dimensions > 0 &&
        _itemDescription.isNotEmpty;

    Logger().i('Step 2 valid: $isValid');
    return isValid;
  }

  bool _isStep3Valid() {
    return _shippingType != null && _protection != null;
  }

  bool get _isStep4Valid {
    final price =
        int.tryParse(_startingPrice.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    // Pastikan durasi > 0 dan unit valid
    final isDurationValid = _auctionDurationValue > 0 &&
        (_auctionDurationUnit == 'Jam' || _auctionDurationUnit == 'Hari');

    if (price < 120000) return false;
    if (!isDurationValid) return false;

    // Validasi waktu lelang tidak boleh melebihi waktu pengiriman
    final now = DateTime.now();
    final duration = _auctionDurationUnit == 'Jam'
        ? Duration(hours: _auctionDurationValue)
        : Duration(days: _auctionDurationValue);

    final auctionEndTime = now.add(duration);

    Logger().i(
      'Validasi Step 4: price=$price, '
      'duration=${_auctionDurationValue.toString()} $_auctionDurationUnit, '
      'auctionEndTime=$auctionEndTime, deliveryDateTime=$deliveryDateTime',
    );

    if (deliveryDateTime != null && auctionEndTime.isAfter(deliveryDateTime!)) {
      Logger().w('Auction end time exceeds delivery time!');
      return false;
    }

    return true;
  }

  bool get isCurrentStepValid {
    switch (_currentStep) {
      case 0:
        return _isStep1Valid();
      case 1:
        return _isStep2Valid();
      case 2:
        return _isStep3Valid();
      case 3:
        return _isStep4Valid;
      case 4:
        return true; // summary
      default:
        return false;
    }
  }

  void _revalidate() {
    // Placeholder for future cache/derived state updates
  }

  String _auctionDurationUnit = 'Jam';
  int _auctionDurationValue = 1;

  String get auctionDurationUnit => _auctionDurationUnit;
  int get auctionDurationValue => _auctionDurationValue;

  set auctionDurationUnit(String value) {
    _auctionDurationUnit = value;
    notifyListeners();
  }

  set auctionDurationValue(int value) {
    _auctionDurationValue = value;
    notifyListeners();
  }

  set currentStep(int value) {
    debugPrint('Set currentStep: $value');
    _currentStep = value;
    notifyListeners();
  }

  String get formattedItemValue =>
      NumberFormat.currency(locale: 'id', symbol: 'Rp ')
          .format(int.tryParse(_itemValue) ?? 0);

  String? get shippingType => _shippingType;
  String? get protection => _protection;
  String get formattedAuctionPrice =>
      NumberFormat.currency(locale: 'id', symbol: 'Rp ')
          .format(int.tryParse(startingPrice) ?? 0);

  String? get auctionDurationText =>
      auctionDuration; // Jika kamu sudah punya variabel `auctionDuration`\

  void reset() {
    _selectedDate = null;
    _selectedTime = null;
    _driverNote = null;
    _shippingType = null;
    _protection = null;
    _itemWeight = '';
    _itemDimensions = '';
    _itemValue = '';
    _itemTypes = [];
    _itemDescription = '';
    _currentStep = 0;
    _pickupLocation = null;
    _destinationLocation = null;
    _startingPrice = '';
    _auctionDuration = '';
    _auctionDurationUnit = 'Jam';
    _auctionDurationValue = 1;

    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'auction_id': _auctionId,
      'shipment_id': _shipmentId,
      'pickup_location': _pickupLocation?.toJson(),
      'destination_location': _destinationLocation?.toJson(),
      'selected_date': selectedDateFormatted,
      'selected_time': _selectedTime != null
          ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
          : null,
      'driver_note': _driverNote,
      'item_types': _itemTypes,
      'item_weight_ton': _itemWeight,
      'item_value_rp': _itemValue,
      'item_volume_m3': _itemDimensions,
      'item_description': _itemDescription,
      'shipping_type': _shippingType,
      'protection': _protection,
      'starting_price': _startingPrice,
      'auction_duration': _auctionDuration,
      'delivery_datetime': deliveryDateTime?.toIso8601String(),
    };
  }
}
