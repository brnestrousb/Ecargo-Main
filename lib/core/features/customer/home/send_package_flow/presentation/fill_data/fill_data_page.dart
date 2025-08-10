import 'package:dio/dio.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/datasouces/send_package_remote_datasource.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/model/location_data.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/steps/step_5_summary.dart';
import 'package:ecarrgo/core/network/api_constants.dart';
import 'package:ecarrgo/core/network/storage/secure_storage_service.dart';
import 'package:ecarrgo/core/providers/fill_data_provider.dart';
import 'package:ecarrgo/core/providers/shipment_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/steps/step_1_route_schedule.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/steps/step_2_item_detail.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/steps/step_3_package_protection.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/steps/step_4_auction_settings.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step_indicator.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/send_package_flow_layout.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class FillDataPage extends StatelessWidget {
  final LocationData pickup;
  final LocationData destination;

  final Logger logger = Logger();

  FillDataPage({
    super.key,
    required this.pickup,
    required this.destination,
  });

  void _showConfirmationDialog(BuildContext context) {
    FocusScope.of(context).unfocus();
    bool isLoading = false; // Add loading state

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        // Wrap with StatefulBuilder to manage local state
        builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            'Sudah pastikan informasi benar?',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SvgPicture.asset(
                          'assets/images/icons/confirm_fill_data.svg',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.of(context).pop(),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text("Kembali"),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        setState(() =>
                                            isLoading = true); // Start loading

                                        final fillData =
                                            context.read<FillDataProvider>();

                                        final shipmentProvider =
                                            context.read<ShipmentProvider>();

                                        final packageData = {
                                          "pickup_location": {
                                            "address": pickup.address,
                                            "latitude": pickup.latitude,
                                            "longitude": pickup.longitude,
                                            "placeName": pickup.placeName ?? "",
                                            "city": pickup.city ?? "",
                                            "postalCode":
                                                pickup.postalCode ?? "",
                                            "country":
                                                pickup.country ?? "Indonesia",
                                          },
                                          "destination_location": {
                                            "address": destination.address,
                                            "latitude": destination.latitude,
                                            "longitude": destination.longitude,
                                            "placeName":
                                                destination.placeName ?? "",
                                            "city": destination.city ?? "",
                                            "postalCode":
                                                destination.postalCode ?? "",
                                            "country": destination.country ??
                                                "Indonesia",
                                          },
                                          "selected_date": fillData.selectedDate
                                                  ?.toIso8601String()
                                                  .split("T")
                                                  .first ??
                                              "",
                                          "selected_time": fillData.selectedTime
                                                  ?.format(context) ??
                                              "",
                                          "driver_note":
                                              fillData.driverNote ?? "",
                                          "item_types":
                                              fillData.itemTypes.join(", "),
                                          "item_weight_ton":
                                              double.tryParse(fillData.weight)
                                                      ?.toStringAsFixed(0) ??
                                                  "0",
                                          "item_value_rp": (double.tryParse(
                                                      fillData.value) ??
                                                  0)
                                              .toInt()
                                              .toString(),
                                          "item_volume_m3": double.tryParse(
                                                      fillData.dimensions)
                                                  ?.toStringAsFixed(0) ??
                                              "0",
                                          "item_description":
                                              fillData.description,
                                          "shipping_type":
                                              fillData.shippingType ?? "",
                                          "protection":
                                              fillData.protection ?? "",
                                          "delivery_datetime": fillData
                                              .deliveryDateTime
                                              ?.toIso8601String(),
                                          "auction_starting_price":
                                              fillData.startingPrice,
                                          "auction_duration":
                                              fillData.auctionDurationText,
                                        };

                                        final dio = Dio(
                                          BaseOptions(
                                              baseUrl:
                                                  '${ApiConstants.baseUrl}/api/v1'),
                                        );
                                        final remoteDataSource =
                                            SendPackageRemoteDataSourceImpl(dio,
                                                shipmentProvider, fillData);

                                        final accessToken =
                                            await SecureStorageService()
                                                .getToken();

                                        if (accessToken == null) {
                                          if (context.mounted) {
                                            setState(() => isLoading =
                                                false); // Stop loading
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Token tidak ditemukan')),
                                            );
                                          }
                                          return;
                                        }

                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );

                                        try {
                                          final (auctionId, shipmentId) =
                                              await remoteDataSource
                                                  .createAuctionPackage(
                                            packageData: packageData,
                                            accessToken: accessToken,
                                          );

                                          if (context.mounted) {
                                            fillData.auctionId = auctionId;
                                            fillData.shipmentId = shipmentId;

                                            fillData.reset();

                                            // Tutup overlay loading
                                            Navigator.of(context).pop();

                                            // Navigasi ke halaman berikutnya
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    SendPackageFlowLayout(
                                                  auctionId: auctionId,
                                                  shipmentId: shipmentId,
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            // Tutup overlay loading
                                            Navigator.of(context).pop();

                                            setState(() => isLoading =
                                                false); // Stop loading
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Gagal mengirim data: $e')),
                                            );
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkBlue,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text("Ya, buat pengiriman"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Loading overlay full screen
              // if (isLoading)
              //   Positioned.fill(
              //     child: Container(
              //       // ignore: deprecated_member_use
              //       color: Colors.black.withOpacity(0.4),
              //       child: const Center(
              //         child: CircularProgressIndicator(
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSteps(BuildContext context) {
    final fillData = context.watch<FillDataProvider>();
    debugPrint('IndexedStack index: ${fillData.currentStep}');
    return IndexedStack(
      index: fillData.currentStep,
      key: ValueKey(fillData.currentStep),
      children: [
        // Step 0 - tampilkan loading di dalam widget, bukan return beda
        (fillData.pickupLocation != null &&
                fillData.destinationLocation != null)
            ? Step1RouteSchedule(
                pickupLocation: fillData.pickupLocation!,
                destinationLocation: fillData.destinationLocation!,
                selectedDate: fillData.selectedDate,
                selectedTime: fillData.selectedTime,
                onDateSelected: fillData.setSelectedDate,
                onTimeSelected: fillData.setSelectedTime,
                driverNote: fillData.driverNote,
                onDriverNoteChanged: fillData.setDriverNote,
              )
            : const Center(child: CircularProgressIndicator()),

        // Step 1
        Step2ItemDetails(
          onNext: () {/* navigasi step berikutnya */},
          onItemDetailsChanged: ({
            required List<String> itemTypes,
            required String weight,
            required String value,
            required String dimensions,
            required String description,
          }) {
            // Simpan data ke provider
            final provider = context.read<FillDataProvider>();
            provider.updateItemDetails(
              itemTypes: itemTypes,
              weight: double.tryParse(weight) ?? 0.0,
              value: double.tryParse(value.replaceAll('.', '')) ??
                  0.0, // hapus titik ribuan
              dimensions: double.tryParse(dimensions) ?? 0.0,
              description: description,
            );
          },
        ),

        // Step 2
        Step3ShippingPackage(
          onNext: fillData.nextStep,
          onShippingTypeChanged: fillData.setShippingType,
          onProtectionChanged: fillData.setProtection,
        ),

        // Step 3
        Step4AuctionSettings(
          onNext: fillData.nextStep,
          onEditDeliveryTime: () => fillData.goToStep(0),
          deliveryDateTime: fillData.deliveryDateTime,
        ),

        // Step 4
        Step5Summary(readonly: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fillData = context.watch<FillDataProvider>();

    // initializeLocations dipanggil sekali setelah frame selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FillDataProvider>().initializeLocations(
            pickup: pickup,
            destination: destination,
          );
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Buat Lelang Pengiriman',
            style: TextStyle(color: Colors.black, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Center(
                    child: StepIndicatorWidget(
                      currentStep: fillData.currentStep,
                      onStepTapped: (index) {
                        FocusScope.of(context).unfocus();
                        fillData.goToStep(index);
                      },
                    ),
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
                Expanded(child: _buildSteps(context)),
              ],
            ),
            if (fillData.isSubmitting)
              Positioned.fill(
                child: Container(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.darkBlue),
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 8),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: fillData.isCurrentStepValid
                  ? () {
                      if (fillData.currentStep == 4) {
                        _showConfirmationDialog(context);
                      } else {
                        fillData.nextStep();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: fillData.isCurrentStepValid
                    ? AppColors.darkBlue
                    : Colors.grey.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(fillData.currentStep == 4 ? 'Kirim' : 'Lanjut'),
            ),
          ),
        ),
      ),
    );
  }
}
