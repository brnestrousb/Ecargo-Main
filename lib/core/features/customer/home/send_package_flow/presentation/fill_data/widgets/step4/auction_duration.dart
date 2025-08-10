import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuctionDurationWidget extends StatefulWidget {
  final String initialUnit; // "Jam" atau "Hari"
  final int initialValue;
  final bool readOnly;
  final DateTime deliveryDateTime;
  final void Function(String unit, int value)? onDurationChanged;

  const AuctionDurationWidget({
    super.key,
    required this.initialUnit,
    required this.initialValue,
    required this.deliveryDateTime,
    this.readOnly = false,
    this.onDurationChanged,
  });

  @override
  State<AuctionDurationWidget> createState() => _AuctionDurationWidgetState();
}

class _AuctionDurationWidgetState extends State<AuctionDurationWidget> {
  late TextEditingController _valueController;
  late String _selectedUnit;
  String? _errorText;

  @override
  void didUpdateWidget(covariant AuctionDurationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.readOnly) {
      _valueController.text = widget.initialValue.toString();
      if (widget.initialUnit.toLowerCase() == 'jam') {
        _selectedUnit = 'Jam';
      } else if (widget.initialUnit.toLowerCase() == 'hari') {
        _selectedUnit = 'Hari';
      } else {
        _selectedUnit = 'Jam';
      }
    }
  }

  Duration get _currentDuration {
    int value = int.tryParse(_valueController.text) ?? 0;
    return _selectedUnit == 'Jam'
        ? Duration(hours: value)
        : Duration(days: value);
  }

  String _getEndTimeFormatted() {
    final now = DateTime.now();
    final endTime = now.add(_currentDuration);
    return DateFormat('dd/MM/yyyy HH:mm').format(endTime);
  }

  void _validateAndNotify() {
    final now = DateTime.now();
    final endTime = now.add(_currentDuration);
    int value = int.tryParse(_valueController.text) ?? 0;

    if (endTime.isAfter(widget.deliveryDateTime)) {
      setState(() {
        _errorText = 'Durasi melebihi waktu pengiriman!';
      });
    } else {
      setState(() {
        _errorText = null;
      });
      widget.onDurationChanged?.call(_selectedUnit, value);
    }
  }

  @override
  void initState() {
    super.initState();
    _valueController =
        TextEditingController(text: widget.initialValue.toString());

    // Jangan panggil provider setter di sini!
    // Hanya set local state saja
    if (widget.initialUnit.toLowerCase() == 'jam') {
      _selectedUnit = 'Jam';
    } else if (widget.initialUnit.toLowerCase() == 'hari') {
      _selectedUnit = 'Hari';
    } else {
      _selectedUnit = 'Jam';
    }
    // _validateAndNotify(); // Hapus ini dari initState!
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Durasi Lelang'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                enabled: !widget.readOnly,
                decoration: InputDecoration(
                  hintText: 'Durasi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) => _validateAndNotify(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: _selectedUnit,
                items: const [
                  DropdownMenuItem(value: 'Jam', child: Text('Jam')),
                  DropdownMenuItem(value: 'Hari', child: Text('Hari')),
                ],
                onChanged: widget.readOnly
                    ? null
                    : (val) {
                        setState(() {
                          _selectedUnit = val!;
                        });
                        _validateAndNotify();
                      },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              const Icon(Icons.timer_outlined, color: Colors.grey),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Jam Lelang Berakhir:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                _getEndTimeFormatted(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorText!,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ],
    );
  }
}
