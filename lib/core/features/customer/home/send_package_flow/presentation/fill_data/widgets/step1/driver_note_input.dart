import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecarrgo/core/constant/colors.dart';

class DriverNoteInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final bool readOnly;

  const DriverNoteInput({
    super.key,
    this.onChanged,
    this.initialValue,
    this.readOnly = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DriverNoteInputState createState() => _DriverNoteInputState();
}

class _DriverNoteInputState extends State<DriverNoteInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant DriverNoteInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika initialValue berubah dari luar, update controller text juga
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: "Tambahkan catatan untuk driver..",
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SvgPicture.asset(
            'assets/images/icons/note_driver_icon.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: widget.readOnly ? Colors.grey.shade300 : AppColors.darkBlue,
            width: widget.readOnly ? 1 : 2,
          ),
        ),
      ),
    );
  }
}
