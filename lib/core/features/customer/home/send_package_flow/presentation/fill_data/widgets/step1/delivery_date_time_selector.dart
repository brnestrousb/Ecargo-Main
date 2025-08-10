import 'package:flutter/material.dart';
import 'package:ecarrgo/core/constant/colors.dart';

class DeliveryDateTimeSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<TimeOfDay>? onTimeSelected;
  final bool readOnly;

  const DeliveryDateTimeSelector({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    this.onDateSelected,
    this.onTimeSelected,
    this.readOnly = false,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && onDateSelected != null) {
      onDateSelected!(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? now,
    );
    if (picked != null && onTimeSelected != null) {
      onTimeSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: true,
            enabled: !readOnly,
            decoration: InputDecoration(
              labelText: "Tanggal",
              hintText: "Pilih Tanggal",
              prefixIcon: Icon(Icons.calendar_today, color: AppColors.gray),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            controller: TextEditingController(
              text: selectedDate != null
                  ? "${selectedDate!.day.toString().padLeft(2, '0')}/"
                      "${selectedDate!.month.toString().padLeft(2, '0')}/"
                      "${selectedDate!.year}"
                  : '',
            ),
            onTap: readOnly ? null : () => _selectDate(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            readOnly: true,
            enabled: !readOnly,
            decoration: InputDecoration(
              labelText: "Jam",
              hintText: "Pilih Jam",
              prefixIcon: Icon(Icons.access_time, color: AppColors.gray),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            controller: TextEditingController(
              text: selectedTime != null ? selectedTime!.format(context) : '',
            ),
            onTap: readOnly ? null : () => _selectTime(context),
          ),
        ),
      ],
    );
  }
}
