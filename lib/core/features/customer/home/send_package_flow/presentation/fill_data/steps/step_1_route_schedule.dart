import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/destination/model/location_data.dart';
import 'package:ecarrgo/core/providers/fill_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/step_title.dart';
// import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/save_address_button.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/driver_note_input.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/delivery_date_time_selector.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/address_input_group_with_dots.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/presentation/fill_data/widgets/step1/delivery_time_info_box.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class Step1RouteSchedule extends StatelessWidget {
  final LocationData pickupLocation;
  final LocationData destinationLocation;
  final String? driverNote;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<TimeOfDay> onTimeSelected;
  final ValueChanged<String> onDriverNoteChanged;
  final bool readonly; // <-- Tambahan

  const Step1RouteSchedule({
    required this.pickupLocation,
    required this.destinationLocation,
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.driverNote,
    required this.onDriverNoteChanged,
    this.readonly = false, // <-- Default false
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    final fillData = Provider.of<FillDataProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepTitle(title: "Rute Pengiriman"),
                const SizedBox(height: 16),
                AddressInputGroupWithDots(
                  pickupTitle: fillData.pickupShort,
                  pickupDetail: fillData.pickupFullNoPostal,
                  destinationTitle: fillData.destinationShort,
                  destinationDetail: fillData.destinationFullNoPostal,
                  onEditPickup: readonly
                      ? null
                      : () {
                          logger.i("Edit penjemputan ditekan");
                        },
                  onEditDestination: readonly
                      ? null
                      : () {
                          logger.i("Edit tujuan ditekan");
                        },
                ),
                if (!readonly)
                  // const SaveAddressButton(), // tombol disembunyikan saat readonly
                  const SizedBox(height: 16),
                DriverNoteInput(
                  readOnly: readonly,
                  initialValue: driverNote,
                  onChanged: readonly
                      ? null
                      : (value) {
                          onDriverNoteChanged(value);
                        },
                ),
              ],
            ),
          ),
          Container(
            height: 12,
            color: Colors.grey[200],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StepTitle(title: "Tanggal Pengiriman"),
                const SizedBox(height: 16),
                DeliveryDateTimeSelector(
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  onDateSelected: readonly ? null : onDateSelected,
                  onTimeSelected: readonly ? null : onTimeSelected,
                  readOnly:
                      readonly, // Jika kamu punya kontrol readOnly dalam widget ini
                ),
                const SizedBox(height: 8),
                const DeliveryTimeInfoBox(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
