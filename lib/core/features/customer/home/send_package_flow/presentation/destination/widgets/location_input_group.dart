import 'package:ecarrgo/core/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocationInputGroup extends StatefulWidget {
  final String currentLocation;
  final String destinationLocation;
  final void Function(String current, String destination)? onChanged;
  final void Function(String activeInput)? onFocusChanged;

  const LocationInputGroup({
    super.key,
    required this.currentLocation,
    required this.destinationLocation,
    this.onChanged,
    this.onFocusChanged,
  });

  @override
  LocationInputGroupState createState() => LocationInputGroupState();
}

class LocationInputGroupState extends State<LocationInputGroup> {
  late TextEditingController currentController;
  late TextEditingController destinationController;

  late FocusNode currentFocusNode;
  late FocusNode destinationFocusNode;

  @override
  void initState() {
    super.initState();
    currentController = TextEditingController(text: widget.currentLocation);
    destinationController =
        TextEditingController(text: widget.destinationLocation);

    currentFocusNode = FocusNode();
    destinationFocusNode = FocusNode();

    currentController.addListener(_onCurrentChanged);
    destinationController.addListener(_onDestinationChanged);

    currentFocusNode.addListener(() {
      if (widget.onFocusChanged != null && currentFocusNode.hasFocus) {
        widget.onFocusChanged!("current");
      }
    });

    destinationFocusNode.addListener(() {
      if (widget.onFocusChanged != null && destinationFocusNode.hasFocus) {
        widget.onFocusChanged!("destination");
      }
    });
  }

  void _onCurrentChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(currentController.text, destinationController.text);
    }
  }

  void _onDestinationChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(currentController.text, destinationController.text);
    }
  }

  void setLocation({String? current, String? destination}) {
    if (current != null && current != currentController.text) {
      currentController.text = current;
      currentController.selection =
          TextSelection.collapsed(offset: current.length);
    }
    if (destination != null && destination != destinationController.text) {
      destinationController.text = destination;
      destinationController.selection =
          TextSelection.collapsed(offset: destination.length);
    }
  }

  @override
  void didUpdateWidget(covariant LocationInputGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jika parent update lokasi lewat props, sync ke controller
    if (widget.currentLocation != oldWidget.currentLocation &&
        widget.currentLocation != currentController.text) {
      currentController.text = widget.currentLocation;
      currentController.selection =
          TextSelection.collapsed(offset: widget.currentLocation.length);
    }
    if (widget.destinationLocation != oldWidget.destinationLocation &&
        widget.destinationLocation != destinationController.text) {
      destinationController.text = widget.destinationLocation;
      destinationController.selection =
          TextSelection.collapsed(offset: widget.destinationLocation.length);
    }
  }

  @override
  void dispose() {
    currentController.dispose();
    destinationController.dispose();
    currentFocusNode.dispose();
    destinationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon column tetap sama seperti sebelumnya
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Column(
              children: [
                SvgPicture.asset(
                    'assets/images/icons/current_location_icon.svg',
                    width: 24,
                    height: 24),
                const SizedBox(height: 4),
                SizedBox(
                  height: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => Container(
                        width: 2,
                        height: 2,
                        color: AppColors.lightGrayBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SvgPicture.asset(
                    'assets/images/icons/destination_location_icon.svg',
                    width: 24,
                    height: 24),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: currentController,
                  focusNode: currentFocusNode,
                  decoration: const InputDecoration(
                    hintText: 'Lokasi Anda Saat Ini',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(height: 1, thickness: 0.5, color: Colors.grey),
                ),
                TextField(
                  controller: destinationController,
                  focusNode: destinationFocusNode,
                  decoration: const InputDecoration(
                    hintText: 'Cari tujuan...',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
