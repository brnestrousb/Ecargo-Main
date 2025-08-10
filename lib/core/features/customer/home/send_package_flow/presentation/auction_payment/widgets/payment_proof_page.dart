import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentProofPage extends StatelessWidget {
  final Map<String, dynamic>? shipmentData;
  const PaymentProofPage({super.key, this.shipmentData});

  @override
  Widget build(BuildContext context) {
    final payments = shipmentData?['payments'] as List<dynamic>? ?? [];
    final payment = payments.isNotEmpty ? payments.first : null;

    final paymentId = payment?['id']?.toString() ?? '-';
    final paymentAmount =
        payment?['amount'] != null ? "Rp ${payment?['amount']}" : '-';
    final paymentStatus = payment?['status'] ?? '-';
    final paymentMethod = payment?['payment_method'] ?? '-';
    final paymentDate = payment?['created_at'] ?? '-';
    final paymentImageUrl = payment?['transaction_id'] != null
        ? "https://yourdomain.com/payments/${payment?['transaction_id']}"
        : "";

    final resiNumber = shipmentData?['resi_number'] ?? '-';
    final pickupAddress = shipmentData?['pickup_address'] ?? '-';
    final deliveryAddress = shipmentData?['delivery_address'] ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bukti Pembayaran'),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Icon(Icons.receipt_long,
                    size: 56, color: Colors.green.shade700),
                const SizedBox(height: 8),
                Text(
                  'Detail Pembayaran',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Info pembayaran
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoTile("ID Pembayaran", paymentId,
                      isCopyable: true, context: context),
                  _infoTile("Jumlah", paymentAmount, context: context),
                  _infoTile("Status", paymentStatus, context: context),
                  _infoTile("Metode", paymentMethod, context: context),
                  _infoTile("Tanggal Transfer", paymentDate, context: context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Info pengiriman
          Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _infoTile("Nomor Resi", resiNumber, context: context),
                  _infoTile("Alamat Jemput", pickupAddress, context: context),
                  _infoTile("Alamat Tujuan", deliveryAddress, context: context),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Bukti pembayaran (gambar)
          if (paymentImageUrl.isNotEmpty)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Bukti Transfer',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        _showPaymentImageModal(context, paymentImageUrl);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          paymentImageUrl,
                          height: 160,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            height: 160,
                            color: Colors.grey[200],
                            child: const Center(
                                child: Icon(Icons.broken_image, size: 40)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Klik gambar untuk memperbesar',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget baris info yang responsif
  Widget _infoTile(String label, String value,
      {bool isCopyable = false, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCopyable)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('ID Pembayaran berhasil disalin')),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 18, color: Colors.blue),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modal untuk gambar bukti pembayaran
  void _showPaymentImageModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: const Center(
                          child: Icon(Icons.broken_image, size: 40)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
