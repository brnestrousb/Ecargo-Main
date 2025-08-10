import 'package:flutter/material.dart';

class AddressRow extends StatelessWidget {
  final String address;
  final VoidCallback onEdit;

  const AddressRow({
    super.key,
    required this.address,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
