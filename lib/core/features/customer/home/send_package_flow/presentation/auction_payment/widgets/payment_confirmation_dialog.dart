import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class PaymentConfirmationDialog extends StatefulWidget {
  final Function(File) onConfirm;
  final String amount;
  final String driverName;
  final String driverAvatar;
  final String bankName;
  final String accountNumber;
  final String accountHolder;

  const PaymentConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.amount,
    required this.driverName,
    required this.driverAvatar,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
  });

  @override
  State<PaymentConfirmationDialog> createState() =>
      _PaymentConfirmationDialogState();
}

class _PaymentConfirmationDialogState extends State<PaymentConfirmationDialog> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Konfirmasi Pembayaran',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lampirkan bukti pembayaran sebesar:',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.amount,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(widget.driverAvatar),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.driverName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Container rekening
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/icons/bni.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(widget.bankName),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Text('Nomor Rekening'),
                      const Spacer(),
                      Text(widget.accountNumber),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 16),
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.accountNumber));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Nomor rekening disalin')),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Text('A/N'),
                      const Spacer(),
                      Text(widget.accountHolder),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Instruksi Pembayaran:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
                '1. Bayar ke Rekening Bank BNI di atas, dengan atas nama ECARRGO INDONESIA.'),
            const Text('2. Masukan jumlah yang di transfer Rp. 1.000.000.'),
            const Text(
                '3. Lampirkan pembayaran pada tombol lampiran di bawah, pastikan gambar terlihat jelas.'),
            const Text(
                '4. Tunggu kami untuk konfirmasi pembayaran, dan Anda akan diinformasi kembali.'),
            const SizedBox(height: 20),

            // Tombol Upload bukti pembayaran
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.link, color: Colors.white),
                label: const Text(
                  'Bukti Pembayaran',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            // Preview gambar jika sudah pilih
            if (_selectedImage != null) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.edit, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Ganti',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Tombol bawah
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Kembali'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedImage != null
                        ? () {
                            widget.onConfirm(_selectedImage!);
                            Navigator.pop(context, true);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedImage != null
                          ? Colors.blue
                          : Colors.grey[300],
                      foregroundColor: _selectedImage != null
                          ? Colors.white
                          : Colors.grey[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Konfirmasi'),
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
