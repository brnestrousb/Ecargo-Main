import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecarrgo/core/constant/colors.dart';
import 'package:ecarrgo/core/features/customer/home/send_package_flow/data/protection_options_data.dart'; // sesuaikan path jika perlu

class ShippingProtectionDialog extends StatefulWidget {
  const ShippingProtectionDialog({super.key});

  @override
  State<ShippingProtectionDialog> createState() =>
      _ShippingProtectionDialogState();
}

class _ShippingProtectionDialogState extends State<ShippingProtectionDialog> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(protectionOptions.length, (index) {
              final option = protectionOptions[index];
              final isSelected = selectedIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.darkBlue
                            : Colors.grey.shade300,
                        width: 1.8,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: AppColors.darkBlue.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isSelected ? AppColors.darkBlue : Colors.grey,
                              width: 2.5,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.darkBlue,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 20),
                        SvgPicture.asset(
                          option.icon,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      option.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: option.color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      option.price,
                                      style: TextStyle(
                                        color: option.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                option.description,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => {
                      SystemChannels.textInput.invokeMethod('TextInput.hide'),
                      Navigator.of(context).pop(),
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                    onPressed: selectedIndex != null
                        ? () async {
                            // 1. First remove focus explicitly
                            FocusScope.of(context).unfocus();

                            // 2. Hide the system keyboard
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');

                            // 3. Add a small delay to ensure keyboard is fully dismissed
                            await Future.delayed(
                                const Duration(milliseconds: 200));

                            // 4. Only then close the dialog
                            if (mounted) {
                              final selected =
                                  protectionOptions[selectedIndex!];
                              Navigator.of(context).pop({
                                'name': selected.name,
                                'price': selected.price,
                                'icon': selected.icon,
                              });
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text("Pilih Proteksi"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
