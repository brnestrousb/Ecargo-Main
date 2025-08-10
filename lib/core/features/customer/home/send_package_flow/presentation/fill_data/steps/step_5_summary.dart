import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/protection_options_data.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/model/protection_option_model.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/address_input_group_with_dots.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/delivery_date_time_selector.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/step_title.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step2/item_detail_inputs.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step2/item_type_selector.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step3/dash_border_painter.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step3/shipping_package_card.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/shipping_package_data.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step4/auction_duration.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step4/price_input_field.dart';
import 'package:ecarrgo/core/providers/fill_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class Step5Summary extends StatefulWidget {
  final bool readonly;
  const Step5Summary({super.key, this.readonly = true});

  @override
  State<Step5Summary> createState() => _Step5SummaryState();
}

class _Step5SummaryState extends State<Step5Summary> {
  // Tambahkan instance variable untuk fillData
  FillDataProvider? _fillDataProvider;

  late TextEditingController weightController;
  late TextEditingController valueController;
  late TextEditingController dimensionController;
  late TextEditingController descriptionController;
  late TextEditingController _startingPriceController;

  final logger = Logger();

  @override
  void initState() {
    super.initState();

    // Inisialisasi semua controller
    weightController = TextEditingController();
    valueController = TextEditingController();
    dimensionController = TextEditingController();
    descriptionController = TextEditingController();
    _startingPriceController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Setup provider dan listener di didChangeDependencies
    if (_fillDataProvider == null) {
      _fillDataProvider = context.read<FillDataProvider>();
      _updateControllersFromProvider();
      _fillDataProvider!.addListener(_updateControllersFromProvider);
    }
  }

  ProtectionOption? get selectedProtectionOption {
    if (_fillDataProvider == null) return null;

    try {
      return protectionOptions.firstWhere(
        (option) => option.name == _fillDataProvider!.selectedProtection,
      );
    } catch (e) {
      logger.w(
          "Protection option not found: ${_fillDataProvider!.selectedProtection}");
      return null;
    }
  }

  void _updateControllersFromProvider() {
    if (_fillDataProvider == null || !mounted) return;

    if (weightController.text != _fillDataProvider!.weight) {
      weightController.text = _fillDataProvider!.weight;
    }
    if (valueController.text != _fillDataProvider!.value) {
      valueController.text = _fillDataProvider!.value;
    }
    if (dimensionController.text != _fillDataProvider!.dimensions) {
      dimensionController.text = _fillDataProvider!.dimensions;
    }
    if (descriptionController.text != _fillDataProvider!.description) {
      descriptionController.text = _fillDataProvider!.description;
    }
    if (_startingPriceController.text != _fillDataProvider!.startingPrice) {
      _startingPriceController.text = _fillDataProvider!.startingPrice;
    }
  }

  @override
  void dispose() {
    // Fix: gunakan instance variable yang benar
    _fillDataProvider?.removeListener(_updateControllersFromProvider);

    weightController.dispose();
    valueController.dispose();
    dimensionController.dispose();
    descriptionController.dispose();
    _startingPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        try {
          return Consumer<FillDataProvider>(
            builder: (context, fillData, child) {
              debugPrint('📊 Step5Summary Data Check:');
              debugPrint('- Current Step: ${fillData.currentStep}');
              debugPrint('- Delivery DateTime: ${fillData.deliveryDateTime}');
              debugPrint('- Weight: ${fillData.weight}');
              debugPrint('- Value: ${fillData.value}');
              debugPrint('- Dimensions: ${fillData.dimensions}');
              debugPrint('- Description: ${fillData.description}');
              debugPrint('- Protection: ${fillData.selectedProtection}');
              debugPrint('- Starting Price: ${fillData.startingPrice}');

              // Cek data penting sebelum render
              final isDataReady = fillData.deliveryDateTime != null &&
                  fillData.selectedShippingType != null &&
                  fillData.selectedProtection != null;

              if (!isDataReady) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final selectedDate = fillData.selectedDate;
              final selectedTime = fillData.selectedTime;
              final selectedShippingType = fillData.selectedShippingType;
              final selectedProtectionOption = this.selectedProtectionOption;

              void onDateSelected(DateTime date) {
                fillData.setSelectedDate(date);
                logger.i("Tanggal pengiriman dipilih: $date");
              }

              void onTimeSelected(TimeOfDay time) {
                fillData.setSelectedTime(time);
                logger.i("Waktu pengiriman dipilih: $time");
              }

              debugPrint('Step5Summary build called');
              debugPrint('deliveryDateTime: ${fillData.deliveryDateTime}');
              debugPrint('pickupShort: ${fillData.pickupShort}');
              debugPrint('destinationShort: ${fillData.destinationShort}');

              return Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'Summary Pengiriman',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        // Step 1 - Alamat
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StepTitle(title: "Rute Pengiriman"),
                              const SizedBox(height: 16),
                              AddressInputGroupWithDots(
                                pickupTitle: fillData.pickupShort,
                                pickupDetail: fillData.pickupFullNoPostal,
                                destinationTitle: fillData.destinationShort,
                                destinationDetail:
                                    fillData.destinationFullNoPostal,
                                onEditPickup: widget.readonly
                                    ? null
                                    : () {
                                        logger.i("Edit penjemputan ditekan");
                                      },
                                onEditDestination: widget.readonly
                                    ? null
                                    : () {
                                        logger.i("Edit tujuan ditekan");
                                      },
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),

                        // Separator
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey[200],
                        ),

                        const SizedBox(height: 24),

                        // Step 2 - Tanggal Pengiriman
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StepTitle(title: "Tanggal Pengiriman"),
                              const SizedBox(height: 16),
                              DeliveryDateTimeSelector(
                                selectedDate: selectedDate,
                                selectedTime: selectedTime,
                                onDateSelected:
                                    widget.readonly ? null : onDateSelected,
                                onTimeSelected:
                                    widget.readonly ? null : onTimeSelected,
                                readOnly: widget.readonly,
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),

                        // Separator
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey[200],
                        ),

                        const SizedBox(height: 24),

                        // Step 3 - Jenis dan Detail Barang
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StepTitle(title: "Jenis Barang"),
                              const SizedBox(height: 16),
                              ItemTypesSelector(
                                selectedTypes: fillData.itemTypes,
                                readOnly: true,
                                onItemTypesSelected: widget.readonly
                                    ? (_) {}
                                    : (selected) {
                                        fillData.selectedItemTypes = selected;
                                      },
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),

                        // Separator
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey[200],
                        ),

                        const SizedBox(height: 24),

                        // Step 4 - Detail Barang
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StepTitle(title: "Detail Barang"),
                              const SizedBox(height: 16),
                              ItemDetailInputs(
                                readOnly: widget.readonly,
                                weightController: weightController,
                                valueController: valueController,
                                dimensionController: dimensionController,
                                descriptionController: descriptionController,
                                onChanged: () => {
                                  fillData.weight = weightController.text,
                                  fillData.value = valueController.text,
                                  fillData.dimensions =
                                      dimensionController.text,
                                  fillData.description =
                                      descriptionController.text,
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Separator
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey[200],
                        ),

                        const SizedBox(height: 24),

                        // Step 5 - Shipping card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StepTitle(title: "Paket Pengiriman"),
                              const SizedBox(height: 16),

                              // Filter dan tampilkan shipping package
                              ...shippingPackages
                                  .where(
                                      (pkg) => pkg.id == selectedShippingType)
                                  .map((pkg) {
                                return ShippingPackageCard(
                                  svgIconPath: pkg.iconPath,
                                  title: pkg.title,
                                  method: pkg.method,
                                  description: pkg.description,
                                  timeEstimate: pkg.timeEstimate,
                                  priceEstimate: pkg.priceEstimate,
                                  selected: true,
                                  readOnly: true,
                                );
                              }),
                            ],
                          ),
                        ),

                        // Separator
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey[200],
                        ),

                        const SizedBox(height: 24),

                        // Step 6 - Paket Proteksi
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StepTitle(title: 'Paket Proteksi'),
                              const SizedBox(height: 12),
                              CustomPaint(
                                painter: DashedBorderPainter(
                                  color: Colors.grey.shade300,
                                  borderRadius: 12,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        selectedProtectionOption?.icon ??
                                            'assets/images/icons/proteksi_icon.svg',
                                        width: 48,
                                        height: 48,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        selectedProtectionOption != null
                                            ? 'Paket Proteksi: ${selectedProtectionOption.name}'
                                            : 'Anda belum menambahkan Paket Proteksi',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              selectedProtectionOption != null
                                                  ? Colors.black
                                                  : Colors.grey.shade700,
                                        ),
                                      ),
                                      if (selectedProtectionOption != null) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          selectedProtectionOption.description,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Separator
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey[200],
                        ),

                        const SizedBox(height: 24),

                        // Step 7 - Pengaturan Lelang
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StepTitle(title: 'Pengaturan Lelang'),
                              const SizedBox(height: 12),
                              PriceInputField(
                                controller: _startingPriceController,
                                label: 'Harga Awal',
                                hintText: 'Masukkan harga',
                                readOnly: widget.readonly,
                              ),
                              const SizedBox(height: 24),

                              // Durasi Lelang
                              AuctionDurationWidget(
                                initialUnit: fillData.auctionDurationUnit,
                                initialValue: fillData.auctionDurationValue,
                                deliveryDateTime: fillData.deliveryDateTime!,
                                readOnly: widget.readonly,
                                onDurationChanged: widget.readonly
                                    ? null
                                    : (unit, value) {
                                        fillData.auctionDurationUnit = unit;
                                        fillData.auctionDurationValue = value;
                                        fillData.auctionDuration =
                                            '$value $unit';
                                      },
                              ),
                            ],
                          ),
                        ),

                        // Final Separator
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 10,
                          color: Colors.grey[200],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } catch (e, stack) {
          debugPrint('🔴 Error in Step5Summary: $e');
          debugPrint('Stack trace: $stack');
          return Scaffold(
            body: Center(
              child: Text('Terjadi error di Step5Summary:\n$e'),
            ),
          );
        }
      },
    );
  }
}
